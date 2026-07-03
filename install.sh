#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}==>${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }
err()  { echo -e "${RED}[error]${NC} $1"; exit 1; }

# ── Homebrew ────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for this session (Apple Silicon path)
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  log "Homebrew already installed"
fi

# ── Xcode CLI tools (git, make, etc.) ───────────────────────────────────────
if ! xcode-select -p &>/dev/null; then
  log "Installing Xcode CLI tools..."
  xcode-select --install
  # Wait for install to complete before continuing
  until xcode-select -p &>/dev/null; do sleep 5; done
else
  log "Xcode CLI tools already installed"
fi

# ── CLI tools ───────────────────────────────────────────────────────────────
log "Installing shell & terminal tools..."
brew install \
  neovim \
  bat \
  eza \
  starship \
  zoxide \
  fzf \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  tmux \
  btop

# ── Neovim ecosystem ─────────────────────────────────────────────────────────
log "Installing neovim dependencies..."
brew install \
  ripgrep \
  fd \
  lazygit \
  tree-sitter \
  node \
  python3

# ── General dev tools ────────────────────────────────────────────────────────
log "Installing general dev tools..."
brew install \
  gh \
  git \
  wget \
  jq \
  curl \
  make \
  atuin \
  diffnav

# gh-dash (GitHub PR/issue/notifications dashboard) is a gh CLI extension
if ! gh extension list 2>/dev/null | grep -q "dlvhdr/gh-dash"; then
  log "Installing gh-dash..."
  gh extension install dlvhdr/gh-dash
else
  log "gh-dash already installed"
fi

# neofetch was removed from homebrew; try the community tap, fall back to fastfetch
if ! brew install neofetch 2>/dev/null; then
  warn "neofetch unavailable in homebrew — installing fastfetch instead"
  brew install fastfetch
  warn "Update your shell config to call 'fastfetch' instead of 'neofetch' if needed"
fi

# fzf key bindings and shell completion
log "Configuring fzf key bindings..."
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc

# ── Casks ───────────────────────────────────────────────────────────────────
log "Installing Ghostty terminal..."
brew install --cask ghostty || warn "Ghostty already installed or unavailable"

log "Installing MesloLGS Nerd Font..."
brew install --cask font-meslo-lg-nerd-font || warn "Font already installed"

# ── zsh plugins (not via brew) ───────────────────────────────────────────────
if [ ! -d "$HOME/.config/fzf-tab" ]; then
  log "Cloning fzf-tab..."
  git clone https://github.com/Aloxaf/fzf-tab ~/.config/fzf-tab
else
  log "fzf-tab already present, updating..."
  git -C ~/.config/fzf-tab pull --ff-only
fi

# ── TPM (Tmux Plugin Manager) ────────────────────────────────────────────────
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  log "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  log "TPM already present, updating..."
  git -C ~/.tmux/plugins/tpm pull --ff-only
fi

# ── Config symlinks ──────────────────────────────────────────────────────────
mkdir -p ~/.config/starship ~/.config/tmux ~/.config/ghostty ~/.config/btop ~/.config/neofetch ~/.config/atuin ~/.config/gh-dash

symlink() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    warn "Backing up existing $dst → ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -sf "$src" "$dst"
  echo "  linked: $dst"
}

log "Symlinking configs..."
symlink "$DOTFILES_DIR/zsh/.zshrc"             "$HOME/.zshrc"
symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship/starship.toml"
symlink "$DOTFILES_DIR/tmux/tmux.conf"         "$HOME/.config/tmux/tmux.conf"
symlink "$DOTFILES_DIR/ghostty/config"         "$HOME/.config/ghostty/config"
symlink "$DOTFILES_DIR/btop/btop.conf"         "$HOME/.config/btop/btop.conf"
symlink "$DOTFILES_DIR/neofetch/config.conf"   "$HOME/.config/neofetch/config.conf"
symlink "$DOTFILES_DIR/atuin/config.toml"      "$HOME/.config/atuin/config.toml"
symlink "$DOTFILES_DIR/gh-dash/config.yml"     "$HOME/.config/gh-dash/config.yml"

# ── Import existing shell history into atuin ────────────────────────────────
if command -v atuin &>/dev/null; then
  log "Importing shell history into atuin..."
  atuin import auto || warn "atuin import failed, run 'atuin import auto' manually"
fi

# ── Done ────────────────────────────────────────────────────────────────────
echo ""
log "Installation complete. Next steps:"
echo "  1. Restart your shell (or: source ~/.zshrc)"
echo "  2. Open tmux, then press Ctrl-b + I to install tmux plugins"
echo "  3. In Ghostty, the font and theme are already set via the config"
echo "  4. Run 'gh dash' for the GitHub PR/issue dashboard"
