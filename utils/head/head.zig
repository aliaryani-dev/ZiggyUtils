const std = @import("std");
var stdout_buffer:[1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const cwd = std.fs.cwd();

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    if (args.len == 1) {
        try stdout.print("Usage: head [-n <NUM>] <file>\n", .{});
        try stdout.flush();
        std.posix.exit(1);
    }

    if (std.mem.eql(u8, args[1], "-n")) {
        _ = try read_lines(args[3],try std.fmt.parseInt(usize, args[2], 10));
    } else {
    _ = try read_lines(args[1],10);
    }
}

fn read_lines(file_name:[]const u8,line_count:usize) !void {
    const file = try cwd.openFile(file_name, .{.mode = .read_only});
    defer file.close();
    var buffer:[1024]u8 = undefined;
    const nread = try file.read(buffer[0..]);
    var it = std.mem.splitScalar(u8, buffer[0..nread], '\n');
    var i:u32 = 0;
    while (it.next()) |line|{
        if (i == line_count) {
            break;
        } 
        try stdout.print("{d} | {s}\n", .{(i+1),line});
        i += 1;
    } try stdout.flush();
}
