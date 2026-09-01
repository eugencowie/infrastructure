#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: mise run repos:adopt -- <repository>" >&2
}

if [[ $# -ne 1 ]]; then
  usage
  exit 2
fi

repository=$1

if [[ ! $repository =~ ^[A-Za-z0-9._-]+$ ]]; then
  echo "Repository names may contain only letters, numbers, dots, underscores, and hyphens." >&2
  exit 2
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "The GitHub CLI is required to inspect the remote repository and its rulesets." >&2
  exit 1
fi

owner=${GITHUB_OWNER:-$(gh api user --jq .login)}

if ! gh api --silent "repos/$owner/$repository"; then
  echo "GitHub repository '$owner/$repository' does not exist or is not accessible." >&2
  exit 1
fi

ruleset_id=$(
  gh api --paginate "repos/$owner/$repository/rulesets" \
    --jq '.[] | select(.name == "Default branch" and .target == "branch") | .id'
)

imports_file=imports.tf

if [[ -e $imports_file ]]; then
  echo "An '$imports_file' already exists. Remove it before adopting." >&2
  exit 1
fi

trap 'rm -f "$imports_file"' EXIT

cat > "$imports_file" <<EOF
import {
  to = github_repository.this["$repository"]
  id = "$repository"
}

import {
  to = github_issue_labels.this["$repository"]
  id = "$repository"
}
EOF

if [[ -n $ruleset_id ]]; then
  cat >> "$imports_file" <<EOF

import {
  to = github_repository_ruleset.this["$repository"]
  id = "$repository:$ruleset_id"
}
EOF
else
  echo "No existing 'Default branch' branch ruleset found. Terraform will create it."
fi

echo "Importing issue labels. Terraform will own the repository's complete label set."
echo "The apply will set or replace the RENOVATE_TOKEN secret."

terraform apply

echo "Adoption complete."
