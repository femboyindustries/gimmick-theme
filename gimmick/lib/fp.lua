-- stolen from https://github.com/1bardesign/batteries/blob/master/functional.lua

---@generic T
---@generic F
---@param t table<T>
---@param f fun(a: T, idx: number): F
---@return table<F>
function map(t, f)
	local result = {}
	for i = 1, #t do
		local v = f(t[i], i)
		if v ~= nil then
			table.insert(result, v)
		end
	end
	return result
end

---@generic T
---@generic F
---@param t table<T>
---@param f fun(a: T, idx: number): F?
---@return F?
function foreach(t, f)
	for i = 1, #t do
		local result = f(t[i], i)
		if result ~= nil then
			return result
		end
	end
	return t
end


---@generic T
---@param t table<T>
---@param f fun(a: T, idx: number): boolean
---@return table<T>
function filter(t, f)
	local result = {}
	for i = 1, #t do
		local v = t[i]
		if f(v, i) then
			table.insert(result, v)
		end
	end
	return result
end

---@generic T
---@param t table<T>
---@param f fun(a: T, idx: number): boolean
---@return boolean
function any(t, f)
	for i = 1, #t do
		if f(t[i], i) then
			return true
		end
	end
	return false
end

---@generic T
---@param t table<T>
---@param f fun(a: T, idx: number): boolean
---@return boolean
function none(t, f)
	for i = 1, #t do
		if f(t[i], i) then
			return false
		end
	end
	return true
end

---@generic T
---@param t table<T>
---@param f fun(a: T, idx: number): boolean
---@return boolean
function all(t, f)
	for i = 1, #t do
		if not f(t[i], i) then
			return false
		end
	end
	return true
end

---@generic T
---@param t table<T>
---@param f fun(a: T, idx: number): boolean
---@return number
function count(t, f)
	local c = 0
	for i = 1, #t do
		if f(t[i], i) then
			c = c + 1
		end
	end
	return c
end

---@generic T
---@param t table<T>
---@param e T
---@return boolean
function contains(t, e)
	for i = 1, #t do
		if t[i] == e then
			return true
		end
	end
	return false
end
includes = contains

---@generic T
---@param t table<T>
---@param e T
---@return integer | nil
function find(t, e)
	for i = 1, #t do
		if t[i] == e then
			return i
		end
	end
	return nil
end

---@generic T
---@param t table<T>
---@param e fun(a: T): boolean | nil
---@return T
function findF(t, e)
	for i = 1, #t do
		if e(t[i]) then
			return t[i]
		end
	end
	return nil
end

---@param t table<number>
---@return number
function sum(t)
	local c = 0
	for i = 1, #t do
		c = c + t[i]
	end
	return c
end

---@param t table<number>
---@return number
function mean(t)
	local len = #t
	if len == 0 then
		return 0
	end
	return sum(t) / len
end

---@generic T
---@generic F
---@param t table<T>
---@param f fun(a: F, b: T): F
---@param s F?
---@return F
function foldr(t, f, s)
  local v = s or t[1]
  for i = (s and 1 or 2), #t do
    v = f(v, t[i])
  end
  return v
end

---@generic T
---@generic F
---@param t table<T>
---@param f fun(a: F, b: T): F
---@param s F?
---@return F
function foldl(t, f, s)
  local v = s or t[#t]
  for i = #t - (s and 0 or 1), 1, -1 do
    v = f(v, t[i])
  end
  return v
end