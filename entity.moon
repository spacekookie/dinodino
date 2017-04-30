image = require 'SDL.image'

--
-- A generic entity that represents either the player or
-- an enemy in the game.
class Entity
  new: (filename, renderer, data) =>
    image = image.load filename
    @renderer = renderer
    @texture = @renderer\createTextureFromSurface image
    @data = data
  render: => @renderer\copy @texture, nil, @data
