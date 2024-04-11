function gimmick.saveInit()
  local data = PROFILEMAN:GetMachineProfile():GetSaved()
  if not data.theme_gimmick then
    data.theme_gimmick = {}
    PROFILEMAN:SaveMachineProfile()
  end
  return true
end

---Saves a setting or other to the Profile
function gimmick.ezSave(key,data)
  local saved = PROFILEMAN:GetMachineProfile():GetSaved()
  if not saved.theme_gimmick then
    gimmick.saveInit()
  else 
    saved.theme_gimmick[key] = data
  end
end

---returns the Theme's save data
---@return table
function gimmick.getSaved()
  return PROFILEMAN:GetMachineProfile():GetSaved().theme_gimmick
end

---😢
function gimmick.OptionRowBase(name,modList)
	local t = {
		Name = name or 'Unnamed Options',
		LayoutType = (ShowAllInRow and 'ShowAllInRow') or 'ShowOneInRow',
		SelectType = 'SelectOne',
		OneChoiceForAllPlayers = true,
		ExportOnChange = true,
		Choices = modList or {'Off','On'},
		LoadSelections = function(self, list, pn)  end,
		SaveSelections = function(self, list, pn)	 end
	}
	return t
end

---Get saved data by its key
---@param key string
---@return mixed
function gimmick.getSavedOption(key)
  -- Usually the save data is initialized before this function is called
  -- ...but for some reason the InitCommand in ScreenOptions menu is called after this function.
  -- This check is to make sure that tbl is not nil. Am I stupid? Probably. -rya
  local tbl = gimmick.getSaved() or (gimmick.saveInit() and gimmick.getSaved())
  if not tbl[key] then
    paw.print('Could not find Option '..key)
    SCREENMAN:SystemMessage('Could not find Option '..key)
    return false
  end
  
  return tbl[key]
end