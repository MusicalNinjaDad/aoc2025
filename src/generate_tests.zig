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

    if (args.len > 2) fatal("expected 1 arg, got {d}", .{args.len});

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
    try output_file.writeAll(
        \\const std = @import("std");
        \\const testing = std.testing;
        \\const Tests = @import("tested_module").Tests;
        \\
        \\const t: Tests = .{};
        \\
        \\test {
        \\  std.testing.log_level = .info;
        \\  std.log.info("running {s}", .{ @src().file });
        \\}
        \\
    );

    inline for (@typeInfo(Tests).@"struct".fields) |field| {
        const testname = field.name;
        inline for (@field(t, testname), 0..) |tc, i| {
            try output_file.writeAll("test \"" ++ testname ++ "/" ++ tc.name ++ "\" {\n");
            const line2 = try std.fmt.allocPrint(arena, "try t.{s}[{d}].run();\n", .{ testname, i });
            try output_file.writeAll(line2);
            try output_file.writeAll("}\n\n");
        }
    }
    std.log.info("created {s}", .{output_filename});

    return std.process.cleanExit();
}

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.log.err(format, args);
    std.process.exit(1);
}
