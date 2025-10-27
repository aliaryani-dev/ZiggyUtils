const std = @import("std");
var stdout_buffer:[1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const cwd = std.fs.cwd();

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    if(args.len == 1) {
        try stdout.print("Usage: tail [-n <NUM>] <file>\n", .{});
        try stdout.flush();
        std.posix.exit(1);
    }
    if(std.mem.eql(u8, args[1], "-n")){
        _ = try print_lines(args[3],try std.fmt.parseInt(u32, args[2], 10));
    } else {
    _ = try print_lines(args[1],10);
    }
}

pub fn print_lines(filename:[]const u8,line_count:u32) !void {
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
        if (i==line_count) break;
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
