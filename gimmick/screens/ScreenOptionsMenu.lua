local options = require 'gimmick.options'
local stack   = require 'gimmick.stack'

local optionsStack = stack.new()
local stackLocked = true

local function setOptions(name)
  optionsStack:push(name)
  delayedSetScreen('ScreenOptionsMenu')
  stackLocked = true
  print('Pushing to stack: ' .. name)
end
local function stallOptions()
  delayedSetScreen('ScreenOptionsMenu')
  stackLocked = true
end

---@type table<string, Option[]>
local optionsTable = {
  root = {
    {
      type = 'lua',
      optionRow = options.option.settingChoice('Console Layout', 'console_layout', keys(require 'gimmick.lib.layouts')),
    },
    {
      type = 'conf',
      pref = 'SoundVolume',
    },
    {
      type = 'conf',
      pref = 'AspectRatio',
    },
    {
      type = 'conf',
      pref = 'EventMode',
    },
    {
      type = 'lua',
      optionRow = options.option.button('Button that creates a SystemMessage that says "penis"', 'Button that creates a SystemMessage that says "penis"', function()
        SCREENMAN:SystemMessage('penis')
        stallOptions()
      end)
    },
    {
      type = 'lua',
      optionRow = options.option.button('gay zone', 'Enter... if you dare...', function()
        setOptions('gayzone')
      end)
    }
  },
  gayzone = {
    {
      type = 'lua',
      optionRow = options.option.button('meowwwww', 'mrowwwww', function()
        SCREENMAN:SystemMessage('paws at u')
        stallOptions()
      end)
    }
  }
}

return {
  overlay = gimmick.ActorScreen(function(self, ctx)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
    local bg = ctx:Sprite('Graphics/_missing')
    bg:scaletocover(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),

  unlockStack = function()
    stackLocked = false
  end,

  NextScreen = function()
    if not stackLocked then
      print('Popping stack: ' .. optionsStack:pop())
      stackLocked = true
    end
    if optionsStack:top() then
      return 'ScreenOptionsMenu'
    else
      print('Options stack empty, leaving options menu')
      return 'ScreenTitleMenu'
    end
  end,

  --- El soyjak
  lines = options.LineProvider('ScreenOptionsMenu', function()
    local opts = optionsStack:top()
    if not opts then
      print('Initializing options stack')
      opts = 'root'
      optionsStack:push(opts)
    end
    return optionsTable[opts]
  end),
}
