_G.love = require("love")
Player = require("objects/Player")
Text = require("components/Text")
Game = require("states/Game")
require("Globals")

math.randomseed(os.time())

function love.load()
	love.mouse.setVisible(false)
	_G.mouse_x, _G.mouse_y = 0, 0

	_G.player = Player()
	_G.game = Game()
	game:startGame(player, true)
end

function love.keypressed(key)
	if game.state.running then
		if key == "up" or key == "w" then
			player.thrusting = true
		end

		if key == "space" then
			player:shootLasers()
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
		for i = #game.asteroids, 1, -1 do
			local asteroid = game.asteroids[i]
			asteroid:move(dt)

			for j = #player.lasers, 1, -1 do
				local laser = player.lasers[j]
				if
					calculateDistance(laser.x, laser.y, asteroid.x, asteroid.y) <= asteroid.radius
					and not laser.exploding
				then
					laser:explode()
					game:increasePoints(10)
					asteroid:breakAsteroid(game)
					table.remove(game.asteroids, i)
					break
				end
			end
		end
		for _, laser in pairs(player.lasers) do
			laser:move()
		end
	end
end

function love.draw()
	player:draw(game.state.paused)
	Text("Points " .. game.points, 0, 20, "h3", 1, false, true, love.graphics.getWidth(), "center"):draw()
	for _, asteroid in pairs(game.asteroids) do
		asteroid:draw(game.state.paused)
	end
	if game.state.paused then
		game:draw(game.state.paused)
	end
end
