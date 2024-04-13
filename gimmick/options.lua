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
---@field LoadSelections (fun(self: OptionRow, selected: table<number, boolean>))
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

---@alias Option { type: 'lua', optionRow: OptionRow } | { type: 'conf', pref: string } | { type: 'list', list: string }

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
    end
  end)

  return {
    LineNames = function()
      command:reset()
      return string.sub(string.rep(',1', #optionsGetter()), 2)
    end,
    Line1 = command,
    option = function(n)
      return optionsGetter()[n].optionRow
    end,
  }
end

return M