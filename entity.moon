image = require 'SDL.image'

--
-- A generic entity that represents either the player or
-- an enemy in the game.
class Entity
  new: (filename, renderer, data) =>
    img = image.load filename
    @renderer = renderer
    @texture = @renderer\createTextureFromSurface img
    @data = data
    
  move: (x) =>
    @data.x -= x
    return @data.x < 0

  render: => @renderer\copy @texture, nil, @data


-- Return everything we declared here today
-- return { :Entity, :Player }