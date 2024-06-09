const rl = @import("raylib");
const std = @import("std");
const world = @import("Game/world.zig");

pub fn main() anyerror!void {
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "rpg");
    defer rl.closeWindow();

    world.gameWorld = world.GameWorld.init();

    const player = world.gameWorld.player;
    std.debug.print("player(x, y): {d} {d}\nplayer(r): {d}\n\n", .{ player.pos.x, player.pos.y, player.r });

    const cam = world.gameWorld.camera;

    const camMidX = cam.pos.x + cam.size.w / 2;
    const camMidY = cam.pos.y + cam.size.h / 2;

    std.debug.print("camera(x, y): {d} {d}\ncamera(w, h): {d} {d}\n\ncamera's mid(x, y): {d} {d}\n\n", .{ cam.pos.x, cam.pos.y, cam.size.w, cam.size.h, camMidX, camMidY });

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);
        world.gameWorld.draw();
    }
}
