const std = @import("std");
const args = std.process.args();
var stdout_buffer:[1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    if (args.len < 2) {
        try stdout.print("Usage: cat <file>\n", .{});
        return;
    }
}
