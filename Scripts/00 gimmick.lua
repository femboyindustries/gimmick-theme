-- kinda luxurious of OpenITG to hand us plain Lua files instead of XML for 
-- these

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
  ---@type { [1]: string, type: TokenType }[][]
  local msg = {}
  for _, val in ipairs(arg) do
    if type(val) ~= 'string' and paw.prettyColored then
      table.insert(msg, paw.prettyColored(val, { maxWidth = 80, maxDepth = 5 }))
    else
      table.insert(msg, {{ tostring(val) }})
    end
  end
  if USING_WINE then
    local msgPlain = {}
    for _, part in ipairs(msg) do
      local str = {}
      for _, token in ipairs(part) do
        local code = '0'
        if token.type == TokenType.Collapsed then
          code = '90'
        elseif token.type == TokenType.Plain or token.type == TokenType.Parens then
          code = '39'
        elseif token.type == TokenType.Number then
          code = '33'
        elseif token.type == TokenType.Ref then
          code = '35'
        elseif token.type == TokenType.String then
          code = '32'
        elseif token.type == TokenType.Value then
          code = '31'
        end
        table.insert(str, '\27[' .. code .. 'm')
        table.insert(str, token[1])
      end
      table.insert(msgPlain, table.concat(str, ''))
    end
    Debug('\27[0m\27[32m[GIMMICK]\27[0m ' .. table.concat(msgPlain, '\t') .. '\27[0m')
  end

  local msgPlain = {}
  for _, part in ipairs(msg) do
    local str = {}
    for _, token in ipairs(part) do
      table.insert(str, token[1])
    end
    table.insert(msgPlain, table.concat(str, ''))
  end

  if not USING_WINE then
    Debug('[GIMMICK] ' .. table.concat(msgPlain, '\t'))
  end
  --if event then event:call('log', table.concat(msgPlain, ' ')) end
end
-- 🐾🐾🐾
paw.print = gimmick.print

function gimmick.warn(msg)
  print('WARN: ' .. msg)
  event:call('warn', msg)
end
paw.warn = gimmick.warn

paw.screeninfo = function()
  --paws at You are using an outdated NotITG version ( hello bro
  print(actorToString(SCREENMAN:GetTopScreen()))
  return "i dont know why return doesnt get shown and returning the function is an infinite loop, ill figure this out later"
end


print('Hello! running gimmick ' .. gimmick._VERSION)

-- Whether this is a pre-run; more specifically, whether DISPLAY is not defined.
LITE = false
if not DISPLAY then
  print(' DISPLAY is not defined, meaning we\'re in a "pre-run" stage of sorts.')
  print(' Load will still proceed as normal, since this is necessary for OverlayScreens,')
  print(' but certain functionality will be disabled.')

  LITE = true
end

-- borrowing some loading code directly from stitch

local folder = '/' .. THEME:GetCurThemeName() .. '/'
local addFolder = string.lower(PREFSMAN:GetPreference('AdditionalFolders'))

-- adapted from mirin template

gimmick.package = {
  search = './themes' .. folder .. ';' .. string.gsub(addFolder, ',', '/themes' .. folder .. ';') .. '/themes' .. folder,
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
      for prefix in string.gfind(gimmick.package.search, '[^;]+') do
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
if tonumber(versionDate) < MIN_SUPPORTED_VER and not LITE then
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