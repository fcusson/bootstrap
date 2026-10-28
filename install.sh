#!/bin/bash
set -e

# Detect distro
if [ ! -f /etc/os-release ]; then
    echo "ERROR: Cannot detect OS, /etc/os-release not found" >&2
    exit 1
fi

. /etc/os-release

case "$ID" in
    fedora)
        sudo dnf install -y git gh chezmoi
        ;;
    almalinux|rocky|rhel)
        sudo dnf install -y epel-release
        sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
        sudo dnf install -y git gh chezmoi
        ;;
    # Raspberry Pi OS reports ID=debian since Bookworm, raspbian before that
    debian|raspbian|ubuntu)
        sudo apt update
        sudo apt install -y curl git
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
            | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
            | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install -y gh
        # chezmoi isn't packaged in older Debian releases (e.g. Bookworm)
        if ! sudo apt install -y chezmoi; then
            sudo sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin
        fi
        ;;
    *)
        echo "ERROR: Unsupported distro '$ID'" >&2
        exit 1
        ;;
esac

gh auth login
gh auth setup-git
chezmoi init "https://github.com/fcusson/dotfiles.git"
chezmoi apply
