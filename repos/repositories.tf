locals {
  repositories = {
    infrastructure = { description = "Terraform configuration for my personal infrastructure (GitHub)." }
    homelab        = { description = "Ansible playbooks for my self-hosted services." }
    dotfiles       = { description = "Nix configurations for my machines (NixOS, Darwin, WSL)." }
    templates      = { description = "A mise-managed, agent-ready starting point for a new project, in any language. Preconfigured for Matt Pocock's skills." }

    portfolio = {
      description            = "My personal portfolio website."
      homepage_url           = "https://eugen.codes"
      required_status_checks = ["ci"]
    }

    deepswe-enhanced = {
      description            = "Combines the DeepSWE leaderboard with OpenRouter throughput data and SemiAnalysis subscription research to compare models by effective cost, speed, and bang for buck."
      homepage_url           = "https://deepswe.eugen.codes"
      required_status_checks = ["ready", "e2e"]
    }
  }
}

resource "github_repository" "this" {
  for_each = local.repositories

  name         = each.key
  description  = each.value.description
  homepage_url = try(each.value.homepage_url, null)
  visibility   = "public"

  has_issues   = true
  has_wiki     = true
  has_projects = false

  allow_rebase_merge     = false
  allow_squash_merge     = false
  allow_auto_merge       = true
  delete_branch_on_merge = true
}
