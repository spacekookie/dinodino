Entity = require 'entity'


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

    -- A list of entities to render
    @entities = {}
    @ground = Ground @renderer, gnd_img, @width, @height
    @started = false

  -- Starts a new game and puts a player at the start location
  start: => 
    @entites.insert Entity name, @renderer, { x:x, y:y, w:64, h:64 }
    @started = true

  -- Spawns a new enemy at location x, y
  spawn_new: (name, x, y) => 
    
  -- Updates the game world
  update: =>
    @ground\move 15

    @renderer\clear!
    @ground\render!

    -- Draw all other entities
    -- for e in @entites
    --   print e

    @renderer\present!