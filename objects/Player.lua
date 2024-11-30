local love = require("love")
Laser = require("objects.Laser")
function Player(debugging)
  local SHIP_SIZE = 30
  local VIEW_ANGLE = math.rad(0)
  local MAX_LASER_DISTANCE = 0.6
  local MAX_LASER = 10

  return {
    x = love.graphics.getWidth() / 2,
    y = love.graphics.getHeight() / 2,
    radius = SHIP_SIZE / 2,
    rotation = 0,
    opacity = 1,
    angle = VIEW_ANGLE,
    thrust = {
      x = 0,
      y = 0,
      speed = 0.2,
      max = 5,
    },
    lasers = {},
    shootLasers = function(self)
      if #self.lasers <= MAX_LASER then
        table.insert(self.lasers, Laser(self.x, self.y, self.angle))
      end
    end,
    destroyLaser = function(self, index)
      table.remove(self.lasers, index)
    end,

    draw = function(self, faded)
      if faded then
        self.opacity = 0.2
      else
        self.opacity = 1
      end
      if show_debugging then
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", self.x - 1, self.y - 1, 2, 2)
        love.graphics.circle("line", self.x, self.y, self.radius)
      end
      love.graphics.push()
      love.graphics.translate(self.x, self.y)
      love.graphics.rotate(self.angle)
      love.graphics.setColor(1, 1, 1, self.opacity)
      local vertices = {
        0,
        -self.radius,
        -self.radius * 0.5,
        self.radius * 0.5,
        self.radius * 0.5,
        self.radius * 0.5,
      }
      love.graphics.polygon("fill", vertices)

      -- Add flame when thrusting
      if self.thrusting then
        love.graphics.setColor(1, 0.5, 0) -- Orange color
        local flameVertices = {
          0,
          self.radius * 0.5,
          -self.radius * 0.25,
          self.radius,
          self.radius * 0.25,
          self.radius,
        }
        love.graphics.polygon("fill", flameVertices)
      end
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.pop()

      for _, laser in pairs(self.lasers) do
        laser:draw(faded)
      end
    end,
    movePlayer = function(self)
      local friction = 0.95
      if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        self.angle = self.angle - math.rad(3)
      end
      if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        self.angle = self.angle + math.rad(3)
      end
      if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        self.thrust.x = math.max(
          math.min(self.thrust.x + self.thrust.speed * math.sin(self.angle), self.thrust.max),
          -self.thrust.max
        )
        self.thrust.y = math.max(
          math.min(self.thrust.y - self.thrust.speed * math.cos(self.angle), self.thrust.max),
          -self.thrust.max
        )
      end
      self.thrust.x = self.thrust.x * friction
      self.thrust.y = self.thrust.y * friction
      if math.abs(self.thrust.x) < 0.01 then
        self.thrust.x = 0
      end
      if math.abs(self.thrust.y) < 0.01 then
        self.thrust.y = 0
      end
      self.x = self.x + self.thrust.x
      self.y = self.y + self.thrust.y

      if self.x + self.radius < 0 then
        self.x = love.graphics.getWidth() + self.radius
      elseif self.x - self.radius > love.graphics.getWidth() then
        self.x = 0 + self.radius
      elseif self.y + self.radius < 0 then
        self.y = love.graphics.getHeight() + self.radius
      elseif self.y - self.radius > love.graphics.getHeight() then
        self.y = 0
      end

      for index, laser in pairs(self.lasers) do
        laser:move()
        if laser.distance > MAX_LASER_DISTANCE * love.graphics.getWidth() then
          self.destroyLaser(self, index)
        end
      end
    end,
  }
end

return Player
