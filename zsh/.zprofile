# Homebrew: prepend /opt/homebrew/{bin,sbin} to PATH (and set HOMEBREW_* vars).
# Without this, macOS path_helper leaves /usr/bin ahead of Homebrew, so system
# binaries (e.g. the ancient /usr/bin/python3) shadow brew-installed ones.
eval "$(/opt/homebrew/bin/brew shellenv)"
