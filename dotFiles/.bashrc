# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTIGNORE='ls:clear:cd:systemctl suspend'
# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

_OLD_PATH="$PWD"

costume_ps1(){

    first_line="[$USER] $(ls |wc -l)(files)"
    wifi_name="$(iwgetid  | awk -F ':"' '{print$2}' | sed s/\"//)"

    first_line="$first_line | 🌐 $wifi_name"

    {
        disk="$(timeout 0.02 du -sh "$(pwd)" 2> /dev/null)"
        # 124 is a error code for timeout, to avoid waiting the file/folder size computations 
        if [[ "$?" != "124" ]]; then
            first_line="$first_line | 💾 $(echo $disk | awk '{print$1}')"
        fi

    }
    {
        # __git_ps1 is preinstalled with every git installs
        git_state=$(__git_ps1 "[%s]")
        if [[ "$git_state" != "" ]]; then
            first_line="$first_line | 📂 $git_state"
        fi

    }

   
    # echo -e "\033[03;33m$padding$first_line\033[00m"

    thome="$(echo $HOME | sed 's/\/$//')"
    local path="${1/#$thome/\~}"
    padding=""
    for (( i = 0; i < $COLUMNS - ${#first_line} - 14 - ${#path}; i++ )); do
        padding=" $padding"
    done
    echo -e "\033[01;35m${path}\033[03;33m$padding$first_line\033[00m"
    echo " "
    unset padding first_line

}



# Set the PS1 prompt
if [ "$color_prompt" = yes ]; then
    # PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='\[\033[01;34m\]$(costume_ps1 "\w")\[\033[00m\]\$ '
else
    # PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='$(costume_ps1 "\w")$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls -w60 --color=auto'

_kill(){
    if (kill $1 &> /tmp/kill_output) ; then
      echo "PID:[ $1 ] message:- Sucess "
    else
      echo "PID:[ $1 ] message:- {$(cat /tmp/kill_output|awk -F '-' '{print$2}')}"
    fi
    rm /tmp/kill_output
}

_stop() {
  for pid in $(ps aux | grep -i $1 | grep -v grep | awk  '{print $2}');do
    _kill $pid
  done
}


_tpaste(){
    if [ "$1" == "-s" ]; then
        if [ "$3" == "-c" ];then
                PATTREN="s/\x1b[^m]+m//g"
        else
                PATTREN="s/\?\?//g"
        fi
        if [ -f "$2" ]; then
                input=$(cat "$2")
        else
                input="$2"
        fi

        echo "$input" | ssh -T snips.sh  | grep ":[^ ]\+" | xargs echo | awk -F "┃" '{print$2}' |sed -r "$PATTREN"
        return
    fi
    if [ "$1" == "-h" ]; then
        if [ "$3" == "-c" ];then
                PATTREN="s/\x1b[^m]+m//g"
        else
                PATTREN="s/\?\?//g"
        fi
        if [ -f "$2" ]; then
            input=$(cat "$2")
        else
            input="$2"
        fi
        echo "$input" | ssh -T snips.sh  | grep ":[^ ]\+" | xargs echo | awk -F "┃" '{print$3}' |sed -r "$PATTREN"
        return
    fi
    if [ "$1" == "-n" ]; then
        if [ -f "$2" ]; then
            cat "$2" | ssh -T snips.sh
        else
            echo "$2" | ssh -T snips.sh
        fi
        return
    fi
    if [ -f "$1" ]; then
                input=$(cat "$1")
    else
                input="$1"
    fi

    if [ "$3" == "-c" ];then
                PATTREN="s/\x1b[^m]+m//g"
    else
                PATTREN="s/\?\?//g"
    fi
    echo "$input" | ssh -T snips.sh  | grep ":[^ ]\+" | xargs echo | awk -F "┃" '{print$2"\n"$3}' |sed -r "$PATTREN"
}
_bac_up(){
	cp $1 $1.bak
}

alias stop=_stop
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias st='st &'
alias shareit=_tpaste
alias src='source ./venv/bin/activate || source ./virtual/bin/activate'
alias csrc='python -m venv venv || python3 -m venv virtual'
alias copy='xclip -selection clipboard'
alias backup=_bac_up

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# if [ -n "$(ps aux | grep -v grep| grep ssh-agent)" ];then
# 	   _stop ssh-agent &>/dev/null
#        echo "already active" && clear
       

# fi
export PATH=$PATH:~/scripts
export PATH=$PATH:/home/tester/Applications



# This are the ssh-agent setup, so that I don;t have to type pashphrase to unlock my 
# private keys .. 😉
eval "$(ssh-agent -s)"
echo | SSH_ASKPASS=/home/tester/.secret.pmk setsid -w ssh-add /home/tester/.ssh/id_rsa && clear

kill_ssh_agent() {
    # killing the ssh-agent of the current terminal instance to avoid huge list of ssh-agent for each terminal
    kill $SSH_AGENT_PID
}
# trap basically lets me run specific function when the current active terminal ends/stops
trap kill_ssh_agent EXIT
