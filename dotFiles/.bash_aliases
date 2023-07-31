
_sender(){
    kdeconnect-cli -l |grep $1 | grep -Eo "[a-z0-9]{14,}" || (echo "No device found" && exit) | xargs -I@ kdeconnect-cli -d @ --share $2
}

_dckill(){
    docker stop $(docker ps | grep $1  | awk '{print$1}') && echo "Killed Sucessfully" || echo "Failed To Kill Please Recheck name"
}

alias bright='sudo chmod 0777 /sys/class/backlight/intel_backlight/brightness'
alias send2mbl='echo $(kdeconnect-cli -l | grep -Eo "[a-z0-9]{14,}" || echo "No device found" && exit) | xargs -I@ kdeconnect-cli -d @ --share  '
alias grep='grep -v grep| grep --color'
alias leyuskc='ls -lisa'
alias docker_kill=_dckill 
