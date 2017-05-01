--------------------
--
-- Main game file
--

require 'luarocks.loader'
ffi = require 'ffi'
sdl = require 'SDL'
ttf = require 'SDL.ttf' 
image = require 'SDL.image'
socket = require 'socket'

-- Other requires for this game
World = require 'game'

-- Initialises the SDL context
initialise = (w, h) ->
  stuff = {}
  sdl.init sdl.flags.Video, sdl.flags.Audio, sdl.flags.OpenGL

  stuff.win = sdl.createWindow title:"Dino Dino", width:w, height:h
  stuff.rndr = sdl.createRenderer stuff.win, -1
  stuff.rndr\setDrawColor 0xAAAAAA

  ttf.init!
  stuff.font, err = ttf.open "DejaVuSans.ttf", 12
  if not stuff.font
    print "AN ERROR OCCURED OPENING THE FONT #{error err}"

  return stuff

ffi.cdef[[
  typedef long time_t;
  typedef int clockid_t;

  struct typespec {
    time_t    tv_sec;   /* Seconds */
    long      tv_nsec;  /* nanoseconds */
  };

  int clock_gettime(clockid_t clk_id, struct timespec *tp);
]]

-- A function that returns the size for a font and string
get_font_size = (font, text) ->
  w, h = font\sizeText text
  { x:0, y:0, w:w*2, h:h*2 }

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
score = 0

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
  start = socket.gettime!

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
    id = math.random #spawnee
    world\spawn_entity spawnee[id], id

    -- Calculate the next spawn time
    spawn = math.random 1.5, 3.5
    spawn *= difficulty

  -- We also want to spawn clouds at varying height levels
  cloud_spawn -= delta
  if cloud_spawn <= 0
    world\spawn_critter cloud, math.random 150, 450
    cloud_spawn = math.random 0.5, 1

  -- Clear the screen
  graphics.rndr\clear!

  -- Then update the currently running world
  world\update jump, difficulty

  -- Draw the highscore font
  score = math.floor survival_time*100
  score_text = "Score: #{score}"
  s = graphics.font\renderUtf8 score_text , "solid", 0
  text = graphics.rndr\createTextureFromSurface s
  graphics.rndr\copy text, nil, get_font_size graphics.font, score_text

  -- SHOW ME WHAT YOU GOT!
  graphics.rndr\present!

  -- Check if the player fucked up
  running = false if world\find_collision!

  -- Calculate delta time
  delta = socket.gettime! - start

  -- Increase the difficulty slooooowly
  difficulty -= 0.000005
  survival_time += delta


-- We only reach this point if the game ended (player failed or quit)
print "Your score was #{score}. Good job! :)"

-- Clean up our shit
sdl.quit!
image.quit!
