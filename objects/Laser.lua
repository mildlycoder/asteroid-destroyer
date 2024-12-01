local love = require("love")

function Laser(x, y, angle)
	local LASER_SPEED = 500
	return {
		x = x,
		y = y,
		exploded = false,
		explodeTime = 0.2,
		distance = 0,
		x_vel = LASER_SPEED * math.cos(angle - math.pi / 2) / love.timer.getFPS(),
		y_vel = LASER_SPEED * math.sin(angle - math.pi / 2) / love.timer.getFPS(),
		draw = function(self, faded)
			local opacity = 1

			if faded then
				opacity = 0.2
			end
			if self.exploded then
				love.graphics.setColor(1, 104/255, 0)
				love.graphics.circle("fill", self.x, self.y, 10)
				love.graphics.setColor(1, 235/255, 0)
				love.graphics.circle("fill", self.x, self.y, 5)
			else
				love.graphics.setColor(1, 1, 1, opacity)
				love.graphics.setPointSize(3)
				love.graphics.points(self.x, self.y)
			end
		end,
		move = function(self)
			if not self.exploded then
				self.x = self.x + self.x_vel
				self.y = self.y + self.y_vel
			end

			if self.x < 0 then
				self.x = love.graphics.getWidth()
			elseif self.x > love.graphics.getWidth() then
				self.x = 0
			elseif self.y < 0 then
				self.y = love.graphics.getHeight()
			elseif self.y > love.graphics.getHeight() then
				self.y = 0
			end

			self.distance = self.distance + math.sqrt((self.x_vel ^ 2) + (self.y_vel ^ 2))

			if self.exploded then
				self.explodeTime = self.explodeTime - love.timer.getDelta()
				if self.explodeTime <= 0 then
					self.exploded = false
					self.explodeTime = 0.2
				end
			end
		end,
		explode = function(self)
			if not self.exploded then
				self.exploded = true
			end
		end,
	}
end

return Laser
