const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const fmt = b.addFmt(&[_][]const u8{ "src", "template_build.zig" });

    {
        const panel = b.step("panel", "Build panel");

        const mode = b.standardReleaseOptions();
        const lib = b.addSharedLibrary("tenhourtime", "src/panel.zig", b.version(1, 0, 0));
        lib.setBuildMode(mode);
        lib.linkLibC();
        @compileError("genbuild.js");
        lib.addIncludeDir("/usr/include/xfce4/libxfce4panel-1.0");
        lib.addIncludeDir("/usr/include");

        lib.install();

        panel.dependOn(&fmt.step);
        panel.dependOn(&lib.step);
        panel.dependOn(&lib.install_step.?.step);
    }

    {
        var cli = b.step("cli", "Build cli");

        const mode = b.standardReleaseOptions();
        const exe = b.addExecutable("tenhourtime", "src/cli.zig");
        exe.setBuildMode(mode);
        exe.linkLibC();

        exe.install();

        cli.dependOn(&fmt.step);
        cli.dependOn(&exe.step);
        cli.dependOn(&exe.install_step.?.step);

        const runCmd = exe.run();

        const runCli = b.step("run-cli", "Run cli");
        runCli.dependOn(cli);
        runCli.dependOn(&runCmd.step);
    }
    
    {
        var testc = b.step("test", "Test code");
        
        const mode = b.standardReleaseOptions();
        const t = b.addTest("src/tenhourtime.zig");
        t.setBuildMode(mode);
        t.linkLibC();
        
        testc.dependOn(&t.step);
    }
}

//// Run a test
//// b.addTest("src/file.zig")
// pub fn addTest(

//// Create a custom build step for the `zig build` command
//// Example:
//// ```zig
//// const fmtStep = b.step("fmt", "Format code");
//// const fmt = builder.addFmt(&[_][]const u8{"src"});
//// fmtStep.dependOn(&fmt.step);
//// ```
//// `zig build --help` will now show the fmt step and it can be used with `zig build fmt`
// pub fn step(

//// Create a step to format code with `zig fmt`.
//// Example:
//// ```zig
//// const fmtStep = b.step("fmt", "Format code");
//// const fmt = builder.addFmt(&[_][]const u8{"src"});
//// fmtStep.dependOn(&fmt.step);
//// ```
//// `zig build fmt` will now format all the code in src/
// pub fn addFmt(
