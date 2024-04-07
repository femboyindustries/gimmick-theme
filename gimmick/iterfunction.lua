local iter = {}

function iter:__call(...)
  self.n = self.n + 1
  return self.func(self.n, unpack(arg))
end

iter.__index = iter

function iter:reset()
  self.n = 0
end

-- Returns a function that when called, will call your `func`, adding the amount
-- of times it's been called as the first argument.
--
-- On the first call, this argument will be `1`.
--
-- Use `:reset()` on it to reset the counter.
iterFunction = function(func)
  return setmetatable({
    n = 0,
    func = func,
  }, iter)
end