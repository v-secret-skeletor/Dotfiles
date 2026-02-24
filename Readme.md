# Codespaces Dotfiles

Neovim, yazi, and zoxide — configured for GitHub Codespaces.

## What This Does

When a codespace is created with this repo set as your dotfiles repository, `install.sh` runs automatically and:

- Installs **Neovim** (0.11+), **yazi**, **zoxide**, **lazygit**, and **oh-my-zsh**
- Symlinks all configs (`nvim`, `yazi`, `zsh`, `git`, `vim`) into place
- Installs Neovim plugins via vim-plug and yazi plugins via `ya pack`
- Sets zsh as the default shell

## Connecting to a Codespace with Neovim

Once your codespace is running, connect to it from your local terminal using the GitHub CLI:

```sh
# List your running codespaces
gh codespace list

# SSH into a running codespace
gh codespace ssh -c <codespace-name>

# Or connect and open nvim directly
gh codespace ssh -c <codespace-name> -- -t 'cd /workspaces/* && nvim .'
```

Replace `<codespace-name>` with the name from `gh codespace list`.

> **Tip:** The glob `/workspaces/*` expands to your repository directory inside the codespace. If you have multiple repos, replace it with the specific path (e.g., `/workspaces/my-repo`).

### Port Forwarding (Accessing Web Apps)

If your codespace runs a web server, forward the port back to your local machine:

```sh
# From a second local terminal, forward port 3000
gh codespace ports forward 3000:3000 -c <codespace-name>

# Or include port forwarding when you SSH in
gh codespace ssh -c <codespace-name> -- -L 3000:localhost:3000
```

Then open `localhost:3000` in your local browser.

To expose a public URL instead:

```sh
gh codespace ports visibility 3000:public -c <codespace-name>
```

This provides a shareable `*.app.github.dev` URL. Use `gh codespace ports -c <codespace-name>` to list all forwarded ports and their URLs.

### Prerequisites

- [GitHub CLI](https://cli.github.com/) (`gh`) installed locally
- Authenticated via `gh auth login`
- A running codespace (create one from the repo page or with `gh codespace create`)

### Setting This Repo as Your Dotfiles

Go to [github.com/settings/codespaces](https://github.com/settings/codespaces), enable **Automatically install dotfiles**, and select this repository.

## Tools Installed

| Tool | Purpose |
|------|---------|
| [Neovim](https://neovim.io/) | Editor |
| [yazi](https://yazi-rs.github.io/) | Terminal file manager |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI |
| [oh-my-zsh](https://ohmyz.sh/) | Zsh framework |

## Key Aliases

| Alias | Expands To |
|-------|------------|
| `n` | `nvim .` |
| `cd` | `z` (zoxide) |
| `ls` | `y` (yazi) |
| `vim` | `nvim` |
| `pr` | `gh pr create --fill` |
