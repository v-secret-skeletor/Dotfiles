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

FAILED_INSTALLS=()

# Run an installer in a subshell with retries. If all attempts fail the
# failure is recorded but the script continues.
#   safe_install <label> <function> [max_attempts]
safe_install() {
  local name="$1"
  local func="$2"
  local max_attempts="${3:-3}"
  local attempt=1
  local rc

  while [ "$attempt" -le "$max_attempts" ]; do
    rc=0
    ("$func") || rc=$?
    if [ "$rc" -eq 0 ]; then
      return 0
    fi
    if [ "$attempt" -lt "$max_attempts" ]; then
      warn "$name: attempt $attempt/$max_attempts failed (exit $rc). Retrying in 5s..."
      sleep 5
    fi
    ((attempt++))
  done

  warn "$name installation failed after $max_attempts attempts — continuing."
  FAILED_INSTALLS+=("$name")
}

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
  npm \
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
safe_install "neovim" install_neovim

# ---------------------------------------------------------------------------
# 3. lazygit
# ---------------------------------------------------------------------------
install_lazygit() {
  if command -v lazygit &>/dev/null; then
    log "lazygit already installed, skipping."
    return
  fi

  log "Installing lazygit..."
  local latest_url
  latest_url="$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/jesseduffield/lazygit/releases/latest)"
  local version="${latest_url##*/v}"
  local url="https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_x86_64.tar.gz"
  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL "$url" -o "$tmp/lazygit.tar.gz"
  tar -xzf "$tmp/lazygit.tar.gz" -C "$tmp"
  sudo install "$tmp/lazygit" /usr/local/bin/lazygit
  rm -rf "$tmp"
  log "lazygit ${version} installed."
}
safe_install "lazygit" install_lazygit

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
safe_install "yazi" install_yazi

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
safe_install "zoxide" install_zoxide

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
safe_install "oh-my-zsh" install_ohmyzsh

# ---------------------------------------------------------------------------
# 7. Ruby (>= 3.2 for ruby-lsp / solargraph compatibility)
# ---------------------------------------------------------------------------
install_ruby() {
  local min_version="3.2"

  if command -v ruby &>/dev/null; then
    local current
    current="$(ruby -e 'puts RUBY_VERSION')"
    if [ "$(printf '%s\n' "$min_version" "$current" | sort -V | head -n1)" = "$min_version" ]; then
      log "Ruby $current already installed (>= $min_version), skipping."
      return
    fi
  fi

  log "Installing Ruby >= ${min_version} via ruby-install..."

  local ri_version="0.9.4"
  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL "https://github.com/postmodern/ruby-install/releases/download/v${ri_version}/ruby-install-${ri_version}.tar.gz" \
    -o "$tmp/ruby-install.tar.gz"
  tar -xzf "$tmp/ruby-install.tar.gz" -C "$tmp"
  sudo make -C "$tmp/ruby-install-${ri_version}" install
  rm -rf "$tmp"

  sudo ruby-install --system ruby
  log "Ruby $(ruby --version) installed."
}
safe_install "ruby" install_ruby

# ---------------------------------------------------------------------------
# 8. Node.js & npm (needed for TypeScript / JavaScript LSPs)
# ---------------------------------------------------------------------------
install_node() {

  sudo npm install -g n 
  sudo n 22
  log "Node.js $(node --version), npm $(npm --version) installed."
}
safe_install "node" install_node

# ---------------------------------------------------------------------------
# 9. Nerd Fonts (JetBrainsMono)
# ---------------------------------------------------------------------------
install_nerdfonts() {
  local font_dir="/usr/local/share/fonts/NerdFonts"

  if fc-list | grep -qi "JetBrainsMono" 2>/dev/null; then
    log "JetBrainsMono Nerd Font already installed, skipping."
    return
  fi

  log "Installing JetBrainsMono Nerd Font..."
  local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL "$url" -o "$tmp/JetBrainsMono.zip"
  sudo mkdir -p "$font_dir"
  sudo unzip -oq "$tmp/JetBrainsMono.zip" -d "$font_dir"
  rm -rf "$tmp"
  sudo fc-cache -f
  log "JetBrainsMono Nerd Font installed."
}
safe_install "nerdfonts" install_nerdfonts

# ---------------------------------------------------------------------------
# 10. tree-sitter CLI
# ---------------------------------------------------------------------------
install_tree_sitter() {
  if command -v tree-sitter &>/dev/null; then
    log "tree-sitter CLI already installed, skipping."
    return
  fi

  log "Installing tree-sitter CLI..."

  # Ensure Rust toolchain is available (installed during yazi step)
  if ! command -v cargo &>/dev/null; then
    if [ -f "$HOME/.cargo/env" ]; then
      # shellcheck source=/dev/null
      source "$HOME/.cargo/env"
    else
      log "Installing Rust toolchain..."
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --quiet
      # shellcheck source=/dev/null
      source "$HOME/.cargo/env"
    fi
  fi

  cargo install tree-sitter-cli

  sudo install "$HOME/.cargo/bin/tree-sitter" /usr/local/bin/tree-sitter
  log "tree-sitter CLI $(tree-sitter --version) installed."
}
safe_install "tree-sitter" install_tree_sitter

# ---------------------------------------------------------------------------
# 11. Symlink / copy configs
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

# .gitignore_global
cp "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
log "  gitignore_global → ~/.gitignore_global"

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
# 12. vim-plug plugin install (headless)
# ---------------------------------------------------------------------------
log "Installing neovim plugins via vim-plug (headless)..."
nvim --headless +PlugInstall +qall 2>/dev/null || warn "PlugInstall had warnings — plugins may need manual review."
log "Neovim plugins installed."

# ---------------------------------------------------------------------------
# 13. yazi plugin install
# ---------------------------------------------------------------------------
log "Installing yazi plugins..."
if command -v ya &>/dev/null; then
  ya pack -i 2>/dev/null || warn "ya pack -i had warnings — yazi plugins may need manual review."
  log "Yazi plugins installed."
else
  warn "ya not found, skipping yazi plugin install."
fi

# ---------------------------------------------------------------------------
# 14. Set default shell to zsh
# ---------------------------------------------------------------------------
if [ "$SHELL" != "$(which zsh)" ]; then
  log "Setting default shell to zsh..."
  sudo chsh -s "$(which zsh)" "$(whoami)" 2>/dev/null || warn "Could not change default shell to zsh."
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
if [ ${#FAILED_INSTALLS[@]} -gt 0 ]; then
  warn "The following installations failed: ${FAILED_INSTALLS[*]}"
  warn "Re-run this script or install them manually."
fi

log "Dotfiles bootstrap complete."
