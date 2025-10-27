const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const cat = b.addExecutable(.{
        .name = "cat",
        .root_module = b.createModule(.{
            .root_source_file = b.path("utils/cat/cat.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    b.installArtifact(cat);

    const echo = b.addExecutable(.{
        .name = "echo",
        .root_module = b.createModule(.{
            .root_source_file = b.path("utils/echo/echo.zig"),
            .optimize = optimize,
            .target = target,
        }),
    });
    b.installArtifact(echo);

    const head = b.addExecutable(.{
        .name = "head",
        .root_module = b.createModule(.{
            .root_source_file = b.path("utils/head/head.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    b.installArtifact(head);

    const tail = b.addExecutable(.{
        .name = "tail",
        .root_module = b.createModule(.{
            .optimize = optimize,
            .target = target,
            .root_source_file = b.path("utils/tail/tail.zig"),
        }),
    });
    b.installArtifact(tail);
}
