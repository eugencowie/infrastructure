# Infrastructure

Terraform configuration for personal infrastructure.

## Language

### Repos

**Adoption**:
Bringing a GitHub repository that already exists under desired-state management, by importing its current resources into Terraform state. A one-time migration, distinct from the desired state itself: adoption leaves no trace in configuration once complete.
_Avoid_: "importing a repo" for the whole workflow — import is the mechanism, adoption is the operation.

**Label**:
A GitHub repository label, applied to pull requests to classify the change by conventional-commit type (`feat`, `fix`, `docs`, …). A fixed set, identical across all managed repositories, held as desired state.
_Avoid_: "triage label" — labels never carry triage state.

**Triage status**:
The workflow state of a local ticket (`needs-triage`, `ready-for-agent`, …), recorded in the ticket file itself. Not a Label and never present on GitHub.
