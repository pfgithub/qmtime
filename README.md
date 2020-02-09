## xfce panel

```
./build.sh
sudo ./install.sh
```

add the panel in xfce

panel will auto-update on reinstall. if it errors, click execute.

this panel is very cpu intensive (uses 0.8% cpu and is in my top 15 things by cpu usage while no other panel plugins are). I'm probably doing something wrong.

## command line

```
mkdir -p dist
gcc src/commandline.c -o dist/tenhourtime && ./dist/tenhourtime
```

## source code

format with clang-format
