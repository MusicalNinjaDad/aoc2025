//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

fn turn(_: i8, rotation: []const u8) u7 {
    switch (rotation[0]) {
        'R' => return 19,
        'L' => return 0,
        else => unreachable,
    }
}

test "11R8" {
    try testing.expect(turn(11, "R8") == 19);
}

test "19L19" {
    try testing.expect(turn(19, "L19") == 0);
}
