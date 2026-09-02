# Adoption imports are transient, not committed desired state

The repository adoption workflow (`mise run repos:adopt`) generates Terraform `import` blocks into an `imports.tf` that is deleted when the script exits, rather than committing those blocks to the repository. HashiCorp sanctions leaving import blocks in configuration as a record of a resource's origin, but this repo models the desired state of the GitHub repositories: an apply must be idempotent from any clone. Committed import blocks encode one operator's pre-existing GitHub state — under a fresh clone or different `gh` credentials the referenced repositories and ruleset IDs may not exist, and the plan would fail. Adoption is therefore a one-time migration that leaves no trace in configuration.

## Considered options

- **Commit `imports.tf` as a permanent record** — rejected for the idempotency reason above.
- **Untracked `imports.tf` with a `.gitignore` entry** — rejected; the trap-deleted transient file needs no ignore entry.
