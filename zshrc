# Dotfiles are sourced by oh-my-zsh on codespace creation
# Adapted for Codespaces (Debian/Ubuntu) — no brew, no spaceship

export GOPATH=$HOME/.go
export GOBIN=$GOPATH/bin
export PATH=$GOBIN:$GOPATH:$HOME/.local/bin:/usr/local/go/bin:$PATH

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Case-sensitive completion
CASE_SENSITIVE="true"

# Enable command auto-correction
ENABLE_CORRECTION="true"

# Plugins (no brew — not available on Linux codespace)
plugins=(colored-man-pages gh git golang jsontools)

source $ZSH/oh-my-zsh.sh

# Source yazi cd-on-quit helper
if [ -f "$HOME/.config/yazi/cd-on-quit" ]; then
  source "$HOME/.config/yazi/cd-on-quit"
fi

# Source aliases
if [ -f "$HOME/.config/dotfiles/aliases.zsh" ]; then
  source "$HOME/.config/dotfiles/aliases.zsh"
fi

# Preferred editor
export EDITOR="nvim"

# Initialize nvm (if Node was installed via nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Initialize zoxide
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi
