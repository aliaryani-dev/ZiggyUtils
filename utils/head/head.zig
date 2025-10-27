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

    _ = try read_lines(args[1], allocator);

}

fn read_lines(file_name:[]const u8,allocator:std.mem.Allocator) !void {
    _ = allocator;
    const file = try cwd.openFile(file_name, .{.mode = .read_only});
    defer file.close();
    var buffer:[1024]u8 = undefined;
    const nread = try file.read(buffer[0..]);
    std.debug.print("{s}\n", .{buffer[0..nread]});
}
