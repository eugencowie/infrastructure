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

configured=$(terraform console <<EOF
contains(keys(local.repositories), "$repository")
EOF
)

if [[ $configured != "true" ]]; then
  echo "Repository '$repository' is not present in local.repositories." >&2
  echo "Add it to repos/locals.tf before adopting it." >&2
  exit 1
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

repository_address="github_repository.this[\"$repository\"]"
labels_address="github_issue_labels.this[\"$repository\"]"
ruleset_address="github_repository_ruleset.this[\"$repository\"]"
secret_address="github_actions_secret.renovate_token[\"$repository\"]"
if ! state_resources=$(terraform state list 2>&1); then
  if [[ $state_resources == *"No state file was found"* ]]; then
    state_resources=""
  else
    echo "$state_resources" >&2
    exit 1
  fi
fi

in_state() {
  grep -Fxq "$1" <<<"$state_resources"
}

ruleset_id=""

if ! in_state "$ruleset_address"; then
  ruleset_output=$(
    gh api --paginate "repos/$owner/$repository/rulesets" \
      --jq '.[] | select(.name == "Default branch" and .target == "branch") | .id'
  )

  ruleset_ids=()
  if [[ -n $ruleset_output ]]; then
    mapfile -t ruleset_ids <<<"$ruleset_output"
  fi

  if [[ ${#ruleset_ids[@]} -gt 1 ]]; then
    echo "More than one branch ruleset named 'Default branch' exists in '$owner/$repository'." >&2
    printf "Matching ruleset IDs: %s\n" "${ruleset_ids[*]}" >&2
    echo "Resolve the duplicate or import the intended ruleset manually." >&2
    exit 1
  fi

  if [[ ${#ruleset_ids[@]} -eq 1 ]]; then
    ruleset_id=${ruleset_ids[0]}
  fi
fi

if in_state "$repository_address"; then
  echo "Repository is already in state."
else
  terraform import "$repository_address" "$repository"
  state_resources+=$'\n'"$repository_address"
fi

if in_state "$labels_address"; then
  echo "Issue labels are already in state."
else
  echo "Importing issue labels. Terraform will own the repository's complete label set."
  terraform import "$labels_address" "$repository"
  state_resources+=$'\n'"$labels_address"
fi

if in_state "$ruleset_address"; then
  echo "Default branch ruleset is already in state."
elif [[ -n $ruleset_id ]]; then
  terraform import "$ruleset_address" "$repository:$ruleset_id"
  state_resources+=$'\n'"$ruleset_address"
else
  echo "No existing 'Default branch' branch ruleset found. Terraform will create it."
fi

if in_state "$secret_address"; then
  echo "Renovate secret is already in state."
else
  echo "The next apply will set or replace the RENOVATE_TOKEN secret."
fi

echo "Adoption complete. Review the result with 'mise run repos:plan'."
