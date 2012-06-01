# -*- shell-script -*-
#
# Fichier d'initialisation de bash commun

# Pour les shells non interactif (sous emacs, avec rcp, ...)
[ -z "$PS1" -o "$TERM" = dumb ] && return

w
export PATH="~/bin:/usr/lib/ccache/bin:/bin/lib/distcc/bin:/sbin:/usr/sbin/:${PATH}"
export NNTPSERVER="news.crans.org"
if [ `hostname` != venus ]; then
	export LC_ALL="fr_FR.utf-8"
	export LANG="fr_FR.utf-8"
else
	export LC_ALL="fr_FR@euro"
	export LANG="fr_FR@euro"
fi

shopt -s extglob

# +-------+
# | Hacks |
# +-------+

COLUMNS=$(tput cols)
shopt -s checkwinsize

# +-------------------------+
# | Customizations diverses |
# +-------------------------+

# On ne sauve pas les lignes dupliqués dans l'historique
export HISTCONTROL=ignoredups
export HISTSIZE=10000000
# Ne tronque pas le fichier d'historique
shopt -s histappend

# Convenience
[[ -x /usr/bin/lesspipe ]] && eval "$(lesspipe)"
if [[ $(uname) == Linux ]]; then
    eval "$(dircolors)"
    alias ls='ls --color=auto -FC'
fi

# Complétion
[[ -f /etc/profile.d/bash-completion.sh ]] && source /etc/profile.d/bash-completion.sh
[[ -f /etc/bash_completion ]] && source /etc/bash_completion
if [[ `uname -s` = "OpenBSD" ]]; then
  source /etc/bash_completion
  export PKG_PATH="ftp://ftp.crans.org/mirror/OpenBSD/`uname -r`/packages/`uname -m`"
fi

# +------------------+
# | Fonctions utiles |
# +------------------+

parallelize ()
{
    local count

    if [[ "$1" = "-n" ]]; then
        count=$2
        shift 2
    else
        count=$(grep '^processor' /proc/cpuinfo |wc -l)
    fi

    if [[ `jobs | grep  -v Done | wc -l` -ge $count ]]; then
        # grep -v Done is to get rid off the status reports of terminating jobs
        wait
    fi

    $@ &
}

uncapitalize ()
{
    perl -pe 's/\w.+/\l$&/'
}

capitalize ()
{
    perl -pe 's/\w.+/\u$&/'
}

# +----------------------+
# | Génération du prompt |
# +----------------------+

# Génération de la ligne de "-"
function gen_minus_line
{
    local i

    MINUS_LINE=""
    SAVE_COLUMNS=$COLUMNS

    for ((i = COLUMNS-24; i>0; i--)); do
	MINUS_LINE=$MINUS_CHAR$MINUS_LINE
    done
}

# Génération du prompt après chaque commande
function prompt_command
{
    (( SAVE_COLUMNS == COLUMNS )) || gen_minus_line

    local pwd=${PWD/#$HOME/'~'}

    if (( ${#pwd} + 27 > COLUMNS )); then
 	if (( COLUMNS >= 33 )); then
	    PS1=$TITLE'\[\e[1;36m\]'$MINUS_CHAR'( \[\e[1;35m\]\D{%H:%M:%S}\[\e[1;36m\] )'$MINUS_CHAR'< \[\e[1;33m\]..'${pwd:${#pwd}+29-COLUMNS}${scm_f}'\[\e[1;36m\] >${MINUS_LINE:0:4-${#?}}[ \[\e[1;$((31+($?==0)*6))m\]$?\[\e[1;36m\] ]'$MINUS_CHAR'\n\[\e[1;31m\]${debian_chroot:+($debian_chroot)}\u\[\e[1;32m\]@\[\e[1;34m\]\h \[\e[1;32m\]\$ \[\e[0m\]'
	else
	    PS1=$TITLE'\[\e[1;36m\]'$MINUS_CHAR'( \[\e[1;35m\]\D{%H:%M:%S}\[\e[1;36m\] )'$MINUS_CHAR'< \[\e[1;33m\]'$pwd${scm_f}'\[\e[1;36m\] >'$MINUS_CHAR'[ \[\e[1;$((31+($?==0)*6))m\]$?\[\e[1;36m\] ]'$MINUS_CHAR'\n\[\e[1;31m\]${debian_chroot:+($debian_chroot)}\u\[\e[1;32m\]@\[\e[1;34m\]\h \[\e[1;32m\]\$ \[\e[0m\]'
	fi
    else
	PS1=$TITLE'\[\e[1;36m\]'$MINUS_CHAR'( \[\e[1;35m\]\D{%H:%M:%S}\[\e[1;36m\] )'$MINUS_CHAR'< \[\e[1;33m\]'$pwd'\[\e[1;36m\] >${MINUS_LINE:'${#pwd}${scm_f}'+${#?}}'$MINUS_CHAR'[ \[\e[1;$((31+($?==0)*6))m\]$?\[\e[1;36m\] ]'$MINUS_CHAR'\n\[\e[1;31m\]${debian_chroot:+($debian_chroot)}\u\[\e[1;32m\]@\[\e[1;34m\]\h \[\e[1;32m\]\$ \[\e[0m\]'
    fi
}

# # On change le titre dynamiquement si on est sous X
if [[ $TERM = "xterm" ]]; then
    TITLE='\[\e];\u@\h:\w\a\]'
else
    TITLE=''
fi

# On regénére le prompt après chaque commande
PROMPT_COMMAND=prompt_command

# +----------------+
# | Aliases commun |
# +----------------+

alias m='more'
alias g='grep'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias la='ls -a'
alias ll='ls -lh'
alias lla='ls -lah'
alias l='ls -sh'
alias s='cd ..'
alias du='du -h'
alias df='df -h'
alias vi='vim'
export VIMRUNTIME=`ls -d /usr/share/vim/vim7*`
#Alias spécifique à linux
if [[ `uname -s` = "Linux" ]]; then
	alias grep='grep --color'
fi
# +----------------------+
# | Customization locale |
# +----------------------+

[[ -f ~/.bashrc.local ]] && . ~/.bashrc.local

# +-------------------+
# | Messages au début |
# +-------------------+

if [[ $(uname) == Linux && ( $(locale charmap) == UTF-8 && $TERM != screen ) ]]; then
    MINUS_CHAR=─
    gen_minus_line
    date=$(/bin/date +"%R, %A %d %B %Y")
    echo -e "\e[1;36m┬─${date//?/─}─┬${MINUS_LINE:${#date}-20}\n\
│ \e[1;37m$date\e[1;36m │\n\
└─${date//?/─}─┘\e[0m\n"
    unset date
else
    MINUS_CHAR=-
    gen_minus_line
fi

if command -v fortune > /dev/null; then
    # On essaie d'abord avec les fortunes persos
#    fortune -s 50% crans 50% all 2> /dev/null || fortune -s 2> /dev/null
    echo
fi
