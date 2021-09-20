#!/bin/sh

# Load if exists
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

HISTFILE=~/.local/share/zsh/zsh_history
HISTSIZE=3000
SAVEHIST=3000

setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments

setopt APPEND_HISTORY                            
setopt SHARE_HISTORY                            # Immediate history sharing between sessions
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

unsetopt BEEP                                   # Disable beeping

autoload -Uz compinit
autoload -Uz colors && colors

zstyle ':completion:*' menu select

zmodload zsh/complist

stty stop undef		                            # Disable ctrl-s to freeze terminal.
zle_highlight=('paste:none')                    # Disable highlighting when pasting

# compinit
_comp_options+=(globdots)                       # Include hidden files.

source "$ZDOTDIR/zsh-functions"
source "$ZDOTDIR/vim-mode"

# Plugins
zsh_add_plugin     "zsh-users/zsh-autosuggestions"
zsh_add_plugin     "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin     "hlissner/zsh-autopair"

# Vi mode
bindkey -v

eval "$(starship init zsh)"
