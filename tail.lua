modem = peripheral.wrap("front")
topBlade = peripheral.wrap("left")
bottomBlade = peripheral.wrap("right")

local HamAPI = dofile("hamilton.lua")  -- import quaternion functions
local command

function rotTop ()
  topBlade.setFlapAngle(-command[1])
end

function rotBottom ()
  bottomBlade.setFlapAngle(command[1])
end

function fire ()
  if (command[2]) then
    rs.setOutput("back", true)
  else
    rs.setOutput("back", false)
  end
end

modem.open(265)
while true do
  local event, modemSide, senderChannel, replyChannel, data, senderDistance = os.pullEvent("modem_message")
  command = data

  parallel.waitForAll(rotTop, rotBottom, fire)

  local quat = ship.getQuaternion()
  local q = {quat.w, quat.x, quat.y, quat.z}
  local lefVec = HamAPI.quatVec({0, 1, 0, 0}, q)
  modem.transmit(8245, 8245, {lefVec, ship.getOmega()})
  

end
