Queue = {}

function Queue.pushleft (list, value)
  local first = list.first - 1
  list.first = first
  list[first] = value
end
    
function Queue.pushright (list, value)
  local last = list.last + 1
  list.last = last
  list[last] = value
end	
    
function Queue.popleft (list)
  local first = list.first
  if first > list.last then error("list is empty") end
  local value = list[first]
  list[first] = nil        -- to allow garbage collection
  list.first = first + 1
  return value
end
    
function Queue.popright (list)
  local last = list.last
  if list.first > last then error("list is empty") end
  local value = list[last]
  list[last] = nil         -- to allow garbage collection
  list.last = last - 1
  return value
end

function Queue.new (size)
  local list = {first = 0, last = -1}
  for i = 1, size, 1 do
    Queue.pushright(list, 0)
  end
  return list
    
end	

function Queue.sum (list)
  local sum = 0
  for i,v in pairs(list) do
    if (not (i == "first") and not (i == "last")) then
      sum = sum + v
    end
  end
  return sum
end

function Queue.mean (list)
  local sum = 0
  local count = 0
  for i,v in pairs(list) do
    if (not (i == "first") and not (i == "last")) then
      count = count+1
      sum = sum + v
    end
  end
  return sum/count
end


return Queue
