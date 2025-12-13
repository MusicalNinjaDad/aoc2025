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
    try testing.expect(try turn(11, try Rotation.parse("R8")) == 19);
}

test "19L19" {
    try testing.expect(try turn(19, try Rotation.parse("L19")) == 0);
}

test "0L1" {
    try testing.expect(try turn(0, try Rotation.parse("L1")) == 99);
}

test "99R1" {
    try testing.expect(try turn(99, try Rotation.parse("R1")) == 0);
}

test {
    _ = @import("tests.zig");
}

pub const Tests = struct {
    cases: [2]TestCase = .{
        .{ .name = "11R8", .start = 11, .turn = "R8", .expected = 19 },
        .{ .name = "11R8_2", .start = 11, .turn = "R8", .expected = 19 },
    },

    const TestCase = struct {
        name: []const u8,
        start: i8,
        turn: []const u8,
        expected: i8,

        pub fn run(tc: *const TestCase) !void {
            std.testing.log_level = .info;
            std.log.info("test {s}", .{tc.name});
            try testing.expectEqual(try turn(tc.start, try Rotation.parse(tc.turn)), tc.expected);
        }
    };
};
