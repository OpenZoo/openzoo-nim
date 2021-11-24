import sdl2
import gamevars
import oop

discard sdl2.init(INIT_EVERYTHING)

var
  window: WindowPtr
  renderer: RendererPtr

window = sdl2.createWindow("OpenZoo", 100, 100, 640, 350, SDL_WINDOW_SHOWN)
renderer = sdl2.createRenderer(window, -1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)

var
  evt = sdl2.defaultEvent
  running = true

while running:
  while sdl2.pollEvent(evt):
    if evt.kind == QuitEvent:
      running = false
      break

  renderer.setDrawColor(0, 0, 0, 255)
  renderer.clear()
  renderer.present()

destroy renderer
destroy window
