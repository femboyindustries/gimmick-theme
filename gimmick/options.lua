-- handles options (like in ScreenOptionsMenu)

local M = {}

---@alias LayoutType 'ShowAllInRow' | 'ShowOneInRow'
---@alias SelectType 'SelectOne' | 'SelectMultiple' | 'SelectNone'

M.option = {}

---@class OptionRow
---@field Name string
---@field OneChoiceForAllPlayers boolean?
---@field ExportOnChange boolean?
---@field LayoutType LayoutType
---@field SelectType SelectType
---@field Choices string[]
---@field EnabledForPlayers (0 | 1)[]?
---@field ReloadRowMessages string[]?
---@field LoadSelections (fun(self: OptionRow, selected: table<number, boolean>, pn: number))
---@field SaveSelections (fun(self: OptionRow, selected: table<number, boolean>, pn: number))

---@param name string
---@param layoutType LayoutType
---@param selectType SelectType
---@param choices string[]
---@return OptionRow
function M.option.base(name, layoutType, selectType, choices, load, save)
  return {
    Name = name,
    LayoutType = layoutType,
    SelectType = selectType,
    Choices = choices,
    OneChoiceForAllPlayers = true,
    ExportOnChange = true,
    LoadSelections = load,
    SaveSelections = save,
  }
end

---@param name string
---@param choices string[]
---@param showAll boolean?
---@return OptionRow
function M.option.choice(name, choices, load, save, showAll)
  if showAll == nil then showAll = true end
  return M.option.base(name, showAll and 'ShowAllInRow' or 'ShowOneInRow', 'SelectOne', choices, load, save)
end

---@param name string
---@return OptionRow
function M.option.toggle(name, load, save)
  return M.option.base(name, 'ShowAllInRow', 'SelectOne', {'ON', 'OFF'}, load, save)
end

---@param name string
---@param key string
---@return OptionRow
function M.option.settingToggle(name, key)
  return M.option.toggle(name, function(self, selected)
    local option = save.data.settings[key] and 1 or 2
    selected[option] = true
  end, function(self, selected, pn)
    save.data.settings[key] = selected[1] -- 'ON'
    save.maskAsDirty()
  end)
end
---@param name string
---@param key string
---@param choices string[]
---@param showAll boolean?
---@return OptionRow
function M.option.settingChoice(name, key, choices, showAll)
  local default = search(choices, save.defaults.settings[key]) or 1
  return M.option.choice(name, choices, function(self, selected)
    local optI = search(choices, save.data.settings[key]) or default
    selected[optI] = true
  end, function(self, selected, pn)
    local optI = search(selected, true) or default
    save.data.settings[key] = choices[optI]
    save.maskAsDirty()
  end, showAll)
end
---@param name string
---@param value string
---@param onPress fun(pn: number)
---@return OptionRow
function M.option.button(name, value, onPress)
  return M.option.base(name, 'ShowAllInRow', 'SelectNone', {value}, function() end, function(self, selected, pn)
    if selected[1] then
      onPress(pn)
    end
  end)
end

local function applyMod(mod, pn, f)
  local m = mod
  if m then
    if f then
      m = f .. '% ' .. m
    end
    GAMESTATE:ApplyModifiers(m, pn)
  end
end

---@alias ModEntry { name?: string } | ({ type: 'bool' } | { type: 'float', step?: number } | { type: 'select', values: number[] })
---@type table<string, ModEntry>
local modRegistry = {}

---@param modName string
local function modOptionRow(modName)
  local origModName = modName
  modName = string.lower(modName)
  local entry = modRegistry[modName]

  if not entry then
    entry = { type = 'bool' }
    gimmick.warn('mod name \'' .. modName .. '\' unrecognized, defaulting to bool')
  end

  if entry.type == 'bool' then
    return M.option.toggle(entry.name or origModName, function(self, selected, pn)
      local enabled = GAMESTATE:PlayerIsUsingModifier(pn, modName)
      selected[enabled and 1 or 2] = true
    end, function(self, selected, pn)
      if selected[2] then
        applyMod(modName, pn+1)
        applyMod(modName, pn+3)
        applyMod(modName, pn+5)
        applyMod(modName, pn+7)
      else
        applyMod('no ' .. modName, pn+1)
        applyMod('no ' .. modName, pn+3)
        applyMod('no ' .. modName, pn+5)
        applyMod('no ' .. modName, pn+7)
      end
    end)
  elseif entry.type == 'float' then

  elseif entry.type == 'select' then

  end
end

---@alias Option { type: 'lua', optionRow: OptionRow, y: number? } | { type: 'conf', pref: string, y: number? } | { type: 'list', list: string, y: number? } | { type: 'mod', modName: string, y: number? }

local ROWS_SHOWN = 10
local HEIGHT = 300

---@param screenName string
---@param optionsGetter fun(): Option[]
function M.LineProvider(screenName, optionsGetter)
  local command = iterFunction(function(n)
    local opt = optionsGetter()[n]

    if opt.type == 'lua' then
      -- terrible, but oh well
      return 'lua,gimmick.s.' .. screenName .. '.lines.option(' .. n .. ')'
    elseif opt.type == 'conf' then
      return 'conf,' .. opt.pref
    elseif opt.type == 'list' then
      return 'list,' .. opt.list
    elseif opt.type == 'mod' then
      return 'lua,gimmick.s.' .. screenName .. '.lines.mod(' .. n .. ')'
    end
  end)

  local t = {
    LineNames = function()
      command:reset()
      return string.sub(string.rep(',1', #optionsGetter()), 2)
    end,
    Line1 = command,
    option = function(n)
      local option = optionsGetter()[n]
      assert(option.optionRow, 'option #' .. n .. ' type specified to be \'option\', but no \'optionRow\' exists!')
      return option.optionRow
    end,
    mod = function(n)
      local option = optionsGetter()[n]
      print(option)
      assert(option.modName, 'option #' .. n .. ' type specified to be \'mod\', but no \'modName\' exists!')
      return modOptionRow(option.modName)
    end,
    NumRowsShown = function()
      return ROWS_SHOWN
    end,
  }

  -- todo this is ugly
  for i = 1, 99 do
    local i = i
    t['Row' .. i .. 'Y'] = function()
      local opt = optionsGetter()[i]
      if opt and opt.y then
        return opt.y
      end

      local rowHeight = HEIGHT / ROWS_SHOWN

      return scy - (rowHeight * math.min(#optionsGetter(), ROWS_SHOWN))/2 + rowHeight * (i - 1)
    end
  end

  return t
end

return M