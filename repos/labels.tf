resource "github_issue_labels" "this" {
  for_each   = local.repositories
  repository = github_repository.this[each.key].id

  label {
    name        = "chore"
    description = "Routine maintenance and housekeeping"
    color       = "cfd3d7"
  }

  label {
    name        = "ci"
    description = "Changes to CI workflows or automation"
    color       = "ffffff"
  }

  label {
    name        = "docs"
    description = "Improvements or additions to documentation"
    color       = "0075ca"
  }

  label {
    name        = "feat"
    description = "New feature or request"
    color       = "a2eeef"
  }

  label {
    name        = "fix"
    description = "Something isn't working"
    color       = "d73a4a"
  }

  label {
    name        = "perf"
    description = "Improvements to performance or efficiency"
    color       = "008672"
  }

  label {
    name        = "refactor"
    description = "Code changes that do not alter behaviour"
    color       = "7057ff"
  }

  label {
    name        = "security"
    description = "Security fixes or improvements"
    color       = "e4e669"
  }

  label {
    name        = "style"
    description = "Formatting or styling changes"
    color       = "d876e3"
  }

  label {
    name        = "test"
    description = "Improvements or additions to tests"
    color       = "bfd4f2"
  }
}
