pic="/home/tester/Pictures/TimeLapse/$(date +%Y)/$(date +%m)/$(date +%d)/"

_sender(){
    device=$(kdeconnect-cli -l| dmenu -p "Which one to choose" | awk -F ': ' '{print$2}' | awk -F ' ' '{print$1}')
    
    echo -e "-------- \n"
    echo -e "\tSending Files to Device with ID  $device"
    echo -e "\n-------- \n"
    kdeconnect-cli -d $device --share $@ 2>/dev/null && echo "Transfer Sucessfull" || echo "Failed to transfer device is offline..... "

}

_dckill(){
    docker stop $(docker ps | grep $1  | awk '{print$1}') && echo "Killed Sucessfully" || echo "Failed To Kill Please Recheck name"
}


_account_chose(){
    choice=$(echo -e "Kiran\nLeyuskc" | dmenu -p "account: ")
    case $choice in
        "Kiran")
        git config user.name "leyuskckiran1510";
        git config user.email "kdhakal1510@gmail.com";
        git config user.signingKey "6E9EF453C084C1FA";
        ;;
        "Leyuskc")
        git config user.name "leyuskc";
        git config user.email "leyuskc@gmail.com";
        git config user.signingKey "ABE1609B56031497";
        ;;
    esac
}

_rename(){
    i=0;
    total=$(ls |wc -l)
    total=${#total}
    for f in $(ls -tr);do
        i=$(($i+1)) ;
        mv $f "$(printf '%0'$total'd' $i).$1";
    done
}

_calculator(){
    res=$(echo "$@" | bc)
    echo "$@ = $res"
}
_kill(){
    if (kill -9 $1 &> /tmp/kill_output) ; then
      echo "PID:[ $1 ] message:- Sucess "
    else
      echo "PID:[ $1 ] message:- {$(cat /tmp/kill_output|awk -F '-' '{print$2}')}"
    fi
    rm -f /tmp/kill_output
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

_stB(){
  st &
  disown
}

_src(){
    local path i
    for i in $(ls -a );do
        if [[ -f "$i/bin/activate" ]];then
            path="$i/bin/activate"
            source $path
            echo "Activated in ($i)"
        fi
    done
    if [[ -z $path ]]; then
        echo "Their are no active virtual env"
        echo "Do you want to create one?(Y/n)"
        read choice
        if [[ $choice = "Y" || $choice = "y" ]]; then
            _csrc
        else
            echo "Exiting.."
        fi
    fi
    unset path i

}

_csrc(){
    activator="python -m venv"
    #status=$(uv 2&>/dev/null)
    #if [ $? ];then
    #    activator="uv venv"
    #else
    #    echo "Uv is not installed using python's venv module"
    #    echo "you can install uv as" 
    #    echo -e "\t\t\tpip install uv"
    #fi
    echo -e ".venv\nvenv\nvirtual" | dmenu -l 10 -p "Choose the Virtual Folder Name" | xargs -I@  $activator @
    if [ $? ];then
        _src
    fi 
}
_branch_diff(){
    for branch in $(git branch --format='%(refname:short)' --no-merged); do
        git diff $branch;
        echo $branch;
    done
}

alias stop=_stop
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias stB=_stB
alias shareit=_tpaste
alias src=_src
alias csrc=_csrc
alias copy='xargs echo -n | xclip -selection clipboard'
alias backup=_bac_up

alias bright='sudo chmod 0777 /sys/class/backlight/intel_backlight/brightness'
# old send to mobile kde script not optimal for id changes 
# alias send2mblo='echo $(kdeconnect-cli -l | grep -Eo "[a-z0-9]{14,}" || echo "No device found" && exit) | xargs -I@ kdeconnect-cli -d @ --share  '
alias gitaccount=_account_chose
alias send2mbl=_sender
alias leyuskc='ls -lisa'
alias docker_kill=_dckill 
alias seq_rename=_rename
alias sus="systemctl suspend"
alias cd.="cd ./"
# alias startSrecord="ffmpeg -f x11grab -draw_mouse 1 -framerate 30 -i :0 -pix_fmt yuv420p -c:v libx264 -preset veryslow -crf 1 -f matroska -threads 5 "
alias record="ffmpeg -f x11grab -draw_mouse 1 -framerate 30 -i :0 -pix_fmt yuv420p -c:v libx264 -preset veryfast -crf 10 -f matroska -threads 5 "
alias timeit="time"
alias Time="date +%X"
alias serve="python -m http.server"
alias calc="_calculator"
alias branch_diff="_branch_diff"
alias git_acp="git add .;git commit;git push;"
alias python="python3"

alias cls='clear'
