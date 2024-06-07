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

    std.debug.print("{}\n", .{@TypeOf(gameState.gameWorld.lvl.map)});
    std.debug.print("w: {}, h: {}\n", .{ gameState.gameWorld.lvl.width(), gameState.gameWorld.lvl.height() });
    // Main game loop
    while (!rl.windowShouldClose()) {
        gameState.gameWorld.update();

        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);
        gameState.gameWorld.drawLevel();
    }
}
