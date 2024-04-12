local M = {}

local serpent = require 'gimmick.lib.serpent'

local SAVE_NAME = 'gimmick!'

M.data = {
  settings = {
    console = true,
  },
}

function M.load()
  local saved = PROFILEMAN:GetMachineProfile():GetSaved()
  if saved[SAVE_NAME] then
    local parsed, err = loadstring('return ' .. saved[SAVE_NAME])
    if parsed then
      M.data = mergeTable(M.data, parsed())
    else
      print('failed to deserialize save data')
      print(err)
    end
  else
    print('savedata not found; resetting to defaults')
  end
end
function M.save()
  local saved = PROFILEMAN:GetMachineProfile():GetSaved()
  saved[SAVE_NAME] = pretty(M.data)
  PROFILEMAN:SaveMachineProfile()
end

if not LITE then
  M.load()
end

return M