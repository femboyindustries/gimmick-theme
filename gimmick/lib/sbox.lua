-- Public domain Lua sandboxing library intended for use with parsing Metafields
-- files. Made by Jade "oatmealine"

local _M = {}

local ALLOWED_MODULES = {
  'math', 'os', 'coroutine', 'string', 'table'
}
local ALLOWED_GLOBAL_FUNCTIONS = {
  'tonumber', 'tostring', 'print', 'pairs', 'ipairs', 'assert', 'error',
  'pcall', 'xpcall', 'next', 'unpack', 'type', 'rawequal', 'rawget', 'rawset',
  'setmetatable', 'getmetatable', 'DayOfMonth', 'DayOfYear', 'MonthOfYear',
  'Hour', 'Minute', 'Second', 'Weekday', 'Debug', 'Trace'
}
local DANGEROUS_MODULE_FUNCTIONS = {
  string = { 'dump' },
  math   = { 'randomseed' }
}

---@generic T
---@return T
local function copy(t)
  local copied = {}
  for k, v in pairs(t) do
    copied[k] = v
  end
  return copied
end

-- Clears the metatable of a given function. Useful for sanitizing input and
-- output data
---@param tab table
---@return nil
function _M.clear_metatable(tab)
  setmetatable(tab, nil)
  for k, v in pairs(tab) do
    if type(v) == 'table' then
      _M.clear_metatable(v)
    end
  end
end

local function build_env()
  local env = {}
  for _, module in ipairs(ALLOWED_MODULES) do
    if not _G[module] then
      error('module ' .. module .. ' not found while building sandboxed environment')
    end
    local copiedModule = copy(_G[module])
    if DANGEROUS_MODULE_FUNCTIONS[module] then
      for _, func in ipairs(DANGEROUS_MODULE_FUNCTIONS[module]) do
        copiedModule[func] = function()
          error(module .. '.' .. func .. ': Disabled for security purposes by the Metafields spec', 2)
        end
      end
    end
    env[module] = copiedModule
  end
  for _, func in ipairs(ALLOWED_GLOBAL_FUNCTIONS) do
    if not _G[func] then
      error('function ' .. module .. ' not found while building sandboxed environment')
    end
    env[func] = _G[func]
  end
  for k, val in pairs(_G) do
    if
      type(val) ~= 'table' and
      type(val) ~= 'function' and
      type(val) ~= 'userdata'
    then
      env[k] = val
    end
  end
  return env
end

_M.env = build_env()

-- Sandboxes a given function. Invocations of the function will then
-- run within the sandbox
---@param f function
function _M.sandbox_function(f)
  setfenv(f, _M.env)
end

-- Loads a string via `loadstring`, then returns the sandboxed function result
---@param str string
---@param chunkName string? @ Name of the string, for error reporting
---@return function
function _M.loadstring(str, chunkName)
  local chunk, err = loadstring(str, chunkName)
  if not chunk then
    error(err, 2)
  end
  _M.sandbox_function(chunk)
  return chunk
end

-- Loads a file via `loadfile`, then returns the sandboxed function result
---@param path string
---@return function
function _M.loadfile(path)
  local chunk, err = loadfile(path)
  if not chunk then
    error(err, 2)
  end
  _M.sandbox_function(chunk)
  return chunk
end

-- Sandboxes and runs a file, similar to `dofile`
---@param path string
---@vararg any @ Arguments to be passed to the file
function _M.dofile(path, ...)
  local chunk = _M.loadfile(path)
  return chunk(unpack(arg))
end

return _M