local love = require("love")

function Asteroid(x, y, astSize, level)
	local ASTEROID_VERT = 10
	local JAGGED = 0.4
	local SPEED = math.random(50) + (level * 10)
	local vel = (math.random() < 0.5 and 1 or -1)

	local offset = {}
	local vert = math.floor(ASTEROID_VERT + math.random() * (ASTEROID_VERT / 2))
	for i = 1, vert do
		table.insert(offset, 1 + (math.random() * 2 - 1) * JAGGED)
	end

	return {
		x = x,
		y = y,
		x_velocity = math.random() * SPEED * vel,
		y_velocity = math.random() * SPEED * vel,
		radius = math.ceil(astSize / 2),
		vert = vert,
		offset = offset,
		angle = math.random() * 2 * math.pi,

		draw = function(self, faded)
			local opacity = faded and 0.2 or 1
			love.graphics.setColor(1, 1, 1, opacity)

			local points = {}
			for i = 1, self.vert do
				local angleStep = self.angle + (i - 1) * 2 * math.pi / self.vert
				table.insert(points, self.x + self.radius * self.offset[i] * math.cos(angleStep))
				table.insert(points, self.y + self.radius * self.offset[i] * math.sin(angleStep))
			end

			love.graphics.polygon("line", points)

			if show_debugging then
				love.graphics.setColor(1, 0, 0)
				love.graphics.circle("line", self.x, self.y, self.radius)
			end
		end,

		move = function(self, dt)
			self.x = self.x + self.x_velocity * dt
			self.y = self.y + self.y_velocity * dt

			if self.x + self.radius < 0 then
				self.x = love.graphics.getWidth() + self.radius
			elseif self.x - self.radius > love.graphics.getWidth() then
				self.x = 0 + self.radius
			elseif self.y + self.radius < 0 then
				self.y = love.graphics.getHeight() + self.radius
			elseif self.y - self.radius > love.graphics.getHeight() then
				self.y = 0
			end
		end,

		breakAsteroid = function(self)
			if self.radius > 20 then
				local newRadius = self.radius / 2
				for i = 1, 2 do
					local newAsteroid = Asteroid(self.x, self.y, newRadius * 2, game.level)
					table.insert(game.asteroids, newAsteroid)
				end
			end
		end,
	}
end

return Asteroid
