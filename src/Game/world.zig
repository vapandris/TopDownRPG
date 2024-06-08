const rl = @import("raylib");
const std = @import("std");

const camera = @import("Base/camera.zig");
const geometry = @import("Base/geometry.zig");
const timer = @import("Base/timer.zig");

pub const GameStatus = union(enum) {
    mainMenu,
    play,
    paused,
    // quit,
};

const GameWorld = struct {
    const Vec2 = geometry.Vec2;

    camera: camera.Camera,
    lvl: Level,

    pub fn update(self: *GameWorld) void {
        const goLeft = rl.isKeyDown(.key_a) or rl.isKeyDown(.key_left);
        const goRight = rl.isKeyDown(.key_d) or rl.isKeyDown(.key_right);
        const goUp = rl.isKeyDown(.key_w) or rl.isKeyDown(.key_up);
        const goDown = rl.isKeyDown(.key_s) or rl.isKeyDown(.key_down);

        if (goLeft) self.*.player.vel.x -= 50;
        if (goRight) self.*.player.vel.x += 50;
        if (goUp) self.*.player.vel.y -= 50;
        if (goDown) self.*.player.vel.y += 50;

        self.*.player.move(8);
    }
};

const Level = struct {
    map: [][]const u8,

    // call like: gameWorld.loadLevel(@constCast(&lvl1));
    pub fn loadLevel(self: *Level, lvl: [][]const u8) void {
        self.*.map = lvl;
    }

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

// ' ' is road (walkable and fast)
// '.' is grass (walkable area)
// '~' is water (walkable but slow)
// 'x' is bushes (walkable but slow)
// '#' is solid wall/boundary
pub const lvl1 = [_][]const u8{
    "##################  #####",
    "####~~############  #####",
    "#####~~#####......  x####",
    "####~~~~..........  xx###",
    "##~~~~~~~~........  xxx##",
    "#~~~~~~~~.....      .xx##",
    "#~~~~~~~~....   ... ..x##",
    "#~~~~~~~~...x  .......xx#",
    "#..~~~~~...xx  ....xx..x#",
    "#..~~~~~...xx  ...xx...x#",
    "#..~~~~~.....  .......x##",
    "##~~~~~.....  ...xxxxxx##",
    "###~~~.....  ..xxxxxxx###",
    "##########xxxxxxxxxx#####",
    "#########################",
};
