const std = @import("std");
const tht = @import("tenhourtime.zig");

const PrintMode = enum {
    Raw,
    Formatted,
};
const TimeToGet = union(enum) {
    Current: void,
    MsSinceEpoch: u64,
    MsSinceDayStart: u64,
};

// stdout shouldn't be var here, that doesn't make sense vvvv
fn printTime(stdout: var, timeToGet: TimeToGet, mode: PrintMode) !void {
    const timeNum = tht.tenHourTime(switch (timeToGet) {
        .Current => tht.msSinceDayStart(tht.getTime()),
        .MsSinceEpoch => |ms| tht.msSinceDayStart(ms),
        .MsSinceDayStart => |ms| ms,
    });
    switch (mode) {
        .Formatted => {
            const timeData = tht.formatTime(timeNum);
            try stdout.print("{}", .{timeData});
        },
        .Raw => {
            try stdout.print("{}", .{timeNum});
        },
    }
}

pub fn main() !void {
    var timeToGet: TimeToGet = .Current;

    var mode: PrintMode = .Formatted;

    var lifetime: enum {
        Once,
        Forever,
    } = .Once;

    const stdout = std.io.getStdOut().outStream();

    {
        var args = std.process.args();
        _ = args.skip();

        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();

        var allocator = &arena.allocator;

        while (args.next(allocator)) |argValue| {
            const arg = try argValue;
            if (std.mem.eql(u8, arg, "--help")) {
                try stdout.print("tenhourtime\n" ++
                    "--help    | show help\n" ++
                    "-m        | select mode\n" ++
                    "-m raw    | print raw value, eg: `19079284`\n" ++
                    "-m format | [default] print formatted time, eg: `19LL 07cc 92ii 84qm`\n" ++
                    "--ms 1234 | get the time of a specific ms duration\n" ++
                    "--time 84 | get the time of a specific ms since epoch\n" ++
                    "--update  | run until ctrl+c\n", .{});
                return;
            } else if (std.mem.eql(u8, arg, "-m")) {
                var modeStr = try (args.next(allocator) orelse {
                    std.debug.warn("Missing -m option. Must be: raw | format\n", .{});
                    return error.MissingMode;
                });
                if (std.mem.eql(u8, modeStr, "raw")) {
                    mode = .Raw;
                } else if (std.mem.eql(u8, modeStr, "format")) {
                    mode = .Formatted;
                } else {
                    std.debug.warn("Invalid -m option. Must be: raw | format\n", .{});
                    return error.InvalidMode;
                }
            } else if (std.mem.eql(u8, arg, "--update")) {
                lifetime = .Forever;
            } else if (std.mem.eql(u8, arg, "--ms")) {
                var nextStr = try (args.next(allocator) orelse {
                    std.debug.warn("missing --ms time", .{});
                    return error.MissingMSTime;
                });
                timeToGet = TimeToGet{ .MsSinceDayStart = try std.fmt.parseUnsigned(u64, nextStr, 10) };
            } else if (std.mem.eql(u8, arg, "--time")) {
                var nextStr = try (args.next(allocator) orelse {
                    std.debug.warn("missing --time time", .{});
                    return error.MissingTimeTime;
                });
                timeToGet = TimeToGet{ .MsSinceEpoch = try std.fmt.parseUnsigned(u64, nextStr, 10) };
            } else {
                std.debug.warn("Invalid argument {}. See --help\n", .{arg});
                return error.InvalidArgument;
            }
        }
    }

    switch (lifetime) {
        .Forever => while (true) {
            try stdout.print("\r", .{});
            try printTime(stdout, timeToGet, mode);
            try stdout.print("\x1b[0K", .{});
            std.time.sleep(100);
        },
        .Once => {
            try printTime(stdout, timeToGet, mode);
            try stdout.print("\n", .{});
        },
    }
}
