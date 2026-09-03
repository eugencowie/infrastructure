resource "github_repository_ruleset" "this" {
  for_each   = local.repositories
  repository = github_repository.this[each.key].id

  name        = "Default branch"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      allowed_merge_methods = ["merge"]
    }

    dynamic "required_status_checks" {
      for_each = try([each.value.required_status_checks], [])
      content {
        dynamic "required_check" {
          for_each = required_status_checks.value
          content {
            context        = required_check.value
            integration_id = 15368 # GitHub Actions
          }
        }
      }
    }
  }
}
