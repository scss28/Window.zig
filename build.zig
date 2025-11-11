const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const root = switch (target.result.os.tag) {
        .linux => b.path("src/XcbWindow.zig"),
        .windows => b.path("src/Win32Window.zig"),
        else => @panic("unsupported"),
    };

    const mod = b.addModule("Window", .{
        .root_source_file = root,
        .target = target,
    });

    switch (target.result.os.tag) {
        .linux => {
            mod.linkSystemLibrary("xcb", .{});
            mod.linkSystemLibrary("egl", .{});
            mod.link_libc = true;
        },
        else => {},
    }
}
