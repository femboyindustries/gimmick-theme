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
function M.option.base(name, layoutType, selectType, choices, oneChoiceForAllPlayers, load, save)
  if oneChoiceForAllPlayers == nil then
    oneChoiceForAllPlayers = true
  end
  return {
    Name = name,
    LayoutType = layoutType,
    SelectType = selectType,
    Choices = choices,
    OneChoiceForAllPlayers = oneChoiceForAllPlayers,
    ExportOnChange = true,
    LoadSelections = load,
    SaveSelections = save,
  }
end

---@param name string
---@param choices string[]
---@param showAll boolean?
---@param oneChoiceForAllPlayers boolean?
---@return OptionRow
function M.option.choice(name, choices, load, save, showAll, oneChoiceForAllPlayers)
  if showAll == nil then showAll = true end
  return M.option.base(name, showAll and 'ShowAllInRow' or 'ShowOneInRow', 'SelectOne', choices, oneChoiceForAllPlayers, load, save)
end

---@param name string
---@param oneChoiceForAllPlayers boolean?
---@return OptionRow
function M.option.toggle(name, load, save, oneChoiceForAllPlayers)
  return M.option.base(name, 'ShowAllInRow', 'SelectOne', {'ON', 'OFF'}, oneChoiceForAllPlayers, load, save)
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
  end, true)
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
  end, showAll, true)
end
---@param name string
---@param value string
---@param onPress fun(pn: number)
---@return OptionRow
function M.option.button(name, value, onPress)
  return M.option.base(name, 'ShowAllInRow', 'SelectNone', {value}, true, function() end, function(self, selected, pn)
    if selected[1] then
      onPress(pn)
    end
  end)
end

local function applyMod(mod, pn, f)
  for p = pn, pn + 6, 2 do
    local m = mod
    if m then
      if f then
        m = f .. '% ' .. m
      end
      GAMESTATE:ApplyModifiers(m, p)
    end
  end
end

---@alias ModEntry { name?: string, default?: number, asOnePlayer: boolean? } | ({ type: 'bool' } | { type: 'float', step?: number, start?: number, stop?: number } | { type: 'select', values: number[] } | { type: 'mod', str: string, format?: string, step?: number, start?: number, stop?: number })
---@type table<string, ModEntry>
local m = {}

m.stealth = { type = 'float', step = 25 }
m.metastealth = m.stealth

m.xmod = { type = 'mod', str = '%x', start = 0.5, stop = 4, step = 0.25, default = 1 }
m.mmod = { type = 'mod', str = 'm%', start = 0.5, stop = 4, step = 0.25, default = 1 }
m.cmod = { type = 'mod', str = 'c%', start = 0.5, stop = 4, step = 0.25, default = 1 }
m.xmusic = { name = 'Ratemod', type = 'mod', str = '%xmusic', format = '%x', start = 0.1, stop = 10, step = 0.1, default = 1, asOnePlayer = true }
m.mini = { type = 'float', start = 0, step = 25, stop = 200 }

---@param modName string
function M.option.mod(modName)
  local origModName = modName
  modName = string.lower(modName)
  local entry = m[modName]

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
      else
        applyMod('no ' .. modName, pn+1)
      end
    end, entry.asOnePlayer or false)
  elseif entry.type == 'float' or entry.type == 'mod' then
    local options = {}
    local default = 1
    for p = entry.start or 0, entry.stop or 100, entry.step or 25 do
      table.insert(options, p)
      if entry.default and math.abs(p - entry.default) < 0.01 then
        default = #options
      end
    end
    local optionsVisual = map(options, function(p)
      if entry.type == 'float' then
        return p .. '%'
      else
        return replace(entry.format or entry.str, '%', p)
      end
    end)
    return M.option.choice(entry.name or origModName, optionsVisual, function(self, selected, pn)
      local enabled = GAMESTATE:PlayerIsUsingModifier(pn, modName)
      -- todo: does not read set mod percentage
      selected[default or 1] = true
    end, function(self, selected, pn)
      for i, sel in ipairs(selected) do
        if sel then
          if entry.type == 'float' then
            applyMod(modName, pn+1, options[i])
          else
            applyMod(replace(entry.str, '%', options[i]), pn+1)
          end
        end
      end
    end, false, entry.asOnePlayer or false)
  elseif entry.type == 'choice' then
    error('choice: entry type not implemented')
  end
end
---@param name string
---@param modNames string[]
---@param onlyOne boolean?
---@param showOne boolean?
---@param asOnePlayer boolean?
function M.option.mods(name, modNames, onlyOne, showOne, asOnePlayer)
  return M.option.base(name, showOne and 'ShowOneInRow' or 'ShowAllInRow', onlyOne and 'SelectOne' or 'SelectMultiple', modNames, asOnePlayer or false, function(self, selected, pn)
    local isAnySelected = false
    for i, mod in ipairs(modNames) do
      local enabled = GAMESTATE:PlayerIsUsingModifier(pn, mod)
      selected[i] = enabled
      isAnySelected = isAnySelected or enabled
    end
    if onlyOne and not isAnySelected then
      selected[1] = true
    end
  end, function(self, selected, pn)
    for i, mod in ipairs(modNames) do
      if selected[i] then
        applyMod(mod, pn+1)
      else
        --applyMod('no ' .. mod, pn+1)
      end
    end
  end)
end

-- todo: `stepstype` and `steps`
---@alias Option { marginTop?: number, marginBottom?: number, overlay: fun(ctx: Context, scope: Scope): (fun(self: Option, selected: table<number, boolean>, pn: number, x: number, y: number): nil), onChange?: fun(scope: Scope, pn: number), showIndex?: boolean } | { type: 'lua', optionRow: OptionRow } | { type: 'conf', pref: string } | { type: 'list', list: string }

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
    NumRowsShown = function()
      return (#optionsGetter()) + 1
    end,
  }

  return t
end

return M