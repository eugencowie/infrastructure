locals {
  repositories = {
    infrastructure = { visibility = "public", description = "Terraform configuration for my personal infrastructure (GitHub)." }
    homelab        = { visibility = "public", description = "Ansible playbooks for my self-hosted services." }
    dotfiles       = { visibility = "public", description = "Nix configurations for my machines (NixOS, Darwin, WSL)." }
    templates      = { visibility = "public", description = "A mise-managed, agent-ready starting point for a new project, in any language. Preconfigured for Matt Pocock's skills." }

    deepswe-extended = {
      visibility             = "public"
      description            = ""
      homepage_url           = "https://eugencowie.github.io/deepswe-extended/"
      merge_commit_title     = "PR_TITLE"
      merge_commit_message   = "PR_BODY"
      required_status_checks = ["ready", "e2e"]
    }
  }
}

resource "github_repository" "this" {
  for_each = local.repositories

  name         = each.key
  description  = each.value.description
  homepage_url = try(each.value.homepage_url, null)
  visibility   = each.value.visibility

  has_issues   = true
  has_wiki     = true
  has_projects = false

  allow_rebase_merge     = false
  allow_squash_merge     = false
  allow_auto_merge       = true
  delete_branch_on_merge = true
  merge_commit_title     = try(each.value.merge_commit_title, null)
  merge_commit_message   = try(each.value.merge_commit_message, null)
}
