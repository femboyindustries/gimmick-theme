local options = require 'gimmick.options'
local stack   = require 'gimmick.stack'
local mascots = require 'gimmick.mascots'

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

---@param screen string
---@param name string
---@param value string?
local function screenButton(screen, name, value)
  return options.option.button(name, value or name, function()
    setOptions(screen)
  end)
end

---@param screen string
---@param name string
---@param value string?
---Like screenButton but can go to any screen
local function arbitraryScreen(screen, name, value)
  return options.option.button(name, value or name, function()
    delayedSetScreen(screen)
  end)
end

---@type table<string, Option[]>
local optionsTable = {
  root = {
    {
      type = 'lua',
      optionRow = screenButton('graphic', 'Graphic Options'),
    },
    {
      type = 'lua',
      optionRow = screenButton('gameplay', 'Gameplay Options'),
    },
    {
      type = 'lua',
      optionRow = screenButton('gimmick', 'Gimmick Options'),
    },
    {
      type = 'lua',
      optionRow = screenButton('system', 'System Options')
    },
    --[[
    {
      type = 'lua',
      optionRow = screenButton('gayzone', 'gay zone', 'Enter... if you dare...'),
    },
    ]]

    {
      type = 'lua',
      optionRow = options.option.button('Config Key/Joy Mappings', 'Config Key/Joy Mappings', function()
        delayedSetScreen('ScreenMapControllers')
      end),
    },
    {
      type = 'lua',
      optionRow = options.option.button('Reload Songs/Courses', 'Reload', function()
        delayedSetScreen('ScreenReloadSongs')
      end),
    },
  },
  arcade = {
    { type = 'conf', pref = 'CoinMode' },
    { type = 'conf', pref = 'CoinsPerCredit' },
    { type = 'conf', pref = 'Premium' },
    { type = 'conf', pref = 'EventMode' },
    --{ type = 'lua', optionRow = PlayModeType() },
    { type = 'conf', pref = 'SongsPerPlay' },
    --{ type = 'lua', optionRow = SessionTimer() },
    --{ type = 'lua', optionRow = CutOffTime() },
    { type = 'conf', pref = 'AttractSoundFrequency' },
    { type = 'conf', pref = 'MenuTimer' },
    --I moved the AspectRatio to graphic options because why the hell would that be in Arcade options
    --same with Life Difficulty
    { type = 'conf', pref = 'SoloSingles' },
    { type = 'conf', pref = 'AllowExtraStage' },
    { type = 'conf', pref = 'PickExtraStage' },
    { type = 'conf', pref = 'UnlockSystem' },
    --{ type = 'lua', optionRow = NonCombos() },
    --{ type = 'lua', optionRow = DQ() },
    --{ type = 'lua', optionRow = Merciful() },
    --{ type = 'lua', optionRow = EnableGhostData(0) },
  },
  graphic = {
    {
      type = 'lua',
      optionRow = screenButton('theme', 'Set Theme'),
    },
    { type = 'conf', pref = 'Windowed' },
    { type = 'conf', pref = 'AspectRatio' },
    --{ type = 'conf', pref = 'DisplayResolution' }, --why was this commented out
    -- because it forcefully sets your resolution upon exiting to different values than you had when going in
    { type = 'conf', pref = 'DisplayColor' },
    { type = 'conf', pref = 'TextureColor' },
    { type = 'conf', pref = 'MovieColor' },
    { type = 'conf', pref = 'SmoothLines' },
    { type = 'conf', pref = 'CelShadeModels' },
    { type = 'conf', pref = 'DelayedTextureDelete' },
    { type = 'conf', pref = 'RefreshRate' },
    { type = 'conf', pref = 'Vsync' },
    { type = 'conf', pref = 'ShowStats' },
    { type = 'conf', pref = 'ShowBanners' },
  },
  gameplay = {
    { type = 'conf', pref = 'DefaultFailType' },
    { type = 'conf', pref = 'SoloSingles' },
    { type = 'conf', pref = 'HiddenSongs' },
    { type = 'conf', pref = 'EasterEggs' },
  },
  system = {
    { type = 'conf', pref = 'SoundVolume' },
    { type = 'conf', pref = 'LifeDifficulty' },
    { type = 'conf', pref = 'Brightness' },
    {
      type = 'lua',
      optionRow = screenButton('arcade', 'Arcade Options'),
    }, 
  },
  theme = {
    ---@param ctx Context
    overlay = function(self, ctx)
      local wait = ctx:Sprite('Graphics/wait.png')
      wait:xy(scx, scy + 50)

      return function()
        wait:Draw()
      end
    end,
    { type = 'conf', pref = 'Theme' },
  },
  gayzone = {
    {
      type = 'lua',
      optionRow = options.option.button('meowwwww', 'mrowwwww', function()
        SCREENMAN:SystemMessage('paws at u')
        stallOptions()
      end)
    }
  },
  gimmick = {
    {
      type = 'lua',
      optionRow = options.option.settingChoice('Console Layout', 'console_layout', keys(require 'gimmick.lib.layouts')),
    },
    {
      type = 'lua',
      optionRow = options.option.settingToggle('Prevent Stretching', 'prevent_stretching'),
    },
    {
      type = 'lua',
      optionRow = options.option.settingToggle('Mascot Enabled','mascot_enabled')
    },
    {
      type = 'lua',
      optionRow = arbitraryScreen('ScreenSelectMascot', 'Select Mascot'),
    }, 
    {
      type = 'lua',
      optionRow = options.option.settingToggle('Enable Blur', 'do_blur'),
    },
  },
}

event.on('press', function(pn, btn)
  -- hacky workaround to esc being broken
  if SCREENMAN:GetTopScreen():GetName() == 'ScreenOptionsMenu' and optionsStack:top() and btn == 'Back' then
    print('Popping stack forcefully: ' .. optionsStack:pop())
    if not optionsStack:top() then
      SCREENMAN:SetNewScreen('ScreenTitleMenu')
    end
  end
end)

return {
  overlay = gimmick.ActorScreen(function(self, ctx)
    local opts = optionsStack:top()
    local res = optionsTable[opts]

    local drawOverlay = nil

    if res and res.overlay then
      drawOverlay = res.overlay(self, ctx)
    end

    --local testText = ctx:BitmapText('common','Fart')


    self:SetDrawFunction(function()
      if drawOverlay then drawOverlay() end
    end)
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
  resetStack = function()
    if optionsStack:top() then
      print('Clearing options stack due to premature exit')
      optionsStack:clear()
    end
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
    local res = optionsTable[opts]
    if not res then
      print('Invalid options screen: ' .. opts)
      optionsStack:clear()
      opts = 'root'
      optionsStack:push(opts)
      res = optionsTable[opts]
    end
    return res
  end),

}