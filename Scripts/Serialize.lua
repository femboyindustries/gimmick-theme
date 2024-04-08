-- Serialize the table "t".
function Serialize(t)
	local ret = ""
	local queue = { }
	local already_queued = { }

	-- Convert a value to an identifier.  If we encounter a table that we've never seen before,
	-- it's an anonymous table and we'll create a name for it; for example, in t = { [ {10} ] = 1 },
	-- "{10}" has no name.
	local next_id = 1
	local function convert_to_identifier( v, name )
		-- print("convert_to_identifier: " .. (name or "nil"))
		if type(v) == "string" then
			return string.format("%q", v)
		elseif type(v) == "nil" then
			return "nil"
		elseif type(v) == "boolean" then
			if v then return "true" end
			return "false"
		elseif type(v) == "number" then
			return string.format("%i", v)
		elseif type(v) == "table" then
			if already_queued[v] then
				return already_queued[v]
			end

			-- Create the table.  If we have no name, give it one; be sure to make it local.
			if not name then
				name = "tab" .. next_id
				next_id = next_id + 1
				ret = ret .. "local " .. name .. " = { }\n"
			else
				-- The name is probably something like "x[1][2][3]", so don't emit "local".
				ret = ret .. name .. " = { }\n"
			end

			for i, tab in pairs(v) do
				local to_fill = { ["name"] = name .. "[" .. convert_to_identifier(i) .. "]", with = tab }
				table.insert( queue, to_fill )
			end

			already_queued[v] = name
			return name
		else
			return '"UNSUPPORTED TYPE (' .. type(v) .. ')"', true
		end
	end

	local top_name = convert_to_identifier( t )
 
	while table.getn(queue) > 0 do
		local to_fill = table.remove( queue, 1 )
		local str = convert_to_identifier( to_fill.with, to_fill.name )
		-- Assign the result.  If to_fill.with is a non-anonymous table, we just created
		-- it ("ret[1] = { }"); don't redundantly write "ret[1] = ret[1]".
		if to_fill.name ~= str then
			ret = ret .. to_fill.name .. " = " .. str .. "\n"
		end
	end
	ret = ret .. "return " .. top_name
	return ret
end

-- (c) 2005 Glenn Maynard
-- All rights reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, and/or sell copies of the Software, and to permit persons to
-- whom the Software is furnished to do so, provided that the above
-- copyright notice(s) and this permission notice appear in all copies of
-- the Software and that both the above copyright notice(s) and this
-- permission notice appear in supporting documentation.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
-- THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
-- INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
-- OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
-- OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.


-- kinda luxurious of OpenITG to hand us plain Lua files instead of XML for 
-- these

if not DISPLAY then
  Debug('Gimmick tried to load before DISPLAY is even available, suppressing load.')
  Debug('(This message is safe to ignore)')
  return
end

if _G.gimmick then
  -- already loaded. great!
  return _G.gimmick
end

local gimmick = {}

_G.gimmick = gimmick

gimmick._VERSION = '0.0'

-- do a mirin-like global sandbox

-- When called, modifies the current environment to `paw`.
-- When passed a function, makes that function's environment `paw`.
---@operator call : function
local paw = setmetatable({}, {
  -- if something isn't found in the table, fall back to a global lookup
  __index = _G,

  -- handle paw() calls to set the environment
  __call = function(self, f)
    setfenv(f or 2, self)
    return f
  end
})

_G.paw = paw

paw()

function gimmick.print(...)
  local msg = {}
  for _, val in ipairs(arg) do
    table.insert(msg, tostring(val))
  end
  Debug('[GIMMICK] ' .. table.concat(msg, '\t'))
end
-- 🐾🐾🐾
paw.print = gimmick.print

print('Hello! running gimmick ' .. gimmick._VERSION)

-- borrowing some loading code directly from stitch

local folder = '/' .. THEME:GetCurThemeName() .. '/'
local addFolder = string.lower(PREFSMAN:GetPreference('AdditionalFolders'))
local add = './themes' .. folder .. ';' .. string.gsub(addFolder, ',', '/themes' .. folder .. ';') .. '/themes' .. folder

-- adapted from mirin template

gimmick.package = {
  path = '?.lua;?/init.lua',
  preload = {},
  loaded = {},
  loaders = {
    function(modname)
      local preload = gimmick.package.preload[modname]
      return preload or ('no field package.preload[\''..modname..'\']')
    end,
    function(modname)
      local errors = {}
      -- get the filename
      local filename = string.gsub(modname, '%.', '/')
      for prefix in string.gfind(add, '[^;]+') do
        for path in string.gfind(gimmick.package.path, '[^;]+') do
          -- get the file path
          local filepath = prefix .. string.gsub(path, '%?', filename)
          -- check if file exists
          if not GAMESTATE:GetFileStructure(filepath) then
            table.insert(errors, 'no file \''..filepath..'\'')
          else
            local loader, err = loadfile(filepath)
            -- check if file loads properly
            if err then
              error(err, 3)
            elseif loader then
              return paw(loader)
            end
          end
        end
      end
      return table.concat(errors, '\n')
    end,
  },
}

function require(modname)
  local loaded = gimmick.package.loaded
  if not loaded[modname] then
    local errors = {'module \''..modname..'\' not found:'}
    local chunk
    for _, loader in ipairs(gimmick.package.loaders) do
      local result = loader(modname)
      if type(result) == 'string' then
        table.insert(errors, result)
      elseif type(result) == 'function' then
        chunk = result
        break
      end
    end
    if not chunk then
      error(table.concat(errors, '\n'), 2)
    end
    loaded[modname] = chunk()
    if loaded[modname] == nil then
      loaded[modname] = true
    end
  end
  return loaded[modname]
end

-- strictly for type checker purposes
gimmick.require = require

-- do a check for the NotITG version
--
-- we don't do an initial FUCK_EXE check because OpenITG would've already
-- errored from trying to parse this file's # usage. lol

local MIN_SUPPORTED_VER = 20220925

local versionDate = GAMESTATE:GetVersionDate()
if tonumber(versionDate) < MIN_SUPPORTED_VER then
  -- very dumb way to display an error as a dialog
  GAMESTATE:ApplyGameCommand(
    '%\n\n' ..
    'You are using an outdated NotITG version (' .. versionDate .. ')!!!\n' ..
    'Gimmick will only work with NotITG v4.3.0 onwards (>=' .. MIN_SUPPORTED_VER .. ').\n' ..
    'Things may break - you\'ve been warned!\n' .. '\n\n'
  )
  Debug('[GIMMICK] Unsupported NotITG version (expected >=' .. MIN_SUPPORTED_VER .. ', got ' .. versionDate .. '), proceeding anyways...')
end

require 'gimmick'

return gimmick