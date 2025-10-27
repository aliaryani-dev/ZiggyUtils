const std = @import("std");
var stdout_buffer:[1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const path = std.posix.getenv("PWD");
    if (path) |not_null_path|
        try stdout.print("{s}\n", .{not_null_path});
    try stdout.flush();
}
