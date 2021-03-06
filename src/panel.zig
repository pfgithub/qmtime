const std = @import("std");
const tht = @import("tenhourtime.zig");
const c = @cImport({
    @cInclude("libxfce4panel/xfce-panel-plugin.h");
});

const OverflowError = error{OverflowError};
const EachTick = extern struct {
    label: [*c]c.GtkLabel,
    previi: u8,
    pub const Error = OverflowError;
    fn update(anydata: c.gpointer) callconv(.C) c_int {
        var data: *align(1) EachTick = @ptrCast(*align(1) EachTick, anydata);
        var timeNum = tht.formatTime(tht.tenHourTime(tht.msSinceDayStart(tht.getTime())));
        timeNum.qm = 0;

        if (data.previi != timeNum.ii) {
            data.previi = timeNum.ii;

            const alloc = std.heap.c_allocator;
            const formatted = std.fmt.allocPrint0(alloc, "{}", .{timeNum}) catch @panic("oom");
            defer alloc.free(formatted);

            c.gtk_label_set_text(data.label, formatted.ptr);
        }
        return 1;
    }
};

pub fn constructor(plugin: [*c]c.XfcePanelPlugin) void {
    var label = c.gtk_label_new(@as([]const u8, "...").ptr);

    c.gtk_container_add(GTK_CONTAINER(plugin), label);
    c.gtk_widget_show_all(label);

    var alloc = std.heap.c_allocator;
    var updateData: *EachTick = alloc.create(EachTick) catch @panic("oom");
    updateData.* = .{
        .label = GTK_LABEL(label),
        .previi = 0,
    };

    std.debug.warn("panel started\n", .{});
    var result = c.g_timeout_add(10, EachTick.update, updateData);
}

// ===== MACRO EXPANSION FOR c.GTK_LABEL, c.GTK_CONTAINER
const GTK_LABEL = gtkCast(.Label, .label);
const GTK_CONTAINER = gtkCast(.Container, .container);

fn gtkCast(comptime name: var, comptime nameLower: var) fn f(view: var) *@field(c, "Gtk" ++ @tagName(name)) {
    return struct {
        fn f(view: var) *@field(c, "Gtk" ++ @tagName(name)) {
            if (@typeInfo(@TypeOf(view)) != .Pointer) @compileError("expected pointer");
            return @ptrCast(
                *@field(c, "Gtk" ++ @tagName(name)),
                c.g_type_check_instance_cast(@ptrCast(*c.GTypeInstance, view), @field(c, "gtk_" ++ @tagName(nameLower) ++ "_get_type")()),
            );
        }
    }.f;
}

// ========== MACRO EXPANSION FOR XFCE_PANEL_PLUGIN_REGISTER ==========
// even if zig could parse the macro, how would it add two functions?

pub fn xfce_panel_module_realize(arg_xpp: [*c]c.XfcePanelPlugin) callconv(.C) void {
    var xpp = arg_xpp;
    while (true) {
        if ((blk: {
            var __inst: [*c]c.GTypeInstance = @ptrCast([*c]c.GTypeInstance, @alignCast(@alignOf(c.GTypeInstance), (xpp)));
            var __t: c.GType = (c.xfce_panel_plugin_get_type());
            var __r: c.gboolean = undefined;
            if (!(__inst != null)) __r = (@as(c_int, 0)) else if ((__inst.*.g_class != null) and (__inst.*.g_class.*.g_type == __t)) __r = @boolToInt((!((@as(c_int, 0)) != 0))) else __r = c.g_type_check_instance_is_a(__inst, __t);
            break :blk __r;
        }) != 0) {} else {
            c.g_return_if_fail_warning((@intToPtr([*c]c.gchar, @as(c_int, 0))), (("xfce_panel_module_realize")), "XFCE_IS_PANEL_PLUGIN (xpp)");
            return;
        }
        if (!(@as(c_int, 0) != 0)) break;
    }
    _ = c.g_signal_handlers_disconnect_matched(@ptrCast(c.gpointer, (@ptrCast([*c]c.GObject, @alignCast(@alignOf(c.GObject), c.g_type_check_instance_cast(@ptrCast([*c]c.GTypeInstance, @alignCast(@alignOf(c.GTypeInstance), (xpp))), (@bitCast(c.GType, @as(c_long, ((@as(c_int, 20)) << @intCast(@import("std").math.Log2Int(c_int), (@as(c_int, 2)))))))))))), @intToEnum(c.GSignalMatchType, (c.G_SIGNAL_MATCH_FUNC | c.G_SIGNAL_MATCH_DATA)), @bitCast(c.guint, @as(c_int, 0)), @bitCast(c.GQuark, @as(c_int, 0)), null, @ptrCast(c.gpointer, @intToPtr(c.gpointer, @ptrToInt((@ptrCast(c.GCallback, @alignCast(@alignOf(fn () callconv(.C) void), (xfce_panel_module_realize))))))), (@intToPtr(?*c_void, @as(c_int, 0))));
    constructor(xpp);
}
pub export fn xfce_panel_module_construct(arg_xpp_name: [*c]const c.gchar, arg_xpp_unique_id: c.gint, arg_xpp_display_name: [*c]const c.gchar, arg_xpp_comment: [*c]const c.gchar, arg_xpp_arguments: [*c][*c]c.gchar, arg_xpp_screen: ?*c.GdkScreen) [*c]c.XfcePanelPlugin {
    var xpp_name = arg_xpp_name;
    var xpp_unique_id = arg_xpp_unique_id;
    var xpp_display_name = arg_xpp_display_name;
    var xpp_comment = arg_xpp_comment;
    var xpp_arguments = arg_xpp_arguments;
    var xpp_screen = arg_xpp_screen;
    var xpp: [*c]c.XfcePanelPlugin = null;
    while (true) {
        if ((blk: {
            var __inst: [*c]c.GTypeInstance = @ptrCast([*c]c.GTypeInstance, @alignCast(@alignOf(c.GTypeInstance), (xpp_screen)));
            var __t: c.GType = (c.gdk_screen_get_type());
            var __r: c.gboolean = undefined;
            if (!(__inst != null)) __r = (@as(c_int, 0)) else if ((__inst.*.g_class != null) and (__inst.*.g_class.*.g_type == __t)) __r = @boolToInt((!((@as(c_int, 0)) != 0))) else __r = c.g_type_check_instance_is_a(__inst, __t);
            break :blk __r;
        }) != 0) {} else {
            c.g_return_if_fail_warning((@intToPtr([*c]c.gchar, @as(c_int, 0))), ("xfce_panel_module_construct"), "GDK_IS_SCREEN (xpp_screen)");
            return null;
        }
        if (!(@as(c_int, 0) != 0)) break;
    }
    while (true) {
        if ((xpp_name != @ptrCast([*c]const c.gchar, @alignCast(@alignOf(c.gchar), (@intToPtr(?*c_void, @as(c_int, 0)))))) and (xpp_unique_id != -@as(c_int, 1))) {} else {
            c.g_return_if_fail_warning((@intToPtr([*c]c.gchar, @as(c_int, 0))), (("xfce_panel_module_construct")), "xpp_name != NULL && xpp_unique_id != -1");
            return null;
        }
        if (!(@as(c_int, 0) != 0)) break;
    }
    {
        xpp = @ptrCast([*c]c.XfcePanelPlugin, @alignCast(@alignOf(c.XfcePanelPlugin), c.g_object_new((c.xfce_panel_plugin_get_type()), "name", xpp_name, "unique-id", xpp_unique_id, "display-name", xpp_display_name, "comment", xpp_comment, "arguments", xpp_arguments, (@intToPtr(?*c_void, @as(c_int, 0))))));
        _ = c.g_signal_connect_data(@ptrCast(c.gpointer, (@ptrCast([*c]c.GObject, @alignCast(@alignOf(c.GObject), c.g_type_check_instance_cast(@ptrCast([*c]c.GTypeInstance, @alignCast(@alignOf(c.GTypeInstance), (xpp))), (@bitCast(c.GType, @as(c_long, ((@as(c_int, 20)) << @intCast(@import("std").math.Log2Int(c_int), (@as(c_int, 2)))))))))))), "realize", (@ptrCast(c.GCallback, @alignCast(@alignOf(fn () callconv(.C) void), (xfce_panel_module_realize)))), (@intToPtr(?*c_void, @as(c_int, 0))), null, @intToEnum(c.GConnectFlags, c.G_CONNECT_AFTER));
    }
    return xpp;
}
