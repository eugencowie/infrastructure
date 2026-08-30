import {
  for_each = local.repositories
  to       = github_repository.this[each.key]
  id       = each.key
}
