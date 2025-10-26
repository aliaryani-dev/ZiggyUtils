const std = @import("std");
var stdout_buffer:[1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const cwd = std.fs.cwd();


pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer gpa.deinit();
    const allocator = gpa.allocator();
    const args = try std.process.argsAlloc(allocator);
    if (args.len < 2) {
        try stdout.print("Usage: cat <file>\n", .{});
        return;
    }

    for (args) |filename| {
        const file = try cwd.openFile(filename, .{.mode = .read_only});
        defer file.close();




    }

}
