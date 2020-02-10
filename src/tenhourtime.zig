const std = @import("std");
const c = @cImport({
    @cInclude("time.h");
});

/// get time in ms
pub fn getTime() u64 {
    return std.time.milliTimestamp();
}

/// get start of day in utc using time.h gmtime/timegm
pub fn getDayStart(time: u64) u64 {
    const timeSec: c.time_t = @intCast(c.time_t, time / 1000);
    // @compileLog(@TypeOf(&timeSec)); // this is one way to implement a hover provider in the stage1 compiler. add a @compilelog statement and check the error.
    var timeInfo = c.gmtime(&timeSec);
    timeInfo.*.tm_hour = 0;
    timeInfo.*.tm_min = 0;
    timeInfo.*.tm_sec = 0;
    const dayStartSec: u64 = @intCast(u64, c.timegm(timeInfo));
    return dayStartSec * 1000;
}

/// convert ms time to tenhourtime
pub fn tenHourTime(timeMs: u64) u64 {
    const dayStart = getDayStart(timeMs);
    const msSinceDayStart = timeMs -% dayStart; // in case dayStart > timeMs, make random output instead of crashing.
    const floatMsSinceDayStart: f64 = @intToFloat(f64, msSinceDayStart);
    const number: f64 = (24.0 * 60.0 * 60.0 * 1000.0) / 100000000.0;
    return @floatToInt(u64, floatMsSinceDayStart / number);
}

pub const TenHourTime = struct {
    LL: u8,
    cc: u8,
    ii: u8,
    qm: u8,
    pub fn format(timeData: *const TenHourTime, comptime fmt: []const u8, options: std.fmt.FormatOptions, context: var, comptime Errors: type, output: fn (@TypeOf(context), []const u8) Errors!void) Errors!void {
        return std.fmt.format(context, Errors, output, "{:0>2}LL {:0>2}cc {:0>2}ii {:0>2}qm", .{ timeData.LL, timeData.cc, timeData.ii, timeData.qm });
    }
};

/// seperate out tenhourtime into LL,cc,ii,qm
pub fn formatTime(tht: u64) TenHourTime {
    return .{
        .LL = @intCast(u8, (tht / 1000000) % 100),
        .cc = @intCast(u8, (tht / 10000) % 100),
        .ii = @intCast(u8, (tht / 100) % 100),
        .qm = @intCast(u8, (tht / 1) % 100),
    };
}

test "the time is correct" {
    var value = formatTime(tenHourTime(1581354755886));
    std.testing.expect(value.LL == 71);
    std.testing.expect(value.cc == 70);
    std.testing.expect(value.ii == 82);
    std.testing.expect(value.qm == 01);
}