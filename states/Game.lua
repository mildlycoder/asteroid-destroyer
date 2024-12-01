local Text = require("../components/Text")
local Asteroid = require("../objects/Asteroid")
local love = require("love")

function Game()
  -- Points required to clear each level
  local levels = {40, 80, 160, 360}

  return {
    asteroids = {},
    state = {
      menu = false,
      paused = false,
      running = true,
      ended = false,
    },
    points = 0,
    level = 1,

    changeGameState = function(self, state)
      self.state.menu = state == "menu"
      self.state.paused = state == "paused"
      self.state.running = state == "running"
      self.state.ended = state == "ended"
    end,

    draw = function(self, faded)
      if faded then
        local pausedText = Text(
          "PAUSED",
          0,
          love.graphics.getHeight() * 0.4,
          "h1",
          1,
          false,
          false,
          love.graphics.getWidth(),
          "center"
        )
        pausedText:draw()
      end

      local pointsText = Text(
        "Points " .. self.points,
        0,
        20,
        "h3",
        1,
        false,
        false,
        love.graphics.getWidth(),
        "center"
      )
      pointsText:draw()

      local levelText = Text(
        "Level " .. self.level,
        0,
        50,
        "h3",
        1,
        false,
        false,
        love.graphics.getWidth(),
        "center"
      )
      levelText:draw()
    end,

    startGame = function(self)
      self:changeGameState("running")
      self:spawnAsteroid()
    end,

    increasePoints = function(self, increment)
      self.points = self.points + increment
      if self.level <= #levels and self.points >= levels[self.level] then
        self.level = self.level + 1
        self:spawnAsteroid()
      end
    end,

    spawnAsteroid = function(self)
      local asteroid = Asteroid(
        math.random(0, love.graphics.getWidth()),
        math.random(0, love.graphics.getHeight()),
        100,
        self.level
      )
      table.insert(self.asteroids, asteroid)
    end,
  }
end

return Game
