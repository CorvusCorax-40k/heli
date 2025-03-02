local test = "abcdef"
local test1 = "ghijkl"
local test2 = "mnopqr"
local test3 = "stuvwx"

function printText3 (x, y, text, color, backColor, blitColor, blitBackColor)
  local length = string.len(text)
  for i=1, length, 1 do
    printChar3(x+i*4-4, y, text:sub(i, i), color, backColor, blitColor, blitBackColor)
  end

end


function printChar3 (x, y, char, color, backColor, blitColor, blitBackColor)
  
  if (char == "A" or char == "a") then
    paintutils.drawLine(x, y, x, y+2, color)
    paintutils.drawPixel(x+1, y, color)
    paintutils.drawLine(x+2, y, x+2, y+2, color)
    term.setCursorPos(x+1, y+1)
    term.blit(string.char(140), blitColor, blitBackColor)

  elseif (char == "B" or char == "b") then
    paintutils.drawBox(x, y, x+2, y+2, color)
    term.setCursorPos(x+1, y+1)
    term.blit(string.char(140), blitColor, blitBackColor)
    term.setCursorPos(x+2, y+2)
    term.blit(string.char(135), blitColor, blitBackColor)
    term.setCursorPos(x+2, y)
    term.blit(string.char(139), blitBackColor, blitColor)
    term.setCursorPos(x+2, y+1)
    term.blit(string.char(136), blitBackColor, blitColor)

  elseif (char == "C" or char == "c") then
    paintutils.drawBox(x, y, x+2, y+2, color)
    paintutils.drawPixel(x+2, y+1, backColor)

  elseif (char == "D" or char == "d") then
    paintutils.drawBox(x, y, x+2, y+2, color)
    term.setCursorPos(x+2, y+2)
    term.blit(string.char(135), blitColor, blitBackColor)
    term.setCursorPos(x+2, y)
    term.blit(string.char(139), blitBackColor, blitColor)

  elseif (char == "E" or char == "e") then
    paintutils.drawFilledBox(x, y, x+2, y+2, color)
    term.setCursorPos(x+1, y+1)
    term.blit(string.char(140)..string.char(140), blitColor..blitColor, blitBackColor..blitBackColor)

  elseif (char == "F" or char == "f") then
    paintutils.drawLine(x, y, x, y+2, color)
    paintutils.drawLine(x, y, x+2, y, color)
    term.setCursorPos(x+1, y+1)
    term.blit(string.char(140)..string.char(140), blitColor..blitColor, blitBackColor..blitBackColor)

  elseif (char == "G" or char == "g") then
    paintutils.drawFilledBox(x, y, x+2, y+2, color)
    term.setCursorPos(x+2, y+1)
    term.blit(string.char(147), blitBackColor, blitColor)
    term.setCursorPos(x+1, y+1)
    term.blit(string.char(136), blitColor, blitBackColor)

  elseif (char == "H" or char == "h") then
   paintutils.drawFilledBox(x, y, x+2, y+2, color)
   paintutils.drawPixel(x+1, y, backColor)
   paintutils.drawPixel(x+1, y+2, backColor)

  elseif (char == "I" or char == "i") then
    term.setCursorPos(x, y)
    term.blit(string.rep(string.char(131), 3), string.rep(blitColor, 3), string.rep(blitBackColor, 3))
    term.setCursorPos(x, y+2)
    term.blit(string.rep(string.char(143), 3), string.rep(blitBackColor, 3), string.rep(blitColor, 3))
    paintutils.drawLine(x+1, y, x+1, y+2, color)

  elseif (char == "J" or char == "j") then
    term.setCursorPos(x, y)
    term.blit(string.rep(string.char(131), 3), string.rep(blitColor, 3), string.rep(blitBackColor, 3))
    term.setCursorPos(x, y+2)
    term.blit(string.char(143), blitBackColor, blitColor)
    paintutils.drawLine(x+1, y, x+1, y+2, color)

  elseif (char == "K" or char == "k") then
    paintutils.drawLine(x, y, x, y+2, color)
    paintutils.drawLine(x, y, x+2, y+2, color)
    paintutils.drawPixel(x+2, y, color)

  elseif (char == "L" or char == "l") then
    paintutils.drawLine(x, y+2, x+2, y+2, color)
    paintutils.drawLine(x, y, x, y+2, color)


  elseif (char == "M" or char == "m") then
    paintutils.drawLine(x, y, x, y+2, color)
    paintutils.drawLine(x+2, y, x+2, y+2, color)
    term.setCursorPos(x, y)
    term.blit(string.char(130), blitBackColor, blitColor)
    term.setCursorPos(x+2, y)
    term.blit(string.char(129), blitBackColor, blitColor)
    term.setCursorPos(x+1, y+1)
    term.blit(string.char(143), blitColor, blitBackColor)

  elseif (char == "N" or char == "n") then
    paintutils.drawLine(x, y, x, y+2, color)
    paintutils.drawLine(x+2, y, x+2, y+2, color)
    term.setCursorPos(x, y)
    term.blit(string.char(130), blitBackColor, blitColor)
    term.setCursorPos(x+2, y+2)
    term.blit(string.char(144), blitBackColor, blitColor)
    term.setCursorPos(x+1, y+1)
    term.blit(string.char(146), blitBackColor, blitColor)

  elseif (char == "O" or char == "o") then
    paintutils.drawBox(x, y, x+2, y+2, color)

  elseif (char == "P" or char == "p") then
    paintutils.drawLine(x, y, x, y+2, color)
    paintutils.drawLine(x+2, y, x+2, y+1, color)
    term.setCursorPos(x+1, y)
    term.blit(string.char(143), blitColor, blitBackColor)
    term.setCursorPos(x+1, y+1)
    term.blit(string.char(131), blitBackColor, blitColor)

  elseif (char == "Q" or char == "q") then
    paintutils.drawBox(x, y, x+2, y+2, color)
    term.setCursorPos(x, y)
    term.blit(string.char(135), blitBackColor, blitColor)
    term.setCursorPos(x, y+2)
    term.blit(string.char(139), blitColor, blitBackColor)
    term.setCursorPos(x+2, y)
    term.blit(string.char(139), blitBackColor, blitColor)
    term.setCursorPos(x+2, y+2)
    term.blit(string.char(152), blitBackColor, blitColor)
    term.setCursorPos(x+1, y+1)
    term.blit(string.char(159), blitBackColor, blitColor)

  elseif (char == "R" or char == "r") then
    paintutils.drawLine(x, y, x, y+2, color)
    paintutils.drawLine(x+2, y, x+2, y+1, color)
    term.setCursorPos(x+1, y)
    term.blit(string.char(143), blitColor, blitBackColor)
    term.setCursorPos(x+1, y+1)
    term.blit(string.char(131), blitBackColor, blitColor)
    term.setCursorPos(x+1, y+2)
    term.blit(string.char(130), blitColor, blitBackColor)
    term.setCursorPos(x+2, y+2)
    term.blit(string.char(146), blitBackColor, blitColor)

  elseif (char == "S" or char == "s") then
    term.setCursorPos(x+1, y)
    term.blit(string.char(143), blitColor, blitBackColor)
    term.setCursorPos(x+2, y)
    term.blit(string.char(143), blitColor, blitBackColor)
    term.setCursorPos(x, y)
    term.blit(string.char(129), blitBackColor, blitColor)
    term.setCursorPos(x, y+1)
    term.blit(string.char(139), blitColor, blitBackColor)
    term.setCursorPos(x+1, y+1)
    term.blit(string.char(140), blitColor, blitBackColor)
    term.setCursorPos(x+2, y+1)
    term.blit(string.char(139), blitBackColor, blitColor)
    term.setCursorPos(x+2, y+2)
    term.blit(string.char(159), blitColor, blitBackColor)
    term.setCursorPos(x+1, y+2)
    term.blit(string.char(131), blitBackColor, blitColor)
    term.setCursorPos(x, y+2)
    term.blit(string.char(131), blitBackColor, blitColor)

  elseif (char == "T" or char == "t") then
    paintutils.drawLine(x, y, x+2, y, color)
    paintutils.drawLine(x+1, y, x+1, y+2, color)

  elseif (char == "U" or char == "u") then
    paintutils.drawBox(x, y, x+2, y+2, color)
    paintutils.drawPixel(x+1, y, backColor)

  elseif (char == "V" or char == "v") then
    term.setCursorPos(x, y)
    term.blit(string.char(149), blitColor, blitBackColor)
    term.setCursorPos(x, y+1)
    term.blit(string.char(149), blitBackColor, blitColor)
    term.setCursorPos(x+2, y+1)
    term.blit(string.char(149), blitColor, blitBackColor)
    term.setCursorPos(x+2, y)
    term.blit(string.char(149), blitBackColor, blitColor)
    paintutils.drawPixel(x+1, y+2, color)

  elseif (char == "W" or char == "w") then
    term.setCursorPos(x, y)
    term.blit(string.char(149), blitColor, blitBackColor)
    term.setCursorPos(x, y+1)
    term.blit(string.char(149), blitColor, blitBackColor)
    paintutils.drawPixel(x, y+2, color)
    paintutils.drawPixel(x+2, y+2, color)
    term.setCursorPos(x+2, y+1)
    term.blit(string.char(149), blitBackColor, blitColor)
    term.setCursorPos(x+2, y)
    term.blit(string.char(149), blitBackColor, blitColor)
    paintutils.drawPixel(x+1, y+1, color)

  elseif (char == "X" or char == "x") then
    paintutils.drawLine(x, y, x+2, y+2, color)
    paintutils.drawLine(x+2, y, x, y+2, color)

  elseif (char == "Y" or char == "y") then
    paintutils.drawLine(x+1, y+1, x+1, y+2, color)
    paintutils.drawPixel(x, y, color)
    paintutils.drawPixel(x+2, y, color)
    term.setCursorPos(x, y+1)
    term.blit(string.char(130), blitColor, blitBackColor)
    term.setCursorPos(x+2, y+1)
    term.blit(string.char(129), blitColor, blitBackColor)
    term.setCursorPos(x+1, y)
    term.blit(string.char(143), blitBackColor, blitColor)

  elseif (char == "Z" or char == "z") then
    paintutils.drawLine(x, y, x+2, y, color)
    paintutils.drawLine(x, y+2, x+2, y+2, color)
    term.setCursorPos(x+2, y+1)
    term.blit(string.char(129), blitColor, blitBackColor)
    term.setCursorPos(x+1, y+1)
    term.blit(string.char(158), blitColor, blitBackColor)
    term.setCursorPos(x, y+1)
    term.blit(string.char(159), blitBackColor, blitColor)
  end
  
end

return {
  printText3 = printText3,
  printChar3 = printChar3,
}
