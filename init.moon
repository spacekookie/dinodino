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
survival_time = 0

-- God these puns are so shitty :/
tree = 'assets/wood.png'
player = 'assets/rawr.png'
cloud = 'assets/serverless.png'
ground = 'assets/dirtyearth.png'
bird = 'assets/birdistheword.png'

-- Make a list we can easily select something to spawn from
spawnee = { tree, bird }

-- Initialise the SDL graphics objects
graphics = initialise width, height

-- Initialise a new game world
world = World graphics.rndr, ground, width, height
world\start player

-- Setup random seed for spawns
math.randomseed os.time!
spawn = math.random 1, 3.75
print "First spawn in " .. spawn

-- Spawn clouds randomly too (more frequently though)
cloud_spawn = math.random 0.5, 1


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

    -- Spawn something random and cool :)
    id = math.random 2
    world\spawn_entity spawnee[id], id

    -- Calculate the next spawn time
    spawn = math.random 1.5, 3.5
    spawn *= difficulty

  -- We also want to spawn clouds at varying height levels
  cloud_spawn -= delta
  if cloud_spawn <= 0
    world\spawn_critter cloud, math.random 150, 450
    cloud_spawn = math.random 0.5, 1

  -- Then update the currently running world
  world\update jump, difficulty

  -- Check if the player fucked up
  running = false if world\find_collision!

  -- Calculate delta time
  delta = curr_millis! - start

  -- Increase the difficulty slooooowly
  difficulty -= 0.000005
  survival_time += delta


-- We only reach this point if the game ended (player failed or quit)
print "You survived #{math.floor survival_time} seconds"

-- Clean up our shit
sdl.quit
image.quit
