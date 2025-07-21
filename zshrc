alias nv="nvim"
alias c="clear"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Tools & Quality of Life
alias cat="bat"
alias l="eza --icons=always -la"
alias ls="eza --icons=always"
alias ll="eza --icons=always -l"
alias la="eza --icons=always -la"
alias tree="eza --icons=always --tree"

# Environment
export EDITOR=/opt/homebrew/bin/nvim
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Completion system
autoload -Uz compinit
compinit

# Starship prompt
eval "$(starship init zsh)"

# Zoxide smart cd
eval "$(zoxide init zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#7f849c'

# fzf-tab with icons and preview
source ~/.fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:complete:*' fzf-preview 'bat --style=numbers --color=always --line-range=:500 {} 2>/dev/null || cat {} 2>/dev/null'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' show-group full
zstyle ':completion:*' menu select

# zsh-syntax-highlighting (must come last)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

