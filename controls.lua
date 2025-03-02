local modem = peripheral.wrap("back")
local keysPressed = {}
local Display = dofile("controllerDisplay.lua")
local TextAPI = dofile("termText.lua")

function round(num, numDec)
  local mult = 10^(numDec)
  return math.floor(num * mult + 0.5) / mult
end

function keyCheck ()
  while true do
    local event, key, is_held = os.pullEvent()

    if (event == "key") then
      keysPressed[keys.getName(key)] = true
    elseif (event == "key_up") then
      keysPressed[keys.getName(key)] = false
    end
  end
  sleep(0.1)
end



function keyUpdate ()
  while true do
    modem.transmit(539, 539, keysPressed)
    sleep(0.1)
  end
end



function display ()
  modem.open(3477)
  
  while true do
    local event, modemSide, senderChannel, replyChannel, data, senderDistance = os.pullEvent("modem_message")

    if (data["setting"] == 1) then

      term.clear()
      TextAPI.printText3(2, 2, "normal", colors.lightGray, colors.black, "8", "f")
      
      Display.printPR(10, 10, -round(data["pitchTable"]["targetAngle"]/math.rad(10), 0), -round(data["rollTable"]["targetAngle"]/math.rad(10), 0))
      Display.printCol(22, 10, -round(data["vertTable"]["targetVelocity"], 0))
      Display.printYaw(10, 17, -round(data["yawTable"]["targetVelocity"]*5, 0))
      term.setBackgroundColor(colors.black)
      sleep(0.15)

    elseif (data["setting"] == 2) then

      term.clear()
      TextAPI.printText3(2, 2, "detail", colors.lightGray, colors.black, "8", "f")
      
      Display.printPR(10, 10, round(data["foreTable"]["targetVelocity"]*2, 0), -round(data["sideTable"]["targetVelocity"]*2, 0))
      Display.printCol(22, 10, -round(data["vertTable"]["targetVelocity"]*3, 0))
      Display.printYaw(10, 17, -round(data["yawTable"]["targetVelocity"]*10, 0))
      term.setBackgroundColor(colors.black)
      sleep(0.15)
    end
  end
end



parallel.waitForAny(keyCheck, keyUpdate, display)

