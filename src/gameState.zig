const rl = @import("raylib");
const std = @import("std");

const camera = @import("World/camera.zig");

pub var gameStatus: GameStatus = .mainMenu;
pub var gameWorld: GameWorld = undefined;

pub const GameStatus = union(enum) {
    mainMenu,
    play,
    paused,
    // quit,
};

const Level = struct {
    map: [][]const u8,

    const Self = @This();
    pub fn width(self: Self) u32 {
        return @intCast(self.map[0].len);
    }

    pub fn height(self: Self) u32 {
        return @intCast(self.map.len);
    }

    pub fn getTile(self: Level, x: u32, y: u32) ?u8 {
        if (0 <= x and
            self.width() < x and
            0 <= y and
            self.height() < y)
        {
            return self.map[y][x];
        }

        return null;
    }
};

pub const GameWorld = struct {
    const Vec2 = rl.Vector2;

    camera: Vec2,
    player: Circle,
    lvl: Level,

    pub fn drawLevel(self: GameWorld) void {
        _ = self;
    }

    // call like: gameWorld.loadLevel(@constCast(&lvl1));
    pub fn loadLevel(self: *GameWorld, lvl: [][]const u8) void {
        self.*.lvl.map = lvl;
    }

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

fn clamp(num: f32, min: f32, max: f32) f32 {
    if (min > max) unreachable;

    return @max(min, @min(max, num));
}

const Circle = struct {
    const Vec2 = rl.Vector2;

    pos: Vec2,
    r: f32,

    vel: Vec2 = .{ .x = 0, .y = 0 },
    acc: Vec2 = .{ .x = 0, .y = 0 },

    pub fn mass(self: Circle) f32 {
        return self.r * 10;
    }

    pub fn isCircleCircleOverlap(c1: Circle, c2: Circle) bool {
        const distanceSq = @abs((c1.pos.x - c2.pos.x) * (c1.pos.x - c2.pos.x) + (c1.pos.y - c2.pos.y) * (c1.pos.y - c2.pos.y));
        const radiusSq = (c1.r + c2.r) * (c1.r + c2.r);
        return distanceSq < radiusSq;
    }

    pub fn move(self: *Circle, friction: f32) void {
        const frameTime = rl.getFrameTime();
        self.*.acc.x = -self.vel.x * friction;
        self.*.acc.y = -self.vel.y * friction;
        self.*.vel.x += self.acc.x * frameTime;
        self.*.vel.y += self.acc.y * frameTime;

        self.*.pos.x += self.vel.x * frameTime;
        self.*.pos.y += self.vel.y * frameTime;

        const speed = (self.vel.x * self.vel.x) + (self.vel.y * self.vel.y);

        // if the circle is slow enough, stop it.
        if (@abs(speed) < 250) {
            self.*.vel = .{ .x = 0, .y = 0 };
            self.*.acc = .{ .x = 0, .y = 0 };
        }
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
