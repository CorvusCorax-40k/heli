function proj (A, B) --part of vector A in direction of vector B
  local comp = A:dot(B) / B:length() --|A||B|cos(0) / |B|
  local proj = B:normalize() * comp --in direction of B
  return proj
end



function orth (A, B) --finds component of vector A orthogonal to B (perpendicular to)
  return A:sub(proj(A, B))
end
 
 

function diff (A, B) --finds angle difference between vectors (in radians)
  local cos = A:dot(B) / (A:length() * B:length()) -- |A||B|cos(0) / |A||B|
  if (cos >= 1) then
    cos = 1
  end
  return math.abs(math.acos(cos))
end
  
  
function orient (A, B, axis) --determines orientation of two vectors around axis
  local oA = orth(A, axis)
  local oB = orth(B, axis)
  if (oA:cross(oB) == vector.new(0,0,0)) then
    return 0
  else
    local norm = oA:cross(oB):normalize() -- A to B
    return norm:dot(axis:normalize())   -- 1 if counterclockwise, -1 if clockwise
  end
end


function diffAxis (A, B, axis)
  return diff(orth(A, axis), orth(B, axis)) * orient(A, B, axis) -- 1 if counterclockwise, -1 if clockwise, A to B
end


return {
  proj = proj,
  orth = orth,
  diff = diff,
  orient = orient,
  diffAxis = diffAxis,
}
