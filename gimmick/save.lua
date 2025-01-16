local player = require 'gimmick.player'

local M = {}

local SAVE_NAME = 'gimmick!'

---@alias gimmick.PlayerData { judgment_skin: string, judgment_tween: string, hold_judgment_skin: string, hold_judgment_tween: string, combo_tween: string, }

M.data = {
  settings = {
    console_layout = 'QwertyUS',
    mascot_enabled = false,
    mascot = 'default',
    prevent_stretching = true,
    do_blur = true,
    show_imap = false,
    show_bootup = false,
    bootup_duration = "7",
  },
  state = {
    console_history = {},
  },
  ---@type table<number, gimmick.PlayerData>
  players = {},
}

for pn = 1, 2 do
  ---@type gimmick.PlayerData
  M.data.players[pn] = {
    judgment_skin = 'Bold',
    judgment_tween = 'Simply Love',
    hold_judgment_skin = 'Simply Love',
    hold_judgment_tween = 'Simply Love',
    combo_tween = 'Simply Love',
  }
end

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

---@param pn number
---@return gimmick.PlayerData
function M.getPlayerData(pn)
  return M.data.players[(pn - 1) % 2 + 1]
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