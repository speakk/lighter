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

  local allCombined = {testPolygon, testPolygon2, surroundPolygon}

  --for _, coordinate in ipairs(testPolygon) do
  --  table.insert(allCombined, coordinate)
  --end
  --for _, coordinate in ipairs(testPolygon2) do
  --  table.insert(allCombined, coordinate)
  --end
  --for _, coordinate in ipairs(surroundPolygon) do
  --  table.insert(allCombined, coordinate)
  --end

  return testPolygon, testPolygon2, surroundPolygon, allCombined
end

local polygon1, polygon2, surroundPolygon, allCombined = getTestPolygons()
local polygons = { polygon1, polygon2 }

local rayOriginX, rayOriginY = 0, 0

local testOriginX, testOriginY = 350, 400

--function love.mousemoved(x, y)
--  rayOriginX = x
--  rayOriginY = y
--end

local visibilityPolygon = {}
--local startX, startY, endX, endY

function love.update(dt)
  local radius = 2000
  -- startX = testOriginX
  -- startY = testOriginY
  -- endX, endY = love.mouse.getPosition()
  -- local dirX, dirY = vector.normalize(vector.sub(endX, endY, startX, startY))
  -- endX, endY = vector.add(startX, startY, vector.mul(radius, dirX, dirY))

  local x, y = love.mouse.getPosition()
  visibilityPolygon = illuaminate.calculateVisibilityPolygon(x, y, radius, allCombined)
end

function love.draw()
  for _, polygon in ipairs(polygons) do
    love.graphics.polygon('fill', polygon)
  end

  love.graphics.polygon('line', surroundPolygon)

  --love.graphics.line(startX, startY, endX, endY)
  local x, y = love.mouse.getPosition()

  for _, point in ipairs(visibilityPolygon) do
    love.graphics.line(x, y, point.x, point.y)

    love.graphics.setColor(0,1,0)
    love.graphics.circle('fill', point.x, point.y, 4)
    love.graphics.setColor(1,1,1)
  end

  love.graphics.setColor(0.6, 0.1, 0.3, 1)

  for i=1,#visibilityPolygon-1 do
    local point1 = visibilityPolygon[i]
    local point2 = visibilityPolygon[i+1]
    love.graphics.polygon('fill', {
      x, y,
      point1.x, point1.y,
      point2.x, point2.y
    })
  end

  local firstPoint = visibilityPolygon[1]
  local lastPoint = visibilityPolygon[#visibilityPolygon]
  love.graphics.polygon('fill', {
    x, y,
    lastPoint.x, lastPoint.y,
    firstPoint.x, firstPoint.y
  })

  love.graphics.setColor(1,1,1)

  love.graphics.circle('fill', rayOriginX, rayOriginY, 10)
  love.graphics.circle('fill', testOriginX, testOriginY, 5)
end
