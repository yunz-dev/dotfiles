# PATH
path+=~/.cargo/bin
path+=($HOME/.nix-profile/bin)
path+=/opt/homebrew/bin
path+=/Users/yunz/.local/bin:$PATH
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
autoload -U compinit && compinit
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit snippet OMZP::git
alias rebuild="~/dotfiles/nix/rebuild.sh"

zinit cdreplay -q
# bindkey '^f'
#
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
#
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

export LS_COLORS="$(eza --color=always  / 2>/dev/null | \
  awk 'BEGIN{RS="\n";ORS=":"} {print}' | sed 's/:$//')"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# bindkey '^l' history-search-backward
# bindkey '^h' history-search-backward
#
#
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

# gemini cli
alias meow="npx https://github.com/google-gemini/gemini-cli"

# ALIAS
alias cc="claude"
alias bvim="nix build ~/.config/nixvim/. ~/.config/nixvim/"
alias vi="~/.config/nixvim/result/bin/nvim"
alias vim="~/.config/nixvim/result/bin/nvim"
alias grep="rg"
# alias nvim="~/.config/nixvim/result/bin/nvim"
# source ~/scripts/secrets/ssh.sh
#
# tmuxify
alias t="~/scripts/tmuxify.sh"

# lazygit
alias lg="lazygit"

# fun ---------------------------------------------------------------------
## mistake
alias oops="history | tail -n 2 | head -n 1 | sed 's/^ *[0-9]* *//' && echo '...probably not what I meant to do.'"
alias darn="echo 'Computer says no.' && sleep 1 && echo 'Just kidding, what did you want?'"
alias facepalm="echo '(－‸ლ)'"

alias bye="echo 'Hasta la vista, baby.' && sleep 1 && exit"
alias hello="echo 'Greetings, Professor Falken. Shall we play a game?'"
alias vanish="clear && echo 'you saw nothing...'"

alias please="sudo" # Use with caution and only if you understand the implications!
alias magic="history -a && history -c && history -r && echo '✨ Abracadabra! ✨'" # Refreshes history

# -------------------------------------------------------------------------

# EXPORT
export EDITOR=nvim

# oh-my-posh: zsh theme -------------
# eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/base.toml)"
eval "$(starship init zsh)"

eval $(opam env)

# Fastfetch
alias neofetch="fastfetch"

# Fuzzy Finder ------------------------
# Keybinds
# '** + TAB' fzf for cli argument
# <C-gb> - find git branch
# <C-gh> - find git hash
# <C-gt> - find git tag
# <C-gr> - find git remotes
# <C-gs> - find git stash
# <C-gl> - find git reflogs
# <C-gw> - find git worktrees
# <C-ge> - find git for-each-ref
#

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# --- setup fzf theme ---
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ** completion for files
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# ** completion for directories
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/scripts/fzf-git.sh
# -------------------------------------

# Bat (like cat) ---------------------------------
export BAT_THEME="Catppuccin Mocha"
alias cat="bat"
# -------------------------------------
#
# Eza (better cat) ------------------------
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
#------------------------------------------------------------

# zoxide (cd but better) ----
# use space + TAB to sort between similar names
eval "$(zoxide init zsh)"

alias cd="z"
# ----------------------------
#
# direnv ---------------------
eval "$(direnv hook zsh)"

# MISC ALIAS
alias nix-curr-gen="echo `readlink /nix/var/nix/profiles/system | cut -d- -f2`"
alias nix-list-gen="sudo nix-env --list-generations --profile /nix/var/nix/profiles/system"

. "$HOME/.local/bin/env"

# Added by Windsurf
export PATH="/Users/yunz/.codeium/windsurf/bin:$PATH"

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

  autoload -Uz compinit
  compinit -i # This might be needed if you encounter completion issues
  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    . "$(brew --prefix)/etc/bash_completion"
  fi
