--
-- Main game file. 
--

-- Path magic apparently
require 'luarocks.loader'
sdl = require 'SDL'
image = require 'SDL.image'

-- Other requires for this game
Entity = require 'entity'

-- Variables and stuff
running = true
width = 1280
height = 720

dir = { 1, 1 }
graphics = {}
pos = {}

-- Initialises the SDL context
initialise = (w, h) ->
  stuff = {}
  sdl.init sdl.flags.Video, sdl.flags.Audio, sdl.flags.OpenGL

  stuff.win = sdl.createWindow title:"Dino Dino", width:w, height:h
  stuff.rndr = sdl.createRenderer stuff.win, -1
  stuff.rndr\setDrawColor 0x333333
  return stuff

-- Initialise the graphics thingy
graphics = initialise width, height

-- Initialise new entity for rawr.png
player = Entity "assets/rawr.png", graphics.rndr, { x:50, y:50, w:64, h:64 }

while true
  for e in sdl.pollEvent!
    if e.type == sdl.event.quit
      running = false
    elseif e.type == sdl.event.KeyDown
      print string.format("key down: %d -> %s", e.keysym.sym, sdl.getKeyName(e.keysym.sym))

  graphics.rndr\clear!
  player\render!
  graphics.rndr\present!

  sdl.delay 10

-- Clean up our shit
sdl.quit
image.quit

-- while running 
--     for e in sdl.pollEvent()
--         if e.type == sdl.event.Quit
--             running = false
--         elseif e.type == sdl.event.KeyDown
--             print(string.format("key down: %d -> %s", e.keysym.sym, sdl.getKeyName(e.keysym.sym)))
--         elseif e.type == sdl.event.MouseWheel
--             print(string.format("mouse wheel: %d, x=%d, y=%d", e.which, e.x, e.y))
--         elseif e.type == sdl.event.MouseButtonDown
--             print(string.format("mouse button down: %d, x=%d, y=%d", e.button, e.x, e.y))
--         elseif e.type == sdl.event.MouseMotion
--             print(string.format("mouse motion: x=%d, y=%d", e.x, e.y))
