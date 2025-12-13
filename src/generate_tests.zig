const std = @import("std");
const testing = std.testing;
const Tests = @import("tested_module").Tests;

test "all2" {
    const t: Tests = .{};
    inline for (t.cases) |tc| {
        std.log.warn("generated {}", .{tc});
        try tc.run();
    }
}

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const args = try std.process.argsAlloc(arena);

    if (args.len > 2) fatal("expected 1 arg, got {d} ({s})", .{ args.len, args });

    const output_dir = args[1];
    const output_filename = try std.fs.path.join(arena, &.{
        output_dir,
        "gentests.zig",
    });

    const output_file = std.fs.cwd().createFile(output_filename, .{}) catch |err| {
        fatal("unable to open '{s}': {s}", .{ output_filename, @errorName(err) });
    };
    defer output_file.close();

    const t: Tests = .{};
    inline for (t.cases) |tc| {
        try output_file.writeAll("test \"" ++ tc.name ++ "\"\n");
    }
    try output_file.writeAll("foo");
    std.log.warn("created {s}", .{output_filename});

    return std.process.cleanExit();
}

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.debug.print(format, args);
    std.process.exit(1);
}
