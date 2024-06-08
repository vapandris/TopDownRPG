const rl = @import("raylib");

// Used for logical position, or Vectors in the game
pub const Vec2 = struct { x: f32, y: f32 };

/// Used for logical size in the game
pub const Size = struct { w: f32, h: f32 };

pub const Rect = struct {
    pos: Vec2,
    size: Size,
};

pub const Circle = struct {
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
