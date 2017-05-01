Entity = require 'entity'


-- A specific entity that represents a player
-- Has special functions to handle jumping
class Player extends Entity

  -- Special player constructor
  new: (filename, renderer, data) =>
    super(filename, renderer, data)

    -- Do we move, how fast and in what direction?
    @velocidy = -1
    @slowdown = 0.005
    @jumping = false

    -- Where do we start and where do we end?
    @basepoint = data.y
    @turnpoint = data.y - 128

  -- Starts jumping the player entity
  jump: => 
    print "Player is now jumping"
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
      @velocidy = -1
      @data.y = @basepoint
      @jumping = false
