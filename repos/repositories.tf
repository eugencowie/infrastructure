locals {
  repositories = {
    infrastructure = { description = "Terraform configuration for my personal infrastructure (GitHub)." }
    homelab        = { description = "Ansible playbooks for my self-hosted services.", merge_method = "squash" }
    dotfiles       = { description = "Nix configurations for my machines (NixOS, Darwin, WSL)." }
    templates      = { description = "A mise-managed, agent-ready starting point for a new project, in any language. Preconfigured for Matt Pocock's skills." }

    portfolio = {
      description            = "My personal portfolio website."
      homepage_url           = "https://eugen.codes"
      required_status_checks = ["validate"]
    }

    deepswe-enhanced = {
      description            = "Combines the DeepSWE leaderboard with OpenRouter throughput data and SemiAnalysis subscription research to compare models by effective cost, speed, and bang for buck."
      homepage_url           = "https://deepswe.eugen.codes"
      required_status_checks = ["validate"]
    }

    aptabase-rs = {
      description            = "Rust SDK for Aptabase: Open Source, Privacy-First and Simple Analytics for Mobile, Desktop and Web Apps"
      homepage_url           = "https://crates.io/crates/aptabase-rs"
      required_status_checks = ["Check", "Check example"]
    }
  }

  merge_methods = { for name, repo in local.repositories : name => try(repo.merge_method, "merge") }
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

  allow_merge_commit     = local.merge_methods[each.key] == "merge"
  allow_rebase_merge     = false
  allow_squash_merge     = local.merge_methods[each.key] == "squash"
  allow_auto_merge       = true
  delete_branch_on_merge = true

  squash_merge_commit_title   = local.merge_methods[each.key] == "squash" ? "PR_TITLE" : null
  squash_merge_commit_message = local.merge_methods[each.key] == "squash" ? "PR_BODY" : null
}
