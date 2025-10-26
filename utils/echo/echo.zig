const std = @import("std");
var stdout_buffer:[1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    if (args.len == 1) {
        try stdout.print("Usage: echo <text>\n", .{});
        try stdout.flush();
        std.posix.exit(1);
    }
    
    for (args[1..]) |text| {
        try stdout.print("{s} ", .{text});
    }
    try stdout.print("\n", .{});
    try stdout.flush();
}
