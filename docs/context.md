# Infrastructure

Managing personal GitHub repositories as desired state.

## Language

### Core concepts

**Adoption**:
Bringing a GitHub repository that already exists under desired-state management, by importing its current resources into Terraform state. A one-time migration, distinct from the desired state itself: adoption leaves no trace in configuration once complete.
_Avoid_: "importing a repo" for the whole workflow — import is the mechanism, adoption is the operation.
