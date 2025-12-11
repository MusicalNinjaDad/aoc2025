//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

pub export fn add(a: i32, b: i32) i32 {
    return a + b;
}

fn turn(_: i8, rotation: []const u8) u7 {
    switch (rotation[0]) {
        'R' => return 19,
        'L' => return 0,
        else => unreachable,
    }
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}

test "11R8" {
    try testing.expect(turn(11, "R8") == 19);
}

test "19L19" {
    try testing.expect(turn(19, "L19") == 0);
}
