//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

fn turn(start: i8, rotation: Rotation) !i8 {
    const end = start + rotation.clicks;
    switch (end) {
        -127...-1 => return end + 100,
        100...127 => return end - 100,
        else => return end,
    }
}

const Rotation = struct {
    clicks: i8,

    pub fn parse(str: []const u8) !Rotation {
        var factor: i8 = undefined;
        switch (str[0]) {
            'R' => factor = 1,
            'L' => factor = -1,
            else => unreachable,
        }
        const clicks = try std.fmt.parseInt(i8, str[1..], 10);
        return Rotation{ .clicks = factor * clicks };
    }
};

test "11R8" {
    const rot = try Rotation.parse("R8");
    try testing.expect(try turn(11, rot) == 19);
}

test "19L19" {
    try testing.expect(try turn(19, "L19") == 0);
}

test "0L1" {
    try testing.expect(try turn(0, "L1") == 99);
}
