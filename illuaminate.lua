local vector = require 'libs.vector-light'

-- https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect


local angleSortFunc = function(a, b)
  return a.angle < b.angle
end

local function getLineIntersectionPoint(Ax1, Ay1, Ax2, Ay2, Bx1, By1, Bx2, By2)
  local intersectX, intersectY
  local s1x, s1y = vector.sub(Ax2, Ay2, Ax1, Ay1)
  local s2x, s2y = vector.sub(Bx2, By2, Bx1, By1)

  local b = (-s2x * s1y + s1x * s2y)
  local s = ( -s1y * (Ax1 - Bx1) + s1x * (Ay1 - By1)) / b
  local t = ( s2x * (Ay1 - By1) - s2y * (Ax1 - Bx1)) / b

  -- There was an intersection
  if s >= 0 and s <= 1 and t >= 0 and t <= 1 then
    intersectX = Ax1 + (t * s1x)
    intersectY = Ay1 + (t * s1y)
  end

  return intersectX, intersectY
end

local function intersection(Ax1, Ay1, Ax2, Ay2, Bx1, By1, Bx2, By2)
  local d = (Ax1 - Ax2) * (By1 - By2) - (Ay1 - Ay2) * (Bx1 - Bx2)
  local a = Ax1 * Ay2 - Ay1 * Ax2
  local b = Bx1 * By2 - By1 * Bx2
  local x = (a * (Bx1 - Bx2) - (Ax1 - Ax2) * b) / d
  local y = (a * (By1 - By2) - (Ay1 - Ay2) * b) / d
  return x, y
end

local function calculateVisibilityPolygon(originX, originY, radius, polygons)
  local visibilityPolygon = {}

  for _, polygon in ipairs(polygons) do
    -- Go through all points (x,y)
    for i=1,#polygon-2,2 do
      local x = polygon[i]
      local y = polygon[i+1]
      local a1, a2 = vector.sub(x, y, originX, originY)
      local angleA = math.atan2(a2, a1)
      local angleB = angleA + 0.0001
      local angleC = angleA - 0.0001

      -- Go through all 3 angles as rays cast from originX, originY
      for j=1,3 do
        local angle
        if j == 1 then angle = angleA end
        if j == 2 then angle = angleB end
        if j == 3 then angle = angleC end


        -- The ray we cast is originX, originY, rayX2, rayY2
        -- rayX2, rayY2 are origin + angle*radius
        local dirX, dirY = math.cos(angle), math.sin(angle)
        local rayX2, rayY2 = vector.add(originX, originY, vector.mul(radius, vector.normalize(dirX, dirY)))

        -- Next up we find the shortest intersection point for each ray.
        -- We store the shortest so far in the min* variables defined below
        local minX, minY, minAngle
        local minLength = math.huge
        local found = false

        -- Go through all the points as line segments (x1,y1,x2,y2).
        -- See where the ray intersects (if it does at all) with the line
        -- segment. If it does, check if it's the shortest length from
        -- origin so far. If it is, then that's the point we want to store
        -- in visibilityPolygon
        for _, polygon2 in ipairs(polygons) do
          for u=1,#polygon2-2,2 do
            local segmentX1 = polygon2[u]
            local segmentY1 = polygon2[u+1]
            local segmentX2 = polygon2[u+2]
            local segmentY2 = polygon2[u+3]

            --print("Checking", originX, originY, rayX2, rayY2, segmentX1, segmentY1, segmentX2, segmentY2)

            -- Now check for actual intersection between
            -- the ray cast from the origin point and the line segment.
            local intersectX, intersectY = getLineIntersectionPoint(
            originX, originY, rayX2, rayY2,
            segmentX1, segmentY1, segmentX2, segmentY2
            )
            
            if intersectX and intersectY then
              -- TODO: Not sure about this
              local length = vector.len2(vector.sub(intersectX, intersectY, originX, originY))
              if length < minLength then
                minX, minY, minAngle = intersectX, intersectY, angle
                minLength = length
                found = true
              end
            end
          end
        end

        if found then
          table.insert(visibilityPolygon, {
            x = minX, y = minY, angle = minAngle
          })
        end
      end


      --table.insert(visibilityPolygon, {
      --  x = occluderPoints[i],
      --  y = occluderPoints[i+1],
      --  angle = angle
      --})
    end
  end

  table.sort(visibilityPolygon, angleSortFunc)
  return visibilityPolygon
end

return {
  calculateVisibilityPolygon = calculateVisibilityPolygon
}
