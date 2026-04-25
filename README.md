# bootstrap

Public bootstrap entrypoint for [@fcusson](https://github.com/fcusson)'s dotfiles setup.

## Purpose

This script installs the minimum required tooling to authenticate with GitHub and initialize [chezmoi](https://chezmoi.io) against a private dotfiles repository. It is not useful to anyone who does not have access to that private repository.

## Supported Systems

| Distro | Package Manager |
|--------|----------------|
| Fedora | dnf |
| AlmaLinux / Rocky Linux / RHEL | dnf |
| Raspberry Pi OS (Raspbian) | apt |

## Usage

```bash
curl -sS https://raw.githubusercontent.com/fcusson/bootstrap/main/install.sh | bash
```

The script will:

1. Install `git`, `gh`, and `chezmoi` for your distro
2. Prompt you to authenticate with GitHub via `gh auth login`
3. Clone and apply the private dotfiles repository via chezmoi

## Requirements

Access to the private `fcusson/dotfiles` repository is required. The script
will fail at the chezmoi init step without it.
