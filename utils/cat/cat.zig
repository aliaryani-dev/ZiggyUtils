const std = @import("std");
var stdout_buffer:[1024]u8 = undefined;
var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
const stdout = &stdout_writer.interface;
const cwd = std.fs.cwd();


pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    if (args.len < 2) {
        try stdout.print("Usage: cat <file>\n", .{});
        try stdout.flush();
        return;
    }

    for (args[1..]) |filename| {
        const file = try cwd.openFile(filename, .{.mode = .read_only});
        defer file.close();

        var buffer:[1024 * 1024]u8 = undefined;
        while (true) {
            const nread = try file.read(buffer[0..]);
            if (nread <= 0) break;
            try stdout.writeAll(buffer[0..nread]);
            try stdout.flush();
        }
    }

}
