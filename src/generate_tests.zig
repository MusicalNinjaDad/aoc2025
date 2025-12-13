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
    const output_file = std.fs.cwd().createFile("gen_tests.zig", .{}) catch |err| {
        fatal("unable to open '{s}/{s}': {s}", .{ std.fs.cwd(), "gen_tests.zig", @errorName(err) });
    };
    defer output_file.close();

    try output_file.writeAll("foo");

    return std.process.cleanExit();
}

fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.debug.print(format, args);
    std.process.exit(1);
}
