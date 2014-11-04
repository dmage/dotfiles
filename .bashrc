# .bashrc
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

#Ubuntu#
[[ -f /etc/bash_completion ]] &&
    . /etc/bash_completion
#Gentoo#
[[ -f /etc/profile.d/bash-completion.sh ]] &&
    . /etc/profile.d/bash-completion.sh

if type -p dircolors >/dev/null ; then
    if [[ -f ~/.dir_colors ]] ; then
        eval $(dircolors -b ~/.dir_colors)
    elif [[ -f /etc/DIR_COLORS ]] ; then
        eval $(dircolors -b /etc/DIR_COLORS)
    fi
else
    export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
fi

#BSD#@export CLICOLOR=1
#GNU#@alias ls='ls --color=auto'
alias grep='grep --colour=auto'

# wrappe around unicode bug
alias mc='LANG="C" mc'

# Change the window title of X terminals
case ${TERM} in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
    ;;
    screen)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
    ;;
esac

[[ -f ~/.shellrc ]] &&
    . ~/.shellrc

[[ -f ~/.perlbrew/etc/bashrc ]] &&
    . ~/.perlbrew/etc/bashrc

[[ -d ~/.bashrc.d ]] &&
    for f in ~/.bashrc.d/*; do
        . $f
    done
