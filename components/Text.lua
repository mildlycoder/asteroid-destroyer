local love = require("love")

function Text(text, x, y, fontSize, opacity, fadeIn, fadeOut, wrapWidth, align)
  fontSize = fontSize or "p"
  opacity = opacity or 1
  fadeIn = fadeIn or false
  fadeOut = fadeOut or false
  wrapWidth = wrapWidth or love.graphics.width()
  align = align or "center"

  local FADE_DUR = 3
  local fonts = {
    h1 = love.graphics.newFont(60),
    h2 = love.graphics.newFont(30),
    h3 = love.graphics.newFont(15),
    p = love.graphics.newFont(10),
  }

  function ifFadeIn()
    opacity = 0.1
  end

  return {
    text = text,
    x = x,
    y = y,
    opacity = opacity,
    draw = function(self, tbl_text, index)
      if fadeIn then
        if self.opacity < 1 then
          self.opacity = self.opacity + (1 / FADE_DUR / love.timer.getFPS())
        end
      elseif fadeOut then
        self.opacity = self.opacity - (1 / FADE_DUR / love.timer.getFPS())
      end
      if self.opacity > 0 then
        love.graphics.setColor(1, 1, 1, self.opacity)
        love.graphics.setFont(fonts[fontSize])
        love.graphics.printf(self.text, self.x, self.y, wrapWidth, align)
      else
        table.remove(tbl_text, index)
      end
    end,
  }
end

return Text
