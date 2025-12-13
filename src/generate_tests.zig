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
