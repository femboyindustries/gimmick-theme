local stack = {}

function stack:push(entry)
  table.insert(self, entry)
end

function stack:pop()
  local t = self[#self]
  table.remove(self, #self)
  return t
end

function stack:top()
  return self[#self]
end

function stack:clear()
  for i = #self, 1, -1 do
    table.remove(self, i)
  end
end

function stack:log(str)
  print(string.rep('  ', #self) .. tostring(str))
end

stack.__index = stack

function stack.new()
  return setmetatable({}, stack)
end

return stack