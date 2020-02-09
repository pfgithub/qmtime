# tenhourtime

time with 100LL instead of 24 hours in a day. always utc except not because mktime. value is the % of the day gone by in utc time. 23LL = 23% of the 24-hour day has gone by in utc time.

## config

edit `src/tenhourtime.c` and change LOCAL_OFFSET to your timezone offset. Compile and run command line and check that the time it shows is the same as [https://pfg.pw/sitepages/tenhourtime](https://pfg.pw/sitepages/tenhourtime).

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

## formatting code

format code with `clang-format -i src/*.c`
