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
      marginTop = 1,
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
      marginTop = 1,
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
      optionRow = options.option.mods('Noteskin', NOTESKIN:GetNoteSkinNames(), true, true),
      marginTop = 1,
      ---@param ctx Context
      ---@param scope Scope
      overlay = function(ctx, scope)
        local containers = {}
        ---@type Model[]
        local notes = {}
        for pn = 1, 2 do
          local container = ctx:ActorFrame()
          table.insert(containers, container)
          local note = ctx:Model('../../NoteSkins/dance/scalable/Down Tap Note 4th.model')
          table.insert(notes, note)
          ctx:addChild(container, note)
        end
        local shownSkin = { '', '' }

        return function(self, selected, pn, x, y)
          --[[local skin = self.Choices[1]
          for i, sel in ipairs(selected) do
            if sel then skin = self.Choices[i] break end
          end

          if skin ~= shownSkin[pn] then
            local model = FILEMAN:LoadIniFile('/NoteSkins/dance/' .. skin .. '/Down Tap Note 4th.model')
            if not model then
              model = FILEMAN:LoadIniFile('/NoteSkins/dance/default/Down Tap Note 4th.model')
            end
            if model and model.Model then
              if model.Model.Meshes then
                notes[pn]:LoadMilkshapeAscii(
                  '/NoteSkins/dance/' .. skin .. '/' .. model.Model.Meshes
                )
              end
              -- todo: do noteskins even use bones?
              --if model.Model.Materials then
              --  notes[pn]:LoadMilkshapeAsciiMaterials(
              --    '/NoteSkins/dance/' .. skin .. '/' .. model.Model.Materials
              --  )
              --end
            end
            notes[pn]:animate(0)
            shownSkin[pn] = skin
          end

          containers[pn]:xyz(x, y - 28, 500)
          containers[pn]:zoom(28/64)
          containers[pn]:Draw()]]
        end
      end,
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
      end, false, false),
      marginTop = 1,
      ---@param ctx Context
      ---@param scope Scope
      overlay = function(ctx, scope)
        local containers = {}
        local judgments = {}
        for pn = 1, 2 do
          local container = ctx:ActorFrame()
          table.insert(containers, container)
          local judgment = ctx:Sprite('Graphics/_missing')
          table.insert(judgments, judgment)
          ctx:addChild(container, judgment)
        end
        local shownJudge = { '', '' }

        scope.event:on('judge', function(pn, judge)
          judgments[pn]:finishtweening()
          local off = math.random(0, 1)
          judgments[pn]:setstate((5 - (judge - 3)) * 2 + off)
          player.onJudgment(judgments[pn], judge, pn)
        end)

        return function(self, selected, pn, x, y)
          local data = save.getPlayerData(pn)
          local judge = data.judgment_skin

          if judge ~= shownJudge[pn] then
            judgments[pn]:Load(
              THEME:GetPath(EC_GRAPHICS, '' , '_Judgments/' .. judge)
            )
            judgments[pn]:animate(0)
            shownJudge[pn] = judge
          end

          containers[pn]:xy(x, y - 28)
          containers[pn]:zoom(0.65)
          containers[pn]:Draw()
        end
      end,
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
      end, false, false),
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
      end, false, false),
      marginTop = 1,
      ---@param ctx Context
      ---@param scope Scope
      overlay = function(ctx, scope)
        local containers = {}
        local combos = {}
        local comboNum = { 6, 6 }
        for pn = 1, 2 do
          local container = ctx:ActorFrame()
          table.insert(containers, container)
          local combo = ctx:BitmapText('Numbers/Combo numbers', '00')
          player.initCombo(combo, true)
          table.insert(combos, combo)
          ctx:addChild(container, combo)
        end

        scope.event:on('judge', function(pn, judge)
          if judge == MISS or judge == DECENT or judge == WAYOFF then
            comboNum[pn] = 0
          else
            comboNum[pn] = comboNum[pn] + 1
          end

          local combo = comboNum[pn]
          if combo >= 1 then
            combos[pn]:hidden(0)
            combos[pn]:settext(lpad(tostring(combo), 2, '0'))
            player.onCombo(combos[pn], pn, combo)
          else
            combos[pn]:hidden(1)
          end
        end)

        return function(self, selected, pn, x, y)
          containers[pn]:xy(x, y - 28)
          containers[pn]:zoom(0.6)
          containers[pn]:Draw()
        end
      end,
    },
    {
      type = 'lua',
      optionRow = options.option.choice('Hold Judgments', player.getHoldJudgements(), function(self, selected, pn)
        local data = save.getPlayerData(pn + 1)
        for i, judge in ipairs(self.Choices) do
          if judge == data.hold_judgment_skin then
            selected[i] = true
            return
          end
        end
        selected[1] = true
      end, function(self, selected, pn)
        local data = save.getPlayerData(pn + 1)
        for i, sel in ipairs(selected) do
          if sel then
            data.hold_judgment_skin = self.Choices[i]
            return
          end
        end
        data.hold_judgment_skin = self.Choices[1]
      end, false, false),
      marginTop = 1,
      ---@param ctx Context
      ---@param scope Scope
      overlay = function(ctx, scope)
        local containers = {}
        local shownJudge = { '', '' }
        local judges = {}
        for pn = 1, 2 do
          local container = ctx:ActorFrame()
          table.insert(containers, container)
          local judge = ctx:Sprite('Graphics/_missing')
          judge:animate(0)
          table.insert(judges, judge)
          ctx:addChild(container, judge)
        end

        scope.event:on('judge', function(pn, judge)
          local miss = judge == MISS or judge == DECENT or judge == WAYOFF
          judges[pn]:setstate(miss and 1 or 0)
          player.onHoldJudgment(judges[pn], miss and HNS_NG or HNS_OK, pn)
        end)
  
        return function(self, selected, pn, x, y)
          local data = save.getPlayerData(pn)
          local judge = data.hold_judgment_skin

          if judge ~= shownJudge[pn] then
            judges[pn]:Load(
              THEME:GetPath(EC_GRAPHICS, '' , '_HoldJudgments/' .. judge)
            )
            judges[pn]:animate(0)
            shownJudge[pn] = judge
          end

          containers[pn]:xy(x, y - 28)
          containers[pn]:zoom(0.65)
          containers[pn]:Draw()
        end
      end,
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
      end, false, false),
    },
    {
      type = 'lua',
      optionRow = options.option.mod('XMod'),
      marginTop = 1,
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

    local hitTimer = 0
    setDrawFunctionWithDT(self, function(dt)
      hitTimer = hitTimer - dt
      if hitTimer < 0 then
        hitTimer = hitTimer + 1
        for pn = 1, 2 do
          local judge = pickWeighted({
            [FANTASTIC] = 1,
            [EXCELLENT] = 0.8,
            [GREAT] = 0.5,
            [WAYOFF] = 0.1,
            [DECENT] = 0.15,
            [MISS] = 0.3,
          })
          scope.event:call('judge', pn, judge)
        end
      end
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