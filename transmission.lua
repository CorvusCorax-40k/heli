--ROTOR CONTROL DEFINITIONS
local frontBlade = peripheral.wrap("front")
local backBlade = peripheral.wrap("back")
local leftBlade = peripheral.wrap("left")
local rightBlade = peripheral.wrap("right")
local modem = peripheral.wrap("top")
local pi = math.pi
local adjustment = pi
local fire = false

local pR = {0, 0, 1, 0}
local pB = {0, 0, 0, 1}

local command = {["angFront"] = 0, ["angBack"] = 0, ["angLeft"] = 0, ["angRight"] = 0}
--ROTOR CONTROL DEFINITIONS

local quat
local q
local omega

local rotVec = vector.new(0, 1, 0)
local forVec = vector.new(0, 0, 1)
local lefVec = vector.new(1, 0, 0)

local i = vector.new(1, 0, 0)
local j = vector.new(0, 1, 0)
local k = vector.new(0, 0, 1)

local pR = {0, 0, 1, 0}
local pF = {0, 1, 0, 0}
local pL = {0, 0, 0, 1}

local pid = {
 --P, D, I
  {10, 20, .1}, --pitch
  {10, 20, .1}, --roll
  {40, 40, .3},  --yaw
  {1, 0, 1.1},  --col
  {1.5, 15, .05},  --sideways translation
  {1.5, 30, .05},  --forwards translation
}

local pitch = 0
local roll = 0
local yaw = 0

local velocity = vector.new(0, 0, 0)
local omega = vector.new(0, 0, 0)
local tailOmega = vector.new(0, 0, 0)

local altitude = 0

local modem = peripheral.wrap("top")

local HamAPI = dofile("hamilton.lua")  -- import quaternion functions
local VectorAPI = dofile("vectorCalc.lua")
local Queue = dofile("queue.lua")
local PIDFunctions = dofile("pidFunctions.lua")

local omega
local velocity
local setting = 1

local directions = {
                    ["rotVec"] = vector.new(0, 1, 0),
                    ["lefVec"] = vector.new(1, 0, 0),
                    ["forVec"] = vector.new(0, 0, 1),
}

local pitchTable = {
                    ["angle"] = pitch,
                    ["targetAngle"] = 0,               --relative to initial position, around ship x axis, positive when pitched up
                    ["omega"] = omega,
                    ["intQueue"] = Queue.new(100),
                    ["axis"] = lefVec,
                    ["iControl"] = 5,
                    ["tControl"] = 15,
                  }

local rollTable = {
                    ["angle"] = roll,
                    ["targetAngle"] = 0,               --relative to initial position, around ship z axis, positive when rolled left
                    ["omega"] = omega,
                    ["intQueue"] = Queue.new(100),
                    ["axis"] = forVec,
                    ["iControl"] = 5,
                    ["tControl"] = 20,

                  }

local yawTable = {
                    ["angle"] = yaw,
                    ["velocity"] = omega,
                    ["targetVelocity"] = 0,  
                    ["oldVelocity"] = 0,         
                    ["derivQueue"] = Queue.new(5),
                    ["intQueue"] = Queue.new(100),
                    ["axis"] = rotVec,
                    ["iControl"] = 4	,
                    ["tControl"] = 40,
                  }

local vertTable = {
                    ["velocity"] = velocity,
                    ["targetVelocity"] = 0,  
                    ["oldVelocity"] = 0,           
                    ["derivQueue"] = Queue.new(5),
                    ["intQueue"] = Queue.new(100),
                    ["axis"] = rotVec,                --positive when moving up
                    ["iControl"] = 5,
                    ["tControl"] = 5,
                  }

local sideTable = {
                    ["velocity"] = velocity,
                    ["targetVelocity"] = 0,  
                    ["oldVelocity"] = 0,          
                    ["derivQueue"] = Queue.new(5),
                    ["intQueue"] = Queue.new(100),
                    ["axis"] = lefVec,                 --positive when moving left
                    ["iControl"] = 15,
                    ["tControl"] = 20,
                  }

local foreTable = {
                    ["velocity"] = velocity,
                    ["targetVelocity"] = 0,  
                    ["oldVelocity"] = 0,           
                    ["derivQueue"] = Queue.new(5),
                    ["intQueue"] = Queue.new(100),
                    ["axis"] = forVec,                --positive when moving forwards
                    ["iControl"] = 15,
                    ["tControl"] = 20,
                  }



local command = {}
local controls = {["col"] = 0, ["pitch"] = 0, ["roll"] = 0, ["yaw"] = 1, ["bearing"] = vector.new(0, 0, 1)}


function tailUpdate ()
  modem.open(8245)
  while true do
    local event, modemSide, senderChannel, replyChannel, command, senderDistance = os.pullEvent("modem_message")
    if (senderChannel == 8245) then
      directions["lefVec"] = vector.new(command[1].x, command[1].y, command[1].z)
      tailOmega = vector.new(command[2].x, command[2].y, command[2].z)
    end
  end
end


function doOnKey (Key1, Key2, notKey1, notKey2, variable, change, max, sign)
  if (sign > 0) then
    if ( (Key1 or Key2) and (not notKey1 and not notKey2) ) then
      if (variable < max) then
        variable = variable + change
      else
        variable = max
      end
    end
  else
    if ( (Key1 or Key2) and (not notKey1 and not notKey2) ) then
      if (variable > -max) then
        variable = variable - change
      else
        variable = -max
      end
    end
  end
  return variable
end



function getKeyInputs ()
  modem.open(539)
  while true do
    local event, modemSide, senderChannel, replyChannel, command, senderDistance = os.pullEvent("modem_message")  --wait for controller input (timed in controller)
    
    --EDIT
    
    if (senderChannel == 539) then
      if (setting == 1) then
        --                                    PRESSED KEY           PRESSED KEY        NOT PRESSED KEY       NOT PRESSED KEY   AFFECTED VARIABLE             INCREMENT     MAXIMUM       SIGN
        ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        pitchTable["targetAngle"]   = doOnKey(command["w"],          false,            command["s"],         false,            pitchTable["targetAngle"],    math.rad(10), math.rad(90),  1)
        pitchTable["targetAngle"]   = doOnKey(command["s"],          false,            command["w"],         false,            pitchTable["targetAngle"],    math.rad(10), math.rad(90), -1)

        rollTable["targetAngle"]    = doOnKey(command["a"],          false,            command["d"],         false,            rollTable["targetAngle"],     math.rad(10), math.rad(90), -1)
        rollTable["targetAngle"]    = doOnKey(command["d"],          false,            command["a"],         false,            rollTable["targetAngle"],     math.rad(10), math.rad(90),  1)

        yawTable["targetVelocity"]  = doOnKey(command["q"],          command["left"],  command["e"],         command["right"], yawTable["targetVelocity"],   0.2,          1.8         ,  1)
        yawTable["targetVelocity"]  = doOnKey(command["e"],          command["right"], command["s"],         command["left"],  yawTable["targetVelocity"],   0.2,          1.8         , -1)

        vertTable["targetVelocity"] = doOnKey(command["leftShift"],  command["up"],    command["leftCtrl"],  command["down"],  vertTable["targetVelocity"],  .33,          2.97,          1)
        vertTable["targetVelocity"] = doOnKey(command["leftCtrl"],   command["down"],  command["leftShift"], command["up"],    vertTable["targetVelocity"],  .33,          2.97,         -1)



      elseif (setting == 2) then
        --                                    PRESSED KEY           PRESSED KEY        NOT PRESSED KEY       NOT PRESSED KEY   AFFECTED VARIABLE             INCREMENT     MAXIMUM       SIGN
        ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        foreTable["targetVelocity"] = doOnKey(command["w"],          false,            command["s"],         false,            foreTable["targetVelocity"],  0.5,          4.5,          -1)
        foreTable["targetVelocity"] = doOnKey(command["s"],          false,            command["w"],         false,            foreTable["targetVelocity"],  0.5,          4.5,           1)

        sideTable["targetVelocity"] = doOnKey(command["a"],          false,            command["d"],         false,            sideTable["targetVelocity"],  0.5,          4.5,          -1)
        sideTable["targetVelocity"] = doOnKey(command["d"],          false,            command["a"],         false,            sideTable["targetVelocity"],  0.5,          4.5,           1)

        yawTable["targetVelocity"]  = doOnKey(command["q"],          command["left"],  command["e"],         command["right"], yawTable["targetVelocity"],   0.1,          0.9,           1)
        yawTable["targetVelocity"]  = doOnKey(command["e"],          command["right"], command["s"],         command["left"],  yawTable["targetVelocity"],   0.1,          0.9,          -1)

        vertTable["targetVelocity"] = doOnKey(command["leftShift"],  command["up"],    command["leftCtrl"],  command["down"],  vertTable["targetVelocity"],  .33,          2.97,          1)
        vertTable["targetVelocity"] = doOnKey(command["leftCtrl"],   command["down"],  command["leftShift"], command["up"],    vertTable["targetVelocity"],  .33,          2.97,         -1)
      end

      if (command["h"]) then
        pitchTable["targetAngle"] = 0
        rollTable["targetAngle"] = 0
        yawTable["targetVelocity"] = 0
        vertTable["targetVelocity"] = 0
        foreTable["targetVelocity"] = 0
        sideTable["targetVelocity"] = 0
      end

      if (command["c"]) then
        pitchTable["targetAngle"] = 0
        rollTable["targetAngle"] = 0
        yawTable["targetVelocity"] = 0
        vertTable["targetVelocity"] = 0
        if (setting == 1) then
          setting = 2
          sleep(0.35)
        elseif (setting == 2) then
          setting = 1
        sleep(0.35)
        end
      end
      
      if (command["space"]) then
        fire = true
      else
        fire = false
      end
    end
  end
end



function getStabilizationMovements ()

  local count = 0
  while true do

    quat = ship.getQuaternion()
    q = {quat.w, quat.x, quat.y, quat.z}

    directions["rotVec"] = HamAPI.quatVec(pR, q) --vertical vector on the heli (from main rotor)
    directions["forVec"] = directions["lefVec"]:cross(directions["rotVec"])   --forward vector on heli

    rotVec = directions["rotVec"] --vertical vector on the helix
    forVec = directions["forVec"] --forward vector on the heli
    lefVec = directions["lefVec"] --left vector on the heli (for the purpose of rotation)



    pitchTable["axis"], rollTable["axis"], yawTable["axis"] = lefVec, forVec, rotVec
    vertTable["axis"], sideTable["axis"], foreTable["axis"] = rotVec, lefVec, forVec


    local vel = ship.getVelocity()
    velocity = vector.new(vel.x, vel.y, vel.z)


    om = ship.getOmega()
    omega = vector.new(om.x, om.y, om.z)  --OMEGA FOR FUNCTION


    pitch = VectorAPI.diffAxis(rotVec, j, lefVec)  --positive when pitched up  --ANGLE FOR FUNCTION
    roll = VectorAPI.diffAxis(rotVec, j, forVec)  --positive when rolled right
    yaw = VectorAPI.diffAxis(forVec, k, rotVec)  --positive when yawed right

    pitchTable["angle"], rollTable["angle"], yawTable["angle"] = pitch, roll, yaw
    pitchTable["omega"], rollTable["omega"], yawTable["velocity"] = VectorAPI.proj(omega, lefVec):dot(lefVec), VectorAPI.proj(omega, forVec):dot(forVec), VectorAPI.proj(tailOmega, rotVec):dot(rotVec)
    vertTable["velocity"], sideTable["velocity"], foreTable["velocity"] = VectorAPI.proj(velocity, rotVec):dot(rotVec), VectorAPI.proj(velocity, lefVec):dot(lefVec), VectorAPI.proj(velocity, forVec):dot(forVec)


    local pitchControl, pView = PIDFunctions.anglePID(pid, 1, pitchTable)
    local rollControl, rView = PIDFunctions.anglePID(pid, 2, rollTable)
    local yawControl, yView = PIDFunctions.velocityPID(pid, 3, yawTable)
    local vertControl, vView = PIDFunctions.velocityPID(pid, 4, vertTable)  --here
    local sideControl, sView = PIDFunctions.velocityPID(pid, 5, sideTable)
    local foreControl, fView = PIDFunctions.velocityPID(pid, 6, foreTable)


    if (setting == 1) then
      controls["pitch"] = pitchControl - 1     --Positive pitches up
      controls["roll"] = -rollControl + 0.5   --Positive pitches to the right
      controls["yaw"] = -yawControl
      controls["col"] = vertControl
    elseif (setting == 2) then
      controls["pitch"] = -foreControl + pitchControl*3 - 1
      controls["roll"] = -sideControl - rollControl*3 + 0.5
      controls["yaw"] = -yawControl
      controls["col"] = vertControl
    end

    term.clear()
    term.setCursorPos(1,1)
    print(controls["pitch"])
    print(controls["roll"])
    print(controls["yaw"])

   -- controls["pitch"] = 0
   -- controls["roll"] = 0
   -- controls["yaw"] = 0

    local displayList = {["pitch"] = pitch,
                   ["pitchTable"] = pitchTable,
                   ["rollTable"] = rollTable,
                   ["yawTable"] = yawTable,
                   ["foreTable"] = foreTable,
                   ["sideTable"] = sideTable,
                   ["vertTable"] = vertTable,
                   ["setting"] = setting,
                 }

    local data1 = {["pitchC"] = controls["pitch"],
                  ["rollC"] = controls["roll"],
                  ["yawC"] = controls["yaw"],
                  ["pitch"] = pitch,
                  ["roll"] = roll,
                  ["yaw"] = proj(omega, rotVec):dot(rotVec),
                  ["foreC"] = foreControl,
                  ["pView"] = fView,
                  ["rView"] = sView,
                  ["yView"] = yView,
                  ["vView"] = vView,
                  }
    --
    modem.transmit(1111, 1111, data1)
    modem.transmit(3477,3477,displayList)
    modem.transmit(265, 265, {controls["yaw"], fire})
  

--[[  CONTROLS
      NEGATIVE FORCES DOWN (W), POSITIVE FORCES UP (S)
      NEGATIVE FORCES ROLL LEFT (D), POSITIVE FORCES ROLL RIGHT (A)
      NEGATIVE FORCES YAW LEFT (Q), POSITIVE FORCES YAW RIGHT (E)
]]--
      
    sleep(0)
  end

end




function rotFront ()
  local angle = command["angFront"]
  frontBlade.setFlapAngle(angle)
end

function rotBack ()
  local angle = command["angBack"]
  backBlade.setFlapAngle(-angle)
end

function rotLeft ()
  local angle = command["angLeft"]
  leftBlade.setFlapAngle(-angle)
end

function rotRight ()
  local angle = command["angRight"]
  rightBlade.setFlapAngle(angle)
end




function sendRotorMovements ()

  while true do

    local quat = ship.getQuaternion()
    local q = {quat.w, quat.x, quat.y, quat.z}


    local rotVec = HamAPI.quatVec(pR, q)
    local frontVec = HamAPI.quatVec(pB, q)


    local offset = VectorAPI.diff(frontVec, directions["forVec"])
    local orientation = VectorAPI.orient(directions["forVec"], frontVec, rotVec)  --  1 if frontRotor is in left side, -1 if in right side
    local frontHeading = (offset * orientation) - adjustment


    local leftHeading = frontHeading + (pi / 2)
    local backHeading = frontHeading + pi
    local rightHeading = frontHeading + (3 * pi / 2)
  
  
    command = {["angFront"] = 0, ["angBack"] = 0, ["angLeft"] = 0, ["angRight"] = 0}
  
    --print(controls["pitch"])

    command["angFront"] = -(controls["pitch"] * math.cos(frontHeading)) - (controls["roll"] * math.sin(frontHeading)) + controls["col"]
    command["angLeft"]  =  (controls["pitch"] * math.cos(leftHeading))  + (controls["roll"] * math.sin(leftHeading))  + controls["col"]
    command["angBack"]  = -(controls["pitch"] * math.cos(backHeading))  - (controls["roll"] * math.sin(backHeading))  + controls["col"]
    command["angRight"] =  (controls["pitch"] * math.cos(rightHeading)) + (controls["roll"] * math.sin(rightHeading)) + controls["col"]
  
  

    --do calculations for which to move based on rotor position


    parallel.waitForAll(rotFront, rotBack, rotLeft, rotRight)
    sleep(0)

  end

--[[
  while true do
    quat = ship.getQuaternion()
    q = {quat.w, quat.x, quat.y, quat.z}
    local hullVec = HamAPI.quatVec(pF, q)

    controls["bearing"] = hullVec

    modem.transmit(265, 265, controls)
    sleep(0)
  end
]]--

end




parallel.waitForAll(getStabilizationMovements, sendRotorMovements, getKeyInputs, tailUpdate)



