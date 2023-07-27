# cvt 1600 900 75

# xrandr --newmode "1600x900_75.00"  104.00  1600 -hsync +vsync

# Add the new mode to xrandr:

# xrandr --verbose --addmode VGA-0  "1600x900_75.00"

# and activate it

# xrandr --output VGA-0 --mode "1600x900_75.00"

# 1366x768
set -x
ht=$(echo "$1/1366 * 768" | bc )
mode=$(cvt $1 $ht | grep -i mode | awk -F "Modeline " '{print$2}') 
xrandr --newmode ${mode//\"/} && 
xrandr --verbose --addmode eDP-1 $(echo $mode| awk -F '"' '{print$2}' ) &&
xrandr --output eDP-1 --mode $(echo $mode| awk -F '"' '{print$2}' )
