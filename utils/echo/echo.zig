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
    var new_line:bool = true;
    var escape_char = false;
    for (args[1..]) |text| {
        if(std.mem.eql(u8, text, "-n")) {
            new_line = false;
            continue;
        }
        if(std.mem.eql(u8, text, "-e")) {
            escape_char = true;
            continue;
        }

        try stdout.print("{s} ", .{text});
    }
    if(new_line)
        try stdout.print("\n", .{});
    try stdout.flush();
}
