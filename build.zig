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
}
