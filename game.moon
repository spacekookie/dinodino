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
    @speed = 0.35

    -- A list of entities to render
    @entities = {}
    @ground = Ground @renderer, gnd_img, @width, @height
    @started = false

  -- Starts a new game and puts a player at the start location
  start: (name) =>
    @player = Player name, @renderer, { x:50, y:(@height/2)+64, w:64, h:64 }
    -- table.insert @entities, Entity name, @renderer, data
    @started = true

  -- Spawns a new enemy at location x, y
  spawn_new: (name, x, y) => 
    
  -- Updates the game world
  update: =>

    -- Ignore everything if we haven't officially started yet
    return if not @started

    -- Move the ground
    @ground\move @speed

    if not @player.jumping
      @player\jump!

    -- Clear screen and render ground
    @renderer\clear!
    @ground\render!

    -- Draw the player specifically
    @player\update!
    @player\render!

    -- Draw all other entities
    for e in *@entities
      e\render!

    -- SHOW ME WHAT YOU GOT!
    @renderer\present!

  -- Checks for collisions between player and other entities
  --   returns boolean depending on if it finds any
  find_collision: =>
    p_data = @player.data
