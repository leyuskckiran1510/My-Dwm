#!/usr/bin/bash

rm -rf dmenu dmenu.o
make
sudo make install
ldd dmenu | grep "home" | xargs -I echo {} &>/dev/null  || echo  "SucessFull Install With Emoji"