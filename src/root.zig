//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

fn turn(start: i8, rotation: []const u8) i8 {
    var factor: i8 = undefined;
    switch (rotation[0]) {
        'R' => factor = 1,
        'L' => factor = -1,
        else => unreachable,
    }
    var clicks: i8 = undefined;
    clicks = std.fmt.parseInt(i8, rotation[1..], 10) catch unreachable;
    return start + (factor * clicks);
}

test "11R8" {
    try testing.expect(turn(11, "R8") == 19);
}

test "19L19" {
    try testing.expect(turn(19, "L19") == 0);
}

test "0L1" {
    try testing.expect(turn(0, "L1") == 99);
}
