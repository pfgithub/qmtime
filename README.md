# tenhourtime

time with 100LL instead of 24 hours in a day. value is the % of the day gone by in utc time. 23LL = 23% of the 24-hour day has gone by in utc time

## requirements

- zig version 0.5.0+357f42da6
- node >=8
- libc
- pkg-config
- gtk 3
- libxfce4panel
- sh

## xfce panel

check the install script and make sure it is installing to the right place on your system.

```bash
node genbuild.js && zig build panel && sudo ./install.sh
```

add the panel in xfce

panel will auto-update on reinstall (you might have to right click on the panel before xfce notices ther is a new version). if it errors, click execute. If it errors again, check the xfce4-panel logs.

more about panels: [https://wiki.xfce.org/dev/howto/panel_plugins](https://wiki.xfce.org/dev/howto/panel_plugins)

## command line

```bash
node genbuild.js && zig build cli && ./zig-cache/bin/tenhourtime
```
