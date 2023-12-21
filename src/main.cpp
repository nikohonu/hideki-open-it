#include <iostream>

#include "raylib.h"

int main() {
  const int screenWidth = 640;
  const int screenHeight = 360;
  InitWindow(screenWidth, screenHeight, "hideki-open-it");
  while (!WindowShouldClose()) {
    if (IsKeyPressed(KEY_F11)) {
      int display = GetCurrentMonitor();
      std::cout << display << "\n";
      if (IsWindowFullscreen()) {
        SetWindowSize(screenWidth, screenHeight);
      } else {
        SetWindowSize(GetMonitorWidth(display), GetMonitorHeight(display));
      }
      ToggleFullscreen();
    }
    BeginDrawing();
    ClearBackground(RAYWHITE);
    DrawText("It's work!", 0, 0, 20, LIGHTGRAY);
    EndDrawing();
  }
  CloseWindow();
  return 0;
}
