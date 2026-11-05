# Agent Instructions

## Domain Docs

See the glossary in [context.md](docs/context.md) and the ADRs in [architecture](docs/architecture/).

## Development environment

This project uses mise to manage the development environment.

- Run `mise tasks` to see the available tasks.
- Use `mise run <task>` for standard operations.
- Run `mise ls -l` to see the managed tools.
- When invoking a managed tool directly, use `mise exec -- <command> [args]` rather than invoking the tool by its bare name.
