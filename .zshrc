# Set up the prompt

#export MANPAGER="sh -c 'bat -l man -p'"
#MANROFFOPT="-c"
# source antidote
#source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
#antidote load

autoload -Uz promptinit

# source ~/.functions
#prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
#bindkey -e

# Keep 10000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit 
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION" 
else
	compinit -C -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION" 
fi;

alias 'cd=z'
alias ls='eza --hyperlink' 
alias ll='ls -l'
alias cargo-update="cargo install --list | grep '^[a-zA-Z0-9_\-]* v[0-9.]*:$' | cut -d ' ' -f1 | xargs cargo install"
alias get-win-name="xprop | tail -n 1 | cut -d '=' -f 2 | tr -d '\"' | tr -d ' '"
alias icat="kitty +kitten icat --transfer-mode=stream"
alias prename="perl-rename"
alias paclist="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

[[ -a "/etc/zsh_command_not_found" ]] && . /etc/zsh_command_not_found


fb() {
    buku -p -f 5 | fzf --multi | cut -f 1 | xargs -I {}  buku --nostdin -o {}
}

dl-music() {
    # create a temporary directory and download the music there
    dir=$(mktemp -d)
    yt-dlp --add-metadata -x --audio-quality 0 -o  "$dir/%(title)s.%(ext)s" $1 2>&1 
    beet import $dir
}

display-colors() {

    for i in {0..255} ; do
        printf "\x1b[38;5;${i}mcolour${i}\n"
    done

}

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(mcfly init zsh)"

# opam configuration
[[ ! -r ~/.local/share/opam/opam-init/init.zsh ]] || source ~/.local/share/opam/opam-init/init.zsh  > /dev/null 2> /dev/null
