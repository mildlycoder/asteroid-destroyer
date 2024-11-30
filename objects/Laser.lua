local love = require "love"

function Laser(x, y, angle)
  return {
    x = x,
    y = y,

    draw = function (self, faded)
      local opacity = 1

      if faded then
        opacity = 0.2
      end

      love
    end
  }
end

return Laser
