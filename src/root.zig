//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

fn turn(start: i16, rotation: Rotation) !i16 {
    var end = @rem(start + rotation.clicks, 100);
    while (end < 0) {
        end += 100;
    }
    return end;
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

pub const Tests = struct {
    cases: [5]TestCase = .{
        .{ .name = "11R8", .start = 11, .turn = "R8", .expected = 19 },
        .{ .name = "19L19", .start = 19, .turn = "L19", .expected = 0 },
        .{ .name = "0L1", .start = 0, .turn = "L1", .expected = 99 },
        .{ .name = "99R1", .start = 99, .turn = "R1", .expected = 0 },
        .{ .name = "overflow i8", .start = 99, .turn = "R99", .expected = 98 },
    },

    const TestCase = struct {
        name: []const u8,
        start: i16,
        turn: []const u8,
        expected: i16,

        pub fn run(tc: *const TestCase) !void {
            std.testing.log_level = .info;
            std.log.info("test {s}", .{tc.name});
            try testing.expectEqual(tc.expected, try turn(tc.start, try Rotation.parse(tc.turn)));
        }
    };
};

test "rotate_twice" {
    const turns = [_]Rotation{ try Rotation.parse("L68"), try Rotation.parse("L30") };
    var start: i16 = 50;
    for (turns) |t| {
        start = try turn(start, t);
    }
    try testing.expectEqual(52, start);
}

test "count_zeros" {
    comptime {
        const turns = .{ "L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82" };
        var start: i16 = 50;
        for (turns) |t| {
            start = try turn(start, try Rotation.parse(t));
        }
        try testing.expectEqual(32, start);
    }
}
