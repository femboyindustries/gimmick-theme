local M = {}

local SAVE_NAME = 'gimmick!'

M.data = {
  settings = {
    console_layout = 'QwertyUS',
    prevent_stretching = true,
  },
}

M.defaults = deepcopy(M.data)

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

M.shouldSaveNextFrame = false

function M.saveNextFrame()
  M.shouldSaveNextFrame = true
end

local isDirty = false
function M.maskAsDirty()
  isDirty = true
end

function M.saveIfDirty()
  if isDirty then
    M.shouldSaveNextFrame = true
    isDirty = false
  end
end

if not LITE then
  M.load()
end

return M