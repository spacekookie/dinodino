--------------------
--
-- Main game file
--

require 'luarocks.loader'
sdl = require 'SDL'
image = require 'SDL.image'
socket = require "socket"

-- Other requires for this game
World = require 'game'

-- Initialises the SDL context
initialise = (w, h) ->
  stuff = {}
  sdl.init sdl.flags.Video, sdl.flags.Audio, sdl.flags.OpenGL

  stuff.win = sdl.createWindow title:"Dino Dino", width:w, height:h
  stuff.rndr = sdl.createRenderer stuff.win, -1
  stuff.rndr\setDrawColor 0xAAAAAA
  return stuff

-- Utility function get gets current time in milliseconds
curr_millis = -> socket.gettime!

-------------------------------------------------------------

-- Variables and stuff
running = true
width = 1280
height = 720

-- We will measure times between frames
delta = 0.001

-- With time the speed and time between spawns will change
difficulty = 1

-- Define file paths for entities
tree = 'assets/wood.png'
player = 'assets/rawr.png'
ground = 'assets/dirtyearth.png'
bird = 'assets/birdistheword.png'

-- Initialise the SDL graphics objects
graphics = initialise width, height

-- Initialise a new game world
world = World graphics.rndr, ground, width, height
world\start player

-- Setup random seed for spawns
math.randomseed os.time!
spawn = math.random 1, 3.75
print "First spawn in " .. spawn

while running
  jump = false
  start = curr_millis!

  -- Check for input signals
  for e in sdl.pollEvent!
    if e.type == sdl.event.quit
      running = false
    elseif e.type == sdl.event.KeyDown

      -- Check if user pressed SPACE
      jump = true if e.keysym.sym == 32

  -- Spawn new things into the world
  spawn -= delta
  if spawn <= 0
    world\spawn_new tree
    spawn = math.random 2, 3.5
    spawn *= difficulty
    print "Next spawn in " .. spawn

  -- Then update the currently running world
  world\update jump, difficulty

  -- Calculate delta time
  delta = curr_millis! - start

  -- Increase the difficulty slooooowly
  difficulty -= 0.000005

-- Clean up our shit
sdl.quit
image.quit
