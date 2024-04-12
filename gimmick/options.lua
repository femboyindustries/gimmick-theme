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

function M.option.toggle(name, load, save)
  return M.option.base(name, 'ShowAllInRow', 'SelectOne', {'ON', 'OFF'}, load, save)
end

function M.option.settingToggle(name, key)
  return M.option.toggle(name, function(self, selected)
    local option = save.data.settings.console and 1 or 2
    selected[option] = true
  end, function(self, selected, pn)
    save.data.settings[key] = selected[1] -- 'ON'
    save.save()
  end)
end

---@param screenName string
---@param options OptionRow[]
function M.LineProvider(screenName, options)
  local command = iterFunction(function(n)
    -- terrible, but oh well
    return 'lua,gimmick.s.' .. screenName .. '.lines.option(' .. n .. ')'
  end)

  return {
    LineNames = function()
      command:reset()
      return string.sub(string.rep(',1', #options), 2)
    end,
    Line1 = command,
    option = function(n)
      return options[n]
    end,
  }
end

return M