function ham (vec1, vec2)
  local s = vec1[1]*vec2[1] - vec1[2]*vec2[2] - vec1[3]*vec2[3] - vec1[4]*vec2[4]
  local i = vec1[1]*vec2[2] + vec1[2]*vec2[1] + vec1[3]*vec2[4] - vec1[4]*vec2[3]
  local j = vec1[1]*vec2[3] - vec1[2]*vec2[4] + vec1[3]*vec2[1] + vec1[4]*vec2[2]
  local k = vec1[1]*vec2[4] + vec1[2]*vec2[3] - vec1[3]*vec2[2] + vec1[4]*vec2[1]
  local finVec = {s, i, j, k}
  return finVec
end


function quatVec (vec, quat)
  invQuat = {quat[1], -quat[2], -quat[3], -quat[4]}
  local finVec = ham(ham(quat, vec), invQuat)
  return vector.new(finVec[2], finVec[3], finVec[4])
end
  

return {
  ham = ham,
  quatVec = quatVec,
}
