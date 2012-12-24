# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [[ $TERM != "screen" ]];then
    test -z "$TMUX" && (tmux attach || tmux new-session)
    #screen -RR
    exit
fi


# User specific aliases and functions
export HISTCONTROL=ignoreboth

alias dropcache='su -c "echo 3 >/proc/sys/vm/drop_caches"'
alias histback=" history -d $((HISTCMD-1))"
alias lefthand="xmodmap -e \"pointer = 3 2 1\""
alias righthand="xmodmap -e \"pointer = default\""
alias svn='colorsvn'
alias ll='ls -l --color=auto'

alias svndf='colorsvn diff --diff-cmd kdiff3'
alias svnvdf='svn diff --diff-cmd vimdiff'

# hack to append to the history after every command instead of when the shell exits
#export PROMPT_COMMAND="history -a"


# Plain prompt
#export PS1='\u@\h:\w\$ '
#export PS1='\[\033k\033\\\]\[\033[01;32m\]\u@\h\[\033[01;34m\] \W \$\[\033[00m\] '

# Prompt color codes
BLUE="\[\033[0;34m\]"
BBLUE="\[\033[1;34m\]"
RED="\[\033[0;31m\]"
LIGHT_RED="\[\033[1;31m\]"
WHITE="\[\033[1;37m\]"
NOCOLOR="\[\033[0m\]"
BLACK="\[\033[30;47m\]"
RED2="\[\033[31;47m\]"
GREEN="\[\033[0;32m\]"
BGREEN="\[\033[1;32m\]"
BYELLOW="\[\033[1;33m\]"
BLUE2="\[\033[34;47m\]"
MAGENTA="\[\033[35;47m\]"
CYAN="\[\033[36;47m\]"
BCYAN="\[\033[1;36m\]"
WHITE2="\[\033[37;47m\]"
TEAL="\[\033[0;36m\]"

#code for setting title for screen
#SETTITLE='\[\033k\033\\\]'
#sets the hardstatus for screen to the pwd and user@hostname
#SETHSTAT='\[\e]2;\005{= kr}[\005{= kC}\u@\h\005{= kB}:\w\005{= kr}]\a\]'

export PS1="${BGREEN}\u@\h${BBLUE} \w \$${NOCOLOR} ${SETTITLE}${SETHSTAT}"

# code for setting screens title based on PWD
# will display either the title based on current command or the pwd when at the prompt
_screen_codes_pc()
{
    if [ $TERM = "screen" ]; then
        MYPWD="${PWD/#$HOME/~}"
        MYPWD="${MYPWD##*/}"
        # custom trimmings for work etc...
        MYPWD="${MYPWD/%_branch/~}"
        MYPWD="${MYPWD/#Navy_Training_Baseline_/~}"
        MYPWD="${MYPWD/#Navy_/~}"

        [ ${#MYPWD} -gt 12 ] && MYPWD=~${MYPWD:${#MYPWD}-11}
        echo -n -e "\033k\033\\"
        echo -n -e "\033k$MYPWD/\033\\"

        # Set the windows hard status the 005 code escapes screen so you can set colors within the %h variable
        JOBS=`jobs|wc -l`
        [ $JOBS -eq 0 ] && JOBS="" || JOBS="[$JOBS] "
        [ $UID -eq 0 ] && USRCOLOR="\005{+b R}" || USRCOLOR="\005{= kw}"
        GIT_BR="$(declare -F __git_ps1 &>/dev/null && __git_ps1 "%s")"
        # trim things (redundant _branch suffix) and chop down to fit
        GIT_BR="${GIT_BR/%_branch}"
        [ ${#GIT_BR} -gt 9 ] && GIT_BR="~${GIT_BR:${#GIT_BR}-8}"
        [ ${#GIT_BR} -gt 0 ] && GIT_BR="($GIT_BR) "
        if [[ -z "$TMUX" ]]; then
            echo -n -e "\e]2;$GIT_BR$JOBS$USRCOLOR$USER\005{-}\005{= kb}|\005{-}$HOSTNAME\a" #\005{= kB}:$PWD
        else 
            echo -n -e "\e]2;$GIT_BR$JOBS\a"
        fi
    fi
}

preexec_interactive_mode=""
_preexec_trap()
{
    if [[ -z "$preexec_interactive_mode" ]]; then
        return
    else
        echo -n -e "\033k$BASH_COMMAND\033\\"
        preexec_interactive_mode=""
    fi
}

if [ $TERM = "screen" ]; then
    export PROMPT_COMMAND='_screen_codes_pc;preexec_interactive_mode="yes"'
    trap '_preexec_trap' DEBUG
fi

#bind '"\t":menu-complete'

# define wrapper for emacsclient.  Lets you pipe into it when - given as file name
e() {
    local TMP;
    if [[ "$1" == "-" ]]; then
        TMP="$(mktemp /tmp/emacsstdinXXX)";
        cat >"$TMP";
        if ! emacsclient --alternate-editor /usr/bin/false --eval "(let ((b (create-file-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"${TMP}\") (delete-file \"${TMP}\"))"  > /dev/null 2>&1; then
            emacs --eval "(let ((b (create-file-buffer \"*stdin*\"))) (switch-to-buffer b) (insert-file-contents \"${TMP}\") (delete-file \"${TMP}\"))" &
        fi;
    else
        emacsclient --alternate-editor "emacs" --no-wait "$@" > /dev/null 2>&1 &
    fi;
}
