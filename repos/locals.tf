locals {
  repositories = {

    "infrastructure" = {
      description = ""
      visibility  = "public"
    }

    "homelab" = {
      description = ""
      visibility  = "public"
    }

    "dotfiles" = {
      description = "Nix configurations for my machines (NixOS, Darwin, WSL)."
      visibility  = "public"
    }

    "templates" = {
      description = "A mise-managed, agent-ready starting point for a new project, in any language. Preconfigured for Matt Pocock's skills."
      visibility  = "public"
    }

  }
}
