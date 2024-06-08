const geometry = @import("geometry.zig");
const rl = @import("raylib");

pub const Camera = struct {
    pos: geometry.Vec2,
    size: geometry.Size,

    fn getScreenSize() geometry.Size {
        return .{
            .w = @floatFromInt(rl.getScreenWidth()),
            .h = @floatFromInt(rl.getScreenHeight()),
        };
    }

    /// Is used to convert mouse clicks to game-coordinates
    pub fn GamePos_From_ScreenPos(self: Camera, screenPos: rl.Vector2) geometry.Vec2 {
        if (self.size.w <= 0 or self.size.h <= 0) unreachable;

        const screenSize = getScreenSize();
        const widthScale = self.size.w / screenSize.w;
        const heightScale = self.size.h / screenSize.h;

        return .{
            .x = (screenPos.x / widthScale) + self.pos.x,
            .y = (screenPos.y / heightScale) + self.pos.y,
        };
    }

    /// Is used to figure out where to draw entities to the screen
    pub fn ScreenRect_From_GameRect(self: Camera, gameRect: geometry.Rect) ScreenRect {
        if (self.size.w <= 0 or self.size.h <= 0) unreachable;

        const screenSize = getScreenSize();
        const widthScale = self.size.w / screenSize.w;
        const heightScale = self.size.h / screenSize.h;

        return .{
            .pos = .{
                .x = @intFromFloat(@ceil((gameRect.pos.x - self.pos.x) * widthScale)),
                .y = @intFromFloat(@ceil((gameRect.pos.y - self.pos.y) * heightScale)),
            },
            .size = .{
                .w = @intFromFloat(@ceil(gameRect.size.w * widthScale)),
                .h = @intFromFloat(@ceil(gameRect.size.h * heightScale)),
            },
        };
    }

    /// Should never be used in production code. Shall be used for debug purposes only
    pub fn ScreenCircle_From_GameCircle(self: Camera, gameCircle: geometry.Circle) ScreenCircle {
        if (self.size.w <= 0 or self.size.h <= 0) unreachable;

        const screenSize = getScreenSize();
        const widthScale = self.size.w / screenSize.w;
        const heightScale = self.size.h / screenSize.h;

        return .{
            .pos = .{
                .x = @intFromFloat(@ceil((gameCircle.pos.x - self.pos.x) * widthScale)),
                .y = @intFromFloat(@ceil((gameCircle.pos.y - self.pos.y) * heightScale)),
            },
            .r = @intFromFloat(@ceil(gameCircle.r * (widthScale / 2 + heightScale / 2))),
        };
    }
};

/// Contains all the necessairy data that is used to draw rectangles/sprites to the screen
const ScreenRect = struct {
    pos: struct { x: i32, y: i32 },
    size: struct { w: i32, h: i32 },
};

const ScreenCircle = struct {
    pos: struct { x: i32, y: i32 },
    r: i32,
};
