# tenhourtime

time with 100LL instead of 24 hours in a day. [unit conversions](https://pfg.pw/sitepages/unitconv).

![screenshot showing the panel](https://i.imgur.com/qWjqVZr.png)

## requirements

- zig version 0.5.0+357f42da6
- libc
- gtk 3
- libxfce4panel
- sh

## xfce panel

check the install script and make sure it is installing to the right place on your system.

```bash
zig build panel && sudo ./install.sh
```

add the panel in xfce

panel will auto-update on reinstall (you might have to right click on the panel before xfce notices ther is a new version). if it errors, click execute. If it errors again, check the xfce4-panel logs.

more about panels: [https://wiki.xfce.org/dev/howto/panel_plugins](https://wiki.xfce.org/dev/howto/panel_plugins)

## command line

```bash
zig build cli && ./zig-cache/bin/tenhourtime
```

## tests

```bash
zig build test
```

## todo

- vertical centering
- popup panel to calculate things
