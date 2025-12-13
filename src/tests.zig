const std = @import("std");
const testing = std.testing;
const Tests = @import("root.zig").Tests;

test "all" {
    const t: Tests = .{};
    inline for (t.cases) |tc| {
        std.log.warn("{}", .{tc});
        try tc.run();
    }
}
