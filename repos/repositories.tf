resource "github_repository" "this" {
  for_each = local.repositories

  name        = each.key
  description = each.value.description
  visibility  = each.value.visibility

  has_issues   = true
  has_wiki     = true
  has_projects = false

  allow_rebase_merge     = false
  allow_squash_merge     = false
  allow_auto_merge       = true
  delete_branch_on_merge = true
}
