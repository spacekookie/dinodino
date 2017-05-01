Entity = require 'entity'

-- Define up here because...something
JUMP_FORCE = -1.25

-- A specific entity that represents a player
-- Has special functions to handle jumping
class Player extends Entity

  -- Special player constructor
  new: (filename, renderer, data) =>
    super(filename, renderer, data)

    -- Do we move, how fast and in what direction?
    @velocidy = JUMP_FORCE
    @slowdown = 0.006
    @jumping = false

    -- Where do we start and where do we end?
    @basepoint = data.y
    @turnpoint = data.y - 128

  -- Starts jumping the player entity
  jump: => 
    return if @jumping

    @speed = -@velocidy
    @jumping = true

  -- Special update function for the player
  update: =>
    return if not @jumping

    -- Apply velocidy
    @data.y += @velocidy

    -- Slow down our velocitx
    @velocidy += @slowdown

    -- Reset position when the jump is complete
    if @data.y > @basepoint
      @velocidy = JUMP_FORCE
      @data.y = @basepoint
      @jumping = false
