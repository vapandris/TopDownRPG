const rl = @import("raylib");
const std = @import("std");

const camera = @import("../Base/camera.zig");
const geometry = @import("../Base/geometry.zig");
const timer = @import("../Base/timer.zig");

pub const GameStatus = union(enum) {
    mainMenu,
    play,
    paused,
    // quit,
};

pub var gameWorld: GameWorld = undefined;

pub const GameWorld = struct {
    const Vec2 = geometry.Vec2;

    camera: camera.Camera,
    player: geometry.Circle,
    lvl: Level,

    pub fn init() GameWorld {
        var result = GameWorld{
            .lvl = undefined,
            .player = undefined,
            .camera = .{
                .pos = .{ .x = 0, .y = 0 },
                .size = .{ .w = 300, .h = 200 },
            },
        };

        result.lvl.loadLevel(@constCast(&lvl1));
        result.player = .{
            .pos = Level.getGamePosition(lvl1StartCol, lvl1StartRow),
            .r = 30,
        };
        result.camera.centerOn(result.player.pos);

        return result;
    }

    pub fn update(self: *GameWorld) void {
        self.*.camera.centerOn(self.player.pos);

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

    pub fn draw(self: GameWorld) void {
        const visibleTilesX: u32 = @intFromFloat(@ceil(self.camera.size.w / @as(f32, @floatFromInt(Level.tileSize))));
        const visibleTilesY: u32 = @intFromFloat(@ceil(self.camera.size.h / @as(f32, @floatFromInt(Level.tileSize))));

        //var startPos = self.camera.pos;

        _ = visibleTilesX;
        _ = visibleTilesY;
    }
};

const Level = struct {
    const tileSize = 16;
    const topLeftPos: geometry.Vec2 = .{ .x = 0, .y = 0 };

    map: [][]const u8,

    // call like: gameWorld.loadLevel(@constCast(&lvl1));
    pub fn loadLevel(self: *Level, lvl: [][]const u8) void {
        self.*.map = lvl;
    }

    pub fn cols(self: Level) u32 {
        return @intCast(self.map[0].len);
    }

    pub fn rows(self: Level) u32 {
        return @intCast(self.map.len);
    }

    pub fn width(self: Level) f32 {
        return @floatFromInt(tileSize * self.cols());
    }

    pub fn height(self: Level) f32 {
        return @floatFromInt(tileSize * self.rows());
    }

    pub fn getGamePosition(col: u32, row: u32) geometry.Vec2 {
        return .{
            .x = topLeftPos.x + @as(f32, @floatFromInt(col * tileSize)),
            .y = topLeftPos.y + @as(f32, @floatFromInt(row * tileSize)),
        };
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

pub const lvl1StartCol = 9;
pub const lvl1StartRow = 9;
