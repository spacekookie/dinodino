Entity = require 'entity'
Player = require 'player'

-- Simple class that handles the rolling ground in the level
--
class Ground
  new: (renderer, gnd_img, w, h) =>
    @renderer = renderer

    @pos = 0
    @width = w
    @height = h

    -- The ground first displayed
    @p_data = { x:@pos, y:0, w:@width, h:@height }
    @primary = Entity gnd_img, @renderer, p_data

    -- The ground that scrolls in later
    @s_data = { x:@pos + @width, y:0, w:@width, h:@height }
    @secondary = Entity gnd_img, @renderer, s_data

  move: (offset) =>

    -- Move both grounds to the left
    @p_data.x -= offset
    @s_data.x -= offset

    -- Check if we have to jump positions
    if @p_data.x <= -@width then @p_data.x = @width
    if @s_data.x <= -@width then @s_data.x = @width

    @primary.data = @p_data
    @secondary.data = @s_data

  render: =>
    @primary\render!
    @secondary\render!


-- A class that represents the game world
--   Handles things like spawning new enemies
--   moving the player along and generally
--   calling update on all objects
--
class GameWorld
  new: (renderer, gnd_img, w, h) =>
    print "Creating new GameWorld"
    @renderer = renderer
    @width = w
    @height = h
    @speed = 0.5

    -- A list of entities to render
    @entities = {}
    @toremove_e = {}

    -- A list of critters to render (no collision)
    @critters = {}
    @toremove_c = {}
    
    @ground = Ground @renderer, gnd_img, @width, @height
    @started = false

  -- Starts a new game and puts a player at the start location
  start: (name) =>
    @player = Player name, @renderer, { x:150, y:(@height/2)+64, w:64, h:64 }
    -- table.insert @entities, Entity name, @renderer, data
    @started = true

  -- Spawns a new enemy at location x, y
  spawn_entity: (name, hx) =>
    data = { x:@width+64, y:(@height/2)+64*-(hx-2), w:64, h:64 }
    table.insert @entities, Entity name, @renderer, data
    
  -- Create a fluffy new cloud
  spawn_critter: (name, height) =>
    data = {x:@width+64, y:(@height/2)+64-height, w:115, h:65}
    table.insert @critters, Entity name, @renderer, data

  -- Updates the game world
  update: (jump, difficulty) =>

    -- Ignore everything if we haven't officially started yet
    return if not @started

    -- Adjust the speed for this frame
    speed = @speed * (1 / difficulty)

    -- Move the ground
    @ground\move speed

    -- Initialise a player jump if we got the signal
    @player\jump! if jump

    --  render ground
    @ground\render!

    -- Draw all other entities
    for e in *@entities
      e\move speed
      e\render!

    -- Draw all critters (don't have collision checks)
    for e in *@critters
      e\move speed
      e\render!

    -- Draw the player seperately
    @player\update!
    @player\render!

    -- Remove entities that are no longer in view
    for i=#@entities, 1, -1
      if @entities[i].data.x > -@entities[i].data.w
        continue
      table.remove @entities, i

    -- Remove critters the same way
    for i=#@critters, 1, -1
      if @critters[i].data.x > -@critters[i].data.w
        continue
      table.remove @critters, i

    @toremove_e = {}
    @toremove_c = {}

  -- Checks for collisions between player and other entities
  --   returns boolean depending on if it finds any
  find_collision: =>

    -- Adds a bit of tolerance to make the game easier (more fun)
    tol = 6

    px = @player.data.x
    py = @player.data.y
    pw = @player.data.w
    ph = @player.data.h

    for e in *@entities
      ex = e.data.x
      ey = e.data.y
      ew = e.data.w
      eh = e.data.h

      -- There are 4 collision cases we need to cover
      if px-tol >= ex and px+tol <= ex+ew and py-tol >= ey and py+tol <= ey+eh
        return true
      if px+pw-tol >= ex and px+pw+tol <= ex+ew and py-tol >= ey and py+tol <= ey+eh
        return true
      if px-tol >= ex and px+tol <= ex+ew and py+ph-tol >= ey and py+ph+tol <= ey+ph
        return true
      if px+pw-tol >= ex and px+pw+tol <= ex+ew and py+ph-tol >= ey and py+ph+tol <= ey+ph
        return true

    -- The player didn't fuck up :)
    return false
