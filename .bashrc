# If not running interactively, don't do anything
#[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export QT_DIR=/usr/lib/qt
export LD_LIBRARY_PATH=/usr/lib/qt6
export PATH=$PATH:/home/user/proj/github/gf

if [[ !$DISPLAY && "$(tty)" = "/dev/tty1" ]]; then
    startx
else
    exec fish
fi
#export XDG_RUNTIME_DIR=/run/user/$(id -u)


. "$HOME/.local/bin/env"
