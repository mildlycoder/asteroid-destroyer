local love = require "love"

function love.conf(t)
  t.console = false
  t.externalstorage = true
  t.gammacorrect = true
  t.audio.mic = true
  t.window.title = "Asteroid Destroyer"
  t.window.display = 2
end
