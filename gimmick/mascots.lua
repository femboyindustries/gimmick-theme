local M = {}

local mascots = require 'mascots'

---@param name string Name of the mascot
function M.getPaths(name)
  -- Only proceed if the mascot name exists in the index
  if not mascots[name] then
    print("Mascot not found in index: ", name)
    return nil
  end

  local bgs = getFolderContents(MASCOT_FOLDER .. MASCOT_SUBFOLDERS['backgrounds'], true)
  local chars = getFolderContents(MASCOT_FOLDER .. MASCOT_SUBFOLDERS['characters'], true)

  local found_bg = search(bgs, mascots[name]['background'])
  local found_char = search(chars, mascots[name]['character'])

  -- Ensure both background and character are found
  if not found_bg or not found_char then
    print("Missing files for the mascot.")
    return nil
  end

  --look at me jill im doing the table.concat!!!
  local bgPath = table.concat({MASCOT_FOLDER, MASCOT_SUBFOLDERS['backgrounds'], bgs[found_bg]}, "")
  local charPath = table.concat({MASCOT_FOLDER, MASCOT_SUBFOLDERS['characters'], chars[found_char]}, "")

  return {
    background = bgPath,
    character = charPath
  }
end

function M.getMascots()
  return keys(mascots)
end

return M