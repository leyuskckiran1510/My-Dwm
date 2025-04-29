# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/Applications" ]; then
	PATH="$HOME/Applications/bin:$PATH"
fi
if [ -d "$HOME/scripts" ]; then
	PATH="$HOME/scripts:$PATH"
fi
if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi

export CHROME_EXECUTABLE=/usr/bin/brave-browser

# disable touch pad while typing
syndaemon -K -i 0.5 -R -d &

# run slstatus
slstatus &
#syncthing &
/home/tester/.screenlayout/left_monitor.sh &
dunst &
copyq &
/usr/lib/x86_64-linux-gnu/libexec/kdeconnectd &
~/scripts/bgchange &
pulseaudio &
pactl set-default-sink $(pactl list sinks | grep Name | awk -F ': ' '{print $2}' | grep pci) &A