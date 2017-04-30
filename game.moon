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
player = Entity "rawr.png", graphics.rndr, { x:50, y:50, w:64, h:64 }

-- -- Init SDL and create a window
-- sdl.init sdl.flags.Video, sdl.flags.Audio, sdl.flags.OpenGL
-- graphics.window = sdl.createWindow title:"Dino Dino", width:width, height:height

-- -- Create a simple renderer
-- graphics.renderer = sdl.createRenderer graphics.window, -1
-- graphics.renderer\setDrawColor 0xFFFFFF

-- Load our *rawr* image (It's dinosaur for "I love you!")
-- image = image.load "rawr.png"

-- Convert the image to a surface
-- graphics.rawr = graphics.rndr\createTextureFromSurface image


-- Get the size of the logo
-- f, a, w, h = graphics.rawr\query()

-- pos.x = width / 2 - w / 2
-- pos.y = height / 2 - h / 2
-- pos.w = 64
-- pos.h = 64

while true
  for e in sdl.pollEvent!
    if e.type == sdl.event.quit
      running = false

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
