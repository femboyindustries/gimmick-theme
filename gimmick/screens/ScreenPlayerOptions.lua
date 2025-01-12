local options = require 'gimmick.options'
local stack   = require 'gimmick.stack'
local OptionsRenderer = require 'gimmick.optionsRenderer'
local player          = require 'gimmick.player'

local optionsStack = stack.new()
local stackLocked = true

local function setOptions(name)
  optionsStack:push(name)
  delayedSetScreen('ScreenPlayerOptions')
  stackLocked = true
  print('Pushing to stack: ' .. name)
end
local function stallOptions()
  delayedSetScreen('ScreenPlayerOptions')
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
      optionRow = options.option.mods('Turn', {'SmartBlender','SoftShuffle','Mirror','SwapLeftRight','SwapUpDown','SpookyShuffle'}, false, false, true)
    },
    {
      type = 'lua',
      optionRow = options.option.mod('xmusic'),
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'Bumpscosity',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectOne',
        Choices = { '1.00', '1.05', '1.10', '1.15', '1.20', '1.25', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = options.option.mods('Columnswaps', {'MetaFlip', 'MetaInvert', 'MetaVideogames', 'MetaMonocolumn'}),
    },
    {
      type = 'lua',
      optionRow = options.option.mods('Arrows', {'MetaReverse', 'MetaDizzy', 'MetaOrient', 'MetaBrake'}),
    },
    {
      type = 'lua',
      optionRow = options.option.mods('Appear', {'MetaHidden'}),
    },
    {
      type = 'lua',
      optionRow = options.option.mod('MetaStealth'),
    },
    {
      type = 'lua',
      optionRow = options.option.mods('Noteskin', NOTESKIN:GetNoteSkinNames(), true, true)
    },
    -- todo make some like option.choice equivalent that doesn't need you to
    -- specify save/load with such utter verbosity
    {
      type = 'lua',
      optionRow = options.option.choice('Judgments', player.getJudgements(), function(self, selected, pn)
        local data = save.getPlayerData(pn + 1)
        for i, judge in ipairs(self.Choices) do
          if judge == data.judgment_skin then
            selected[i] = true
            return
          end
        end
        selected[1] = true
      end, function(self, selected, pn)
        local data = save.getPlayerData(pn + 1)
        for i, sel in ipairs(selected) do
          if sel then
            data.judgment_skin = self.Choices[i]
            return
          end
        end
        data.judgment_skin = self.Choices[1]
      end, false, false)
    },
    {
      type = 'lua',
      optionRow = options.option.choice('Judgment Tween', map(player.judgmentTweens, function(t) return t.name end), function(self, selected, pn)
        local data = save.getPlayerData(pn + 1)
        for i, tween in ipairs(self.Choices) do
          if tween == data.judgment_tween then
            selected[i] = true
            return
          end
        end
        selected[1] = true
      end, function(self, selected, pn)
        local data = save.getPlayerData(pn + 1)
        for i, sel in ipairs(selected) do
          if sel then
            data.judgment_tween = self.Choices[i]
            return
          end
        end
        data.judgment_tween = self.Choices[1]
      end, false, false)
    },
    {
      type = 'lua',
      optionRow = options.option.choice('Combo Tween', map(player.comboTweens, function(t) return t.name end), function(self, selected, pn)
        local data = save.getPlayerData(pn + 1)
        for i, tween in ipairs(self.Choices) do
          if tween == data.combo_tween then
            selected[i] = true
            return
          end
        end
        selected[1] = true
      end, function(self, selected, pn)
        local data = save.getPlayerData(pn + 1)
        for i, sel in ipairs(selected) do
          if sel then
            data.combo_tween = self.Choices[i]
            return
          end
        end
        data.combo_tween = self.Choices[1]
      end, false, false)
    },
    {
      type = 'lua',
      optionRow = options.option.choice('Hold Judgment Tween', map(player.holdJudgmentTweens, function(t) return t.name end), function(self, selected, pn)
        local data = save.getPlayerData(pn + 1)
        for i, tween in ipairs(self.Choices) do
          if tween == data.hold_judgment_tween then
            selected[i] = true
            return
          end
        end
        selected[1] = true
      end, function(self, selected, pn)
        local data = save.getPlayerData(pn + 1)
        for i, sel in ipairs(selected) do
          if sel then
            data.hold_judgment_tween = self.Choices[i]
            return
          end
        end
        data.hold_judgment_tween = self.Choices[1]
      end, false, false)
    },
    {
      type = 'lua',
      optionRow = options.option.mod('XMod'),
    },
    {
      type = 'lua',
      optionRow = options.option.mod('Mini'),
    },
    {
      type = 'lua',
      optionRow = options.option.mods('Perspective', {'Overhead','Hallway','Distant','Incoming','Space'}, true)
    },
  },
}

local function optionsGetter()
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
end

return {
  options = OptionsRenderer.OptionsRenderer(),

  overlay = gimmick.ActorScreen(function(self, ctx, scope)
    local opts = optionsStack:top()
    local res = optionsTable[opts]

    local drawOverlay = nil

    if res and res.overlay then
      drawOverlay = res.overlay(self, ctx)
    end

    self:SetDrawFunction(function()
      if drawOverlay then
        drawOverlay()
      end
    end)

    --local testText = ctx:BitmapText('common','Fart')
    OptionsRenderer.init(ctx, scope, optionsGetter)

    scope.event:on('press', function(pn, btn)
      -- hacky workaround to esc being broken
      if optionsStack:top() and btn == 'Back' then
        print('Popping stack forcefully: ' .. optionsStack:pop())
        if not optionsStack:top() then
          SCREENMAN:SetNewScreen('ScreenSelectMusic')
        end
      end
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
    --local bg = ctx:Sprite('Graphics/_missing')
    --bg:scaletocover(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
  end),
  --header = gimmick.ActorScreen(function(self, ctx)
  --end),
  --footer = gimmick.ActorScreen(function(self, ctx)
  --end),

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
      return 'ScreenPlayerOptions'
    else
      print('Options stack empty, leaving options menu')
      return 'ScreenBranchStage'
    end
  end,

  lines = options.LineProvider('ScreenPlayerOptions', optionsGetter),

}