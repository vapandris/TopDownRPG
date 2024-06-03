const rl = @import("raylib");
const std = @import("std");

pub var gameStatus: GameStatus = .mainMenu;
pub var gameWorld: GameWorld = undefined;

pub const GameStatus = union(enum) {
    mainMenu,
    play,
    paused,
    // quit,
};

pub const GameWorld = struct {
    const Vec2 = rl.Vector2;

    camera: Vec2,

    lvl: struct {
        map: [][]const u8,

        const Self = @This();
        pub fn width(self: Self) usize {
            return self.map[0].len;
        }

        pub fn height(self: Self) usize {
            return self.map.len;
        }
    },

    pub fn drawLevel(self: GameWorld) void {
        for (self.lvl.map) |cols| {
            for (cols) |char| {
                std.debug.print("{c}", .{char});
            }
            std.debug.print("\n", .{});
        }
    }

    // call like: gameWorld.loadLevel(@constCast(&lvl1));
    pub fn loadLevel(self: *GameWorld, lvl: [][]const u8) void {
        self.*.lvl.map = lvl;
    }
};

fn clamp(num: f32, min: f32, max: f32) f32 {
    if (min > max) unreachable;

    return @max(min, @min(max, num));
}

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
    "#~~~~~~~~.....       xx##",
    "#~~~~~~~~....   ...  ..##",
    "#~~~~~~~~....  ........x#",
    "#..~~~~~.....  ........x#",
    "#..~~~~~.....  ........x#",
    "#..~~~~~.....  .......x##",
    "##~~~~~.....  ...xxxxxx##",
    "###~~~.....  ..xxxxxxx###",
    "##########xxxxxxxxxx#####",
    "#########################",
};
