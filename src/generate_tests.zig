const std = @import("std");
const testing = std.testing;
const Tests = @import("root.zig").Tests; // cannot use "root" here: https://github.com/ziglang/zig/issues/17109

test "all2" {
    const t: Tests = .{};
    inline for (t.cases) |tc| {
        std.log.warn("generated {}", .{tc});
        try tc.run();
    }
}
