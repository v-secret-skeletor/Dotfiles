#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Codespaces Dotfiles Bootstrap
# This script is executed automatically by GitHub Codespaces after cloning
# the dotfiles repository. It installs tools, symlinks configs, and sets up
# the shell environment.
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_PREFIX="[dotfiles]"

log() { echo "$LOG_PREFIX $*"; }
warn() { echo "$LOG_PREFIX [WARN] $*" >&2; }
err() { echo "$LOG_PREFIX [ERROR] $*" >&2; }

# ---------------------------------------------------------------------------
# 1. System packages
# ---------------------------------------------------------------------------
log "Installing system packages..."
sudo apt-get update -qq
sudo apt-get install -y -qq \
  build-essential \
  cmake \
  curl \
  fd-find \
  jq \
  ripgrep \
  unzip \
  wget \
  zsh

# Symlink fdfind -> fd (Debian names it fdfind)
if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
  sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
fi

# ---------------------------------------------------------------------------
# 2. Neovim (latest stable from GitHub releases — need 0.11+)
# ---------------------------------------------------------------------------
install_neovim() {
  if command -v nvim &>/dev/null; then
    local current
    current="$(nvim --version | head -1 | grep -oP 'v\K[0-9]+\.[0-9]+')"
    if awk "BEGIN{exit !($current >= 0.11)}"; then
      log "Neovim $(nvim --version | head -1) already installed, skipping."
      return
    fi
  fi

  log "Installing Neovim..."
  local nvim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL "$nvim_url" -o "$tmp/nvim.tar.gz"
  sudo tar -xzf "$tmp/nvim.tar.gz" -C /usr/local --strip-components=1
  rm -rf "$tmp"
  log "Neovim $(nvim --version | head -1) installed."
}
install_neovim

# ---------------------------------------------------------------------------
# 3. lazygit
# ---------------------------------------------------------------------------
install_lazygit() {
  if command -v lazygit &>/dev/null; then
    log "lazygit already installed, skipping."
    return
  fi

  log "Installing lazygit..."
  local version
  version="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r '.tag_name' | sed 's/^v//')"
  local url="https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_x86_64.tar.gz"
  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL "$url" -o "$tmp/lazygit.tar.gz"
  tar -xzf "$tmp/lazygit.tar.gz" -C "$tmp"
  sudo install "$tmp/lazygit" /usr/local/bin/lazygit
  rm -rf "$tmp"
  log "lazygit ${version} installed."
}
install_lazygit

# ---------------------------------------------------------------------------
# 4. yazi
# ---------------------------------------------------------------------------
install_yazi() {
  if command -v yazi &>/dev/null; then
    log "yazi already installed, skipping."
    return
  fi

  log "Installing yazi (building from source — prebuilt binaries require glibc ≥2.39)..."

  # Install Rust toolchain if not present
  if ! command -v cargo &>/dev/null; then
    log "Installing Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --quiet
    # shellcheck source=/dev/null
    source "$HOME/.cargo/env"
  fi

  cargo install --force yazi-build

  # Place binaries on the system PATH so they're available without cargo env
  sudo install "$HOME/.cargo/bin/yazi" /usr/local/bin/yazi
  sudo install "$HOME/.cargo/bin/ya" /usr/local/bin/ya
  log "yazi installed."
}
install_yazi

# ---------------------------------------------------------------------------
# 5. zoxide
# ---------------------------------------------------------------------------
install_zoxide() {
  if command -v zoxide &>/dev/null; then
    log "zoxide already installed, skipping."
    return
  fi

  log "Installing zoxide..."
  curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  log "zoxide installed."
}
install_zoxide

# ---------------------------------------------------------------------------
# 6. oh-my-zsh
# ---------------------------------------------------------------------------
install_ohmyzsh() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    log "oh-my-zsh already installed, skipping."
    return
  fi

  log "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  log "oh-my-zsh installed."
}
install_ohmyzsh

# ---------------------------------------------------------------------------
# 7. Symlink / copy configs
# ---------------------------------------------------------------------------
log "Linking configuration files..."

# Ensure ~/.config exists
mkdir -p "$HOME/.config"

# Neovim config
if [ -L "$HOME/.config/nvim" ] || [ -d "$HOME/.config/nvim" ]; then
  rm -rf "$HOME/.config/nvim"
fi
ln -sf "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
log "  nvim → ~/.config/nvim"

# Yazi config
if [ -L "$HOME/.config/yazi" ] || [ -d "$HOME/.config/yazi" ]; then
  rm -rf "$HOME/.config/yazi"
fi
ln -sf "$DOTFILES_DIR/config/yazi" "$HOME/.config/yazi"
log "  yazi → ~/.config/yazi"

# .vimrc
ln -sf "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
log "  vimrc → ~/.vimrc"

# .gitconfig
ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
log "  gitconfig → ~/.gitconfig"

# .zshrc
ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
log "  zshrc → ~/.zshrc"

# Aliases — place in a stable location the zshrc can source
mkdir -p "$HOME/.config/dotfiles"
ln -sf "$DOTFILES_DIR/aliases.zsh" "$HOME/.config/dotfiles/aliases.zsh"
log "  aliases → ~/.config/dotfiles/aliases.zsh"

# Copilot CLI config and skills
mkdir -p "$HOME/.copilot"
cp -r "$DOTFILES_DIR/copilot/." "$HOME/.copilot/"
log "  copilot → ~/.copilot"

# ---------------------------------------------------------------------------
# 8. vim-plug plugin install (headless)
# ---------------------------------------------------------------------------
log "Installing neovim plugins via vim-plug (headless)..."
nvim --headless +PlugInstall +qall 2>/dev/null || warn "PlugInstall had warnings — plugins may need manual review."
log "Neovim plugins installed."

# ---------------------------------------------------------------------------
# 9. yazi plugin install
# ---------------------------------------------------------------------------
log "Installing yazi plugins..."
if command -v ya &>/dev/null; then
  ya pack -i 2>/dev/null || warn "ya pack -i had warnings — yazi plugins may need manual review."
  log "Yazi plugins installed."
else
  warn "ya not found, skipping yazi plugin install."
fi

# ---------------------------------------------------------------------------
# 10. Set default shell to zsh
# ---------------------------------------------------------------------------
if [ "$SHELL" != "$(which zsh)" ]; then
  log "Setting default shell to zsh..."
  sudo chsh -s "$(which zsh)" "$(whoami)" 2>/dev/null || warn "Could not change default shell to zsh."
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
log "Dotfiles bootstrap complete."
