locals {
  repositories = {
    infrastructure = { visibility = "public", description = "Terraform configuration for my personal infrastructure." }
    homelab        = { visibility = "public", description = "Ansible playbooks for my self-hosted services." }
    dotfiles       = { visibility = "public", description = "Nix configurations for my machines (NixOS, Darwin, WSL)." }
    templates      = { visibility = "public", description = "A mise-managed, agent-ready starting point for a new project, in any language. Preconfigured for Matt Pocock's skills." }
  }
}

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
