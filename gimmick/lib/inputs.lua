local M = {}

---@enum InputDevice
InputDevice = {
	Key = 0,
	Joy1 = 1,
	Joy2 = 2,
	Joy3 = 3,
	Joy4 = 4,
	Joy5 = 5,
	Joy6 = 6,
	Joy7 = 7,
	Joy8 = 8,
	Joy9 = 9,
	Joy10 = 10,
	Joy11 = 11,
	Joy12 = 12,
	Joy13 = 13,
	Joy14 = 14,
	Joy15 = 15,
	Joy16 = 16,
	Pump1 = 17,
	Pump2 = 18,
	Midi = 19,
	Para1 = 20,
  Unknown = 21,
}

-- for keyboard devices: https://github.com/openitg/openitg/blob/master/src/RageInputDevice.cpp#L10
---@alias Key string

-- https://github.com/openitg/openitg/blob/master/src/GameManager.cpp#L110
---@alias Button string

-- device -> keyname -> os.clock of press
---@type table<InputDevice, table<Key, number>>
M.rawInputs = {}

local oldRawInputs = {}

-- player number -> keyname -> os.clock of press
---@type table<number, table<Button, number>>
M.inputs = {}

local oldInputs = {}

function M.clear()
  oldRawInputs = M.rawInputs
  M.rawInputs = {}
  for _, v in pairs(InputDevice) do
    M.rawInputs[v] = {}
  end
  oldInputs = M.inputs
  M.inputs = {}
  for pn = 1, 2 do
    M.inputs[pn] = {}
  end
end

-- 2 cycles to make sure the old values are valid
M.clear()
M.clear()

---@param inputDevice InputDevice
---@param button Key
---@param pn number?
---@param keyName Button?
---@param keySecondary Button?
function M.input(inputDevice, button, pn, keyName, keySecondary)
  M.rawInputs[inputDevice][button] = os.clock()
  if keyName then
    M.inputs[pn][keyName] = os.clock()
  end
  if keySecondary then
    M.inputs[pn][keySecondary] = os.clock()
  end
end

function M.update()
  for device in pairs(M.rawInputs) do
    for key in pairs(M.rawInputs[device]) do
      -- now pressed, wasn't before -> press
      if oldRawInputs[device][key] == nil then
        event.call('keypress', device, key)
      end
    end
    for key in pairs(oldRawInputs[device]) do
      -- was pressed, now isn't -> release
      if M.rawInputs[device][key] == nil then
        event.call('keyrelease', device, key)
      end
    end
  end
  for pn in pairs(M.inputs) do
    for button in pairs(M.inputs[pn]) do
      -- now pressed, wasn't before -> press
      if not oldInputs[pn][button] then
        event.call('press', pn, button)
      end
    end
    for button in pairs(oldInputs[pn]) do
      -- was pressed, now isn't -> release
      if not M.inputs[pn][button] then
        event.call('release', pn, button)
      end
    end
  end
end

---@param button string
---@param pn number | nil
---@return number?
function M.getInput(button, pn)
  if not pn then
    for plr = 1, 2 do
      if M.inputs[plr][button] ~= -1 then
        return M.inputs[plr][button]
      end
    end
    return nil
  else
    return M.inputs[pn][button]
  end
end

---@param button string
---@param pn number | nil
---@return boolean
function M.isDown(button, pn)
  return M.getInput(button, pn) ~= nil
end

return M