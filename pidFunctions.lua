local VectorAPI = dofile("vectorCalc.lua")
local Queue = dofile("queue.lua")

function anglePID (pid, id, table)  -- table = [ angle,  targetAngle,  omega,  intQueue,  axis,  iControl , tControl]
  local angle, targetAngle, omega, intQueue, axis, iControl, tControl = table["angle"], table["targetAngle"], table["omega"], table["intQueue"], table["axis"], table["iControl"], table["tControl"]

  local viewFunctions = {}

  local angleDev = angle - targetAngle                           --positive when pitched too far away from reference axis
  Queue.pushright(intQueue, angleDev/20)
  Queue.popleft(intQueue)


  local angleI = pid[id][3] * Queue.sum(intQueue)
  if (angleI > iControl) then
    angleI = iControl
  elseif (angleI < -iControl) then
    angleI = -iControl
  end


  local controlVal = pid[id][1] * angleDev - pid[id][2] * omega + angleI
  if (controlVal > tControl) then
    controlVal = tControl
  elseif (controlVal < -tControl) then
    controlVal = -tControl
  end

  viewFunctions["pFactor"] = pid[id][1] * angleDev
  viewFunctions["iFactor"] = pid[id][3] * Queue.sum(intQueue)
  viewFunctions["dFactor"] = pid[id][2] * omega
  viewFunctions["control"] = controlVal
  return controlVal, viewFunctions
end



function displacementPID ()
  print("lazy guy")
end



function velocityPID (pid, id, table)  -- table = [ velocity,  targetVelocity,  oldVelocity,  derivQueue,  intQueue,  axis,  iControl ]
  local velocity, targetVelocity, oldVelocity, derivQueue, intQueue, axis, iControl, tControl = table["velocity"], table["targetVelocity"], table["oldVelocity"], table["derivQueue"], table["intQueue"], table["axis"], table["iControl"], table["tControl"]


  local viewFunctions = {}

  local velocityDev = velocity - targetVelocity
  Queue.pushright(intQueue, velocityDev/20)
  Queue.popleft(intQueue)

  Queue.pushright(derivQueue, velocity - oldVelocity)
  Queue.popleft(derivQueue)
  local acceleration = Queue.mean(derivQueue)

  table["oldVelocity"] = table["velocity"]   --EDIT
  local velocityI = pid[id][3] * Queue.sum(intQueue)
  if (velocityI > iControl) then
    velocityI = iControl
  elseif (velocityI < -iControl) then
    velocityI = -iControl
  end

  controlVal = pid[id][1] * velocityDev - pid[id][2] * acceleration + velocityI
  if (controlVal > tControl) then
    controlVal = tControl
  elseif (controlVal < -tControl) then
    controlVal = -tControl
  end

  viewFunctions["pFactor"] = pid[id][1] * velocityDev
  viewFunctions["iFactor"] = -pid[id][3] * acceleration
  viewFunctions["dFactor"] = pid[id][2] * Queue.sum(intQueue)
  return controlVal, viewFunctions
  
end

return {
  anglePID = anglePID,
  displacementPID = displacementPID,
  velocityPID = velocityPID,
}
