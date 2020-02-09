#!/bin/sh

mkdir -p dist && gcc -Wall -shared -o dist/libtenhourtime.so -fPIC src/panel.c `pkg-config --cflags --libs libxfce4panel-1.0` `pkg-config --cflags --libs gtk+-3.0` && echo "Success (build)."