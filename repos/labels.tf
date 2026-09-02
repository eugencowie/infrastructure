locals {
  labels = {
    chore    = { color = "cfd3d7", description = "Routine maintenance and housekeeping" }
    ci       = { color = "ffffff", description = "Changes to CI workflows or automation" }
    docs     = { color = "0075ca", description = "Improvements or additions to documentation" }
    feat     = { color = "a2eeef", description = "New feature or request" }
    fix      = { color = "d73a4a", description = "Something isn't working" }
    perf     = { color = "008672", description = "Improvements to performance or efficiency" }
    refactor = { color = "7057ff", description = "Code changes that do not alter behaviour" }
    security = { color = "e4e669", description = "Security fixes or improvements" }
    style    = { color = "d876e3", description = "Formatting or styling changes" }
    test     = { color = "bfd4f2", description = "Improvements or additions to tests" }
  }
}

resource "github_issue_labels" "this" {
  for_each   = local.repositories
  repository = github_repository.this[each.key].id

  dynamic "label" {
    for_each = local.labels
    content {
      name        = label.key
      description = label.value.description
      color       = label.value.color
    }
  }
}
