const rl = @import("raylib");
const std = @import("std");
const gameState = @import("gameState.zig");

pub fn main() anyerror!void {
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    gameState.gameWorld.loadLevel(@constCast(&gameState.lvl1));
    gameState.gameWorld.player = .{
        .pos = .{ .x = screenWidth / 2, .y = screenHeight / 2 },
        .r = 30,
    };

    for (0..40) |i| {
        const f: f32 = @floatFromInt(i);
        std.debug.print("sqrt({d}): {d}\n", .{ f, @import("World/math.zig").sqrt(f) });
    }

    const seed = 320;
    @import("World/math.zig").seed(seed);
    for (0..40) |i| {
        _ = i;
        std.debug.print("rand: {}\n", .{@import("World/math.zig").rand() % 10});
    }

    // Main game loop
    while (!rl.windowShouldClose()) {
        gameState.gameWorld.update();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);
        gameState.gameWorld.drawLevel();
    }
}
