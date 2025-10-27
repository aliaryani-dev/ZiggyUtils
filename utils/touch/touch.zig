const std = @import("std");
var stdout_buffer:[1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const cwd = std.fs.cwd();

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const args = try std.process.argsAlloc(allocator);
    if (args.len == 1) {
        try stdout.print("Usage: touch <file1> <file2> ...\n", .{});
        try stdout.flush();
        std.posix.exit(1);
    }

    for (args[1..]) |file_name| {
        const file = try cwd.createFile(file_name, .{});
        file.close();
        
    }
}
