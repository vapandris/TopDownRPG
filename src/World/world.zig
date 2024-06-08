const rl = @import("raylib");
const std = @import("std");

const camera = @import("camera.zig");
const geometry = @import("geometry.zig");
const timer = @import("timer.zig");

pub const GameStatus = union(enum) {
    mainMenu,
    play,
    paused,
    // quit,
};

const Level = struct {
    map: [][]const u8,

    pub fn width(self: Level) u32 {
        return @intCast(self.map[0].len);
    }

    pub fn height(self: Level) u32 {
        return @intCast(self.map.len);
    }

    pub fn getTile(self: Level, x: u32, y: u32) ?u8 {
        if (0 <= x and
            self.width() < x and
            0 <= y and
            self.height() < y)
        {
            return self.map[y][x];
        } else unreachable;

        return null;
    }
};
