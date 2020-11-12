local Lighter = require 'lighter'
local vector    = require 'libs.vector-light'

love.window.setMode(800, 600, {resizable=true})

local lighter = Lighter()
lighter:addLight(300, 400, 400)
lighter:addLight(900, 700, 200)

local function getTestPolygons()
  local testPolygon = {
    100, 100,
    300, 100,
    300, 300,
    100, 300,
    100, 100
  }

  local testPolygon2 = {
    500, 500,
    850, 500,
    850, 850,
    800, 850,
    500, 500
  }

  return testPolygon, testPolygon2
end

local polygon1, polygon2 = getTestPolygons()
local polygons = { polygon1, polygon2 }

for _, polygon in ipairs(polygons) do
  lighter:addPolygon(polygon)
end

function love.update(dt)
end

function love.draw()
  love.graphics.setColor(0.6, 0.5, 0.4)
  for _, polygon in ipairs(polygons) do
    love.graphics.polygon('fill', polygon)
  end
  love.graphics.setColor(1,1,1)
  lighter:drawLights()
end
