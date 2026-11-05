# infrastructure

Terraform configuration for my GitHub repositories: settings, the default branch ruleset, labels and the `RENOVATE_TOKEN` Actions secret.

## Structure

- `repos/` - Terraform configuration for the repositories, with local state
- `scripts/` - Helpers behind mise tasks
- `docs/` - ADRs in `architecture/`

## Development Tasks

- `mise run lint` - Lint workflows, scripts and repos configuration
- `mise run repos:init` - Initialise repos state
- `mise run repos:fmt` - Format repos configuration
- `mise run repos:plan` - Plan repos changes
- `mise run repos:apply` - Apply repos changes
- `mise run repos:adopt <repository>` - Import an existing repository, then apply
