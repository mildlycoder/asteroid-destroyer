local Text = require "../components/Text"
local Asteroid = require "../objects/Asteroid"
local love = require("love")

function Game()
  return {
    asteroids = {},
    state = {
      memu = false,
      paused = false,
      running = true,
      ended = false,
    },
    level = 10,
    changeGameState = function(self, state)
      self.state.memu = state == "memu"
      self.state.paused = state == "paused"
      self.state.running = state == "running"
      self.state.ended = state == "ended"
    end,
    draw = function(self, faded)
      if faded then
        Text(
          "PAUSED",
          0,
          love.graphics.getHeight() * 0.4,
          "h1",
          1,
          false,
          true,
          love.graphics.getWidth(),
          "center"
        ):draw()
      end
    end,

    startGame = function(self, player, debugging)
      self:changeGameState("running")
      local x_ast = math.random(love.graphics.getWidth())
      local y_ast = math.random(love.graphics.getHeight())
      table.insert(self.asteroids,1, Asteroid(math.random(love.graphics.getWidth()), math.random(love.graphics.getHeight()), 100, self.level))
    end
  }
end

return Game
