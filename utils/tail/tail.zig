const std = @import("std");
var stdout_buffer:[1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const cwd = std.fs.cwd();

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    if(args.len == 1) {
        try stdout.print("Usage: tail <file>\n", .{});
        try stdout.flush();
        std.posix.exit(1);
    }

    _ = try print_lines(args[1]);
}

pub fn print_lines(filename:[]const u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const file = try cwd.openFile(filename, .{.mode = .read_only});
    defer file.close();
    var buffer:[1024]u8 = undefined;
    const nread = try file.readAll(&buffer);
    var it = std.mem.splitBackwardsScalar(u8, buffer[0..nread], '\n');
    var list = try std.ArrayList([]u8).initCapacity(allocator, 100);
    defer list.deinit(allocator);
    var i:u32 = 0;
    while (it.next()) |line| {
        if (i==5) break;
        try list.append(allocator, @constCast(line));
        i += 1;
    }
    std.mem.reverse([]u8, list.items);
    
    var line_number:u32 = 1;
    for (list.items) |line| {
        try stdout.print("{d} | {s}\n", .{line_number, line});
        line_number += 1;
    } try stdout.flush();
}
