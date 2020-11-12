local illuaminate = require 'illuaminate'
local vector    = require 'libs.vector-light'

love.window.setMode(800, 600, {resizable=true})

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

  local surroundPolygon = {
    0, 0,
    1000, 0,
    1000, 1000,
    0, 1000,
    0, 0
  }

  local allCombined = {}

  for _, coordinate in ipairs(testPolygon) do
    table.insert(allCombined, coordinate)
  end
  for _, coordinate in ipairs(testPolygon2) do
    table.insert(allCombined, coordinate)
  end
  for _, coordinate in ipairs(surroundPolygon) do
    table.insert(allCombined, coordinate)
  end

  return testPolygon, testPolygon2, surroundPolygon, allCombined
end

local polygon1, polygon2, surroundPolygon, allPoints = getTestPolygons()
local polygons = { polygon1, polygon2 }

local rayOriginX, rayOriginY = 0, 0

local testOriginX, testOriginY = 350, 400

--function love.mousemoved(x, y)
--  rayOriginX = x
--  rayOriginY = y
--end

local visibilityPolygon = {}
--local startX, startY, endX, endY

local testOrigin

function love.update(dt)
  -- local radius = 300
  -- startX = testOriginX
  -- startY = testOriginY
  -- endX, endY = love.mouse.getPosition()
  -- local dirX, dirY = vector.normalize(vector.sub(endX, endY, startX, startY))
  -- endX, endY = vector.add(startX, startY, vector.mul(radius, dirX, dirY))

  local x, y = love.mouse.getPosition()
  visibilityPolygon = illuaminate.calculateVisibilityPolygon(x, y, 300, allPoints)
end

function love.draw()
  for _, polygon in ipairs(polygons) do
    love.graphics.polygon('fill', polygon)
  end

  love.graphics.polygon('line', surroundPolygon)

  --love.graphics.line(startX, startY, endX, endY)

  for _, point in ipairs(visibilityPolygon) do
    local x, y = love.mouse.getPosition()
    love.graphics.line(x, y, point.x, point.y)
  end

  love.graphics.circle('fill', rayOriginX, rayOriginY, 10)
  love.graphics.circle('fill', testOriginX, testOriginY, 5)
end
