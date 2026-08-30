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
  }
}
