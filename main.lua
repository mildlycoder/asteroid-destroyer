_G.love = require("love")
Player = require("objects/Player")
Game = require("states/Game")

math.randomseed(os.time())

function love.load()
  love.mouse.setVisible(false)
  _G.mouse_x, _G.mouse_y = 0, 0

  local debugging = true
  _G.player = Player(debugging)
  _G.game = Game()
  game:startGame(player, true)
end

function love.keypressed(key)
  if game.state.running then
    if key == "up" or key == "w" then
      player.thrusting = true
    end
  end
end

function love.keyreleased(key)
  if game.state.running then
    if key == "up" or key == "w" then
      player.thrusting = false
    end

    if key == "escape" then
      game:changeGameState("paused")
    end
  elseif game.state.paused then
    if key == "escape" then
      game:changeGameState("running")
    end
  end
end

function love.update(dt)
  mouse_x, mouse_y = love.mouse.getPosition()

  if game.state.running then
    player:movePlayer()
    for _, asteroid in pairs(game.asteroids) do
      asteroid:move(dt)
    end
  end
end

function love.draw()
  player:draw(game.state.paused)
  for _, asteroid in pairs(game.asteroids) do
    asteroid:draw(game.state.paused)
  end
  if game.state.paused then
    game:draw(game.state.paused)
  end
end
