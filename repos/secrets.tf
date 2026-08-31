variable "renovate_token" {
  type      = string
  sensitive = true
}

resource "github_actions_secret" "renovate_token" {
  for_each   = local.repositories
  repository = github_repository.this[each.key].name

  secret_name = "RENOVATE_TOKEN"
  value       = var.renovate_token
}
