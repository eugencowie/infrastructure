locals {
  repositories = {
    "infrastructure" = {
      description = ""
      visibility  = "public"
    }
  }
}

resource "github_repository" "this" {
  for_each     = local.repositories
  name         = each.key
  description  = each.value.description
  visibility   = each.value.visibility
  has_issues   = true
  has_projects = true
  has_wiki     = true
}
