const std = @import("std");
var stdout_buffer:[1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const cwd = std.fs.cwd();

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    if (args.len == 1) {
        try stdout.print("Usage: head <file>\n", .{});
        try stdout.flush();
        std.posix.exit(1);
    }

}

fn read_lines(file_name:[]const u8) !void {
    const file = try cwd.openFile(file_name, .{.mode = .read_only});
    defer file.close();
}
