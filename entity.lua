local image = require('SDL.image')
local Entity
do
  local _class_0
  local _base_0 = {
    render = function(self)
      return self.renderer:copy(self.texture, nil, self.data)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, filename, renderer, data)
      image = image.load(filename)
      self.renderer = renderer
      self.texture = self.renderer:createTextureFromSurface(image)
      self.data = data
    end,
    __base = _base_0,
    __name = "Entity"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Entity = _class_0
  return _class_0
end
