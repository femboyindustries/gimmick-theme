local easable = require 'gimmick.lib.easable'
local MeterWheel = require 'gimmick.lib.meterWheel'
local barlib = require 'gimmick.bar'
local MusicWheel = require 'gimmick.screens.ScreenSelectMusic.MusicWheel'
local TextPool   = require 'gimmick.textpool'

local SelectOptionsPrompt = nil

return {
  OutDur = 2,

  MusicWheel = MusicWheel.MusicWheel(),
  Banner = {
    ---@param bn FadingBanner
    On = function(bn)
      bn:ztest(0)
      -- this is only vaguely better than magic numbers
      bn:xy((48 + 96 + 240)/2, 100)
      --bn:effectclock('bgm')
      --bn:wag()
    end
  },
  overlay = gimmick.ActorScreen(function(self, ctx, scope)
    MusicWheel.init(ctx)

    _QUIPS = {
      {"PLEASE", "WAIT"},
      {"GET","READY"},
      {"PREPARE","TO STEP"},
      {"\"SCHALL\"","WE STEP?"},
      {"","cheese"},
      {"NSERT", "POO KEY"},
      {"READY","UP"},
      {"TIME TO","STEP UP"},
      {"LET US","COMMENCE FORTH"},
      {"Whatever,","go my scarab"},
      {"TOP TEXT","BOTTOM TEXT"}
      
    }
    _QUIPS_INDEX = math.random(2,#_QUIPS)
    --_QUIPS_INDEX = 11

    

    

    local openAux = scope.tick:aux(0)
    openAux:ease(0, 0.5, outExpo, 1)
    scope.event:on('off', function()
       openAux:ease(0, 0.6, inBack, 0)
    end)

    local bar = barlib.new(ctx)
    local bar_af = bar.actorframe
    local bar_ease = scope.tick:easable(0,24)
    bar_af:xy(scx * 0.5, sh * 0.95)

    local wheel = MeterWheel.new(ctx, scope)
    
    local text = ctx:BitmapText(FONTS.sans_serif)
    text:shadowlength(0)
    text:zoom(0.35)
    local fold = ctx:Quad()

    local lockIcon = ctx:Sprite('gimmick/assets/lock.png')

    local quad = ctx:Quad()

    ---@type table<number, easable>
    local folds = {}

    local FOLD_BORDER = 6
    local FOLD_GAP = 6
    local TOTAL_FOLD_WIDTH = 240

    fold:align(0, 0.5)
    text:align(0, 0.5)

    local diffRepText = ctx:BitmapText(FONTS.sans_serif)
    diffRepText:zoom(0.4)
    diffRepText:rotationz(-90)
    diffRepText:shadowlength(0)
    local diffEase = scope.tick:easable(0, 8)

    local statR = TextPool.new(ctx, FONTS.sans_serif, nil, function(self) self:align(1, 0.5); self:zoom(0.28); self:shadowlength(0); self:diffuse(0.6, 0.6, 0.6, 1) end)
    local statL = TextPool.new(ctx, FONTS.sans_serif, nil, function(self) self:align(0, 0.5); self:zoom(0.32); self:shadowlength(0) end)

    local function chartStatsConf(elf)
      --haha elf

      --like the movie
      elf:zoom(0.28) elf:shadowlength(0)
    end

    local chartStatsLabel = TextPool.new(ctx,FONTS.sans_serif, 1, function (self) chartStatsConf(self) self:halign(1) end)
    local chartStatsValue = TextPool.new(ctx,FONTS.sans_serif, 1, function (self) chartStatsConf(self) self:halign(0) end)

    ---@type Song
    local song = nil
    ---@alias StepSet {[1]: number, [2]: Steps, locked: boolean}
    ---@type StepSet[]
    local steps = {}
    local difficulty = nil

    --local test = ctx:Sprite('Graphics/_missing.png')

    local doorAnim,settext1,settext2 = gimmick.common.doors(ctx, scope,nil,nil,SelectOptionsPrompt)

    setDrawFunctionWithDT(self, function(dt)
      MusicWheel.update(dt)
      MusicWheel.setOpen(openAux.value)

      local newSong = GAMESTATE:GetCurrentSong()
      if newSong ~= song then
        print('switch: ' .. (song and song:GetDisplayMainTitle() or ''))
        song = newSong
        local diffOffset = 0
        steps = {}
        difficulty = nil
        if song then
          for i, step in ipairs(song:GetAllSteps()) do
            local locked = false
            if UNLOCKMAN.StepsIsLocked and UNLOCKMAN:StepsIsLocked(song, step) then
              locked = true
            end
            table.insert(steps, { step:GetDifficulty() + diffOffset, step, locked = locked })
            if step:GetDifficulty() == DIFFICULTY_EDIT then
              -- there's no better way to keep track of multiple edits than this
              diffOffset = diffOffset + 1
            end
          end
        end
      end

      local selected = GAMESTATE:GetCurrentSteps(0)
      

      if selected and difficulty ~= selected:GetDifficulty() then
        difficulty = selected:GetDifficulty()
        MusicWheel.setDifficulty(difficulty)
        diffEase.eased = -1
      end

      if selected then
        bar_ease:set(selected:GetMeter() * 0.1)
        bar:set(bar_ease.eased)
      else
        bar_ease:set(0)
        bar:set(bar_ease.eased)
      end

      local x = 96
      fold:SetHeight(20)
      fold:skewx(-0.2)

      for _, v in pairs(folds) do
        v:set(0)
      end

      ---@type table<number, StepSet | { fake: boolean }>
      local renderSteps = {}

      for k in pairs(folds) do
        renderSteps[k] = { fake = true }
      end
      for k in pairs(DIFFICULTIES) do
        renderSteps[k] = { fake = true }
      end
      for _, stepSet in ipairs(steps) do
        renderSteps[stepSet[1]] = stepSet
      end

      for diffI = 0, (countKeys(renderSteps) - 1) do
        local step = renderSteps[diffI]
        local diff = DIFFICULTIES[diffI] or DIFFICULTIES[DIFFICULTY_EASY]

        folds[diffI] = folds[diffI] or easable(0)
        local w = folds[diffI]

        fold:diffuse(diff.color:unpack())
        if step.locked then
          fold:diffuse((diff.color * 0.6):unpack())
        end
        if (not step.fake) and step[2] == selected then
          local width = TOTAL_FOLD_WIDTH
          for diffI2, step2 in pairs(renderSteps) do
            if diffI ~= diffI2 then
              local w2 = folds[diffI2]
              width = width - (w2 and w2.eased or 0) - FOLD_GAP
            end
          end
          width = width + FOLD_GAP
          w:reset(width + FOLD_BORDER * 2)
          fold:SetWidth(w.eased)
          fold:xy(x, scy)
          fold:Draw()
          text:settext(step[2]:GetDescription())
          text:diffuse(0, 0, 0, 1)
          text:xy(x + FOLD_BORDER, scy)
          text:Draw()
        else
          if not step.fake then
            w:set(FOLD_BORDER * 2)
          end
          fold:SetWidth(w.eased)
          fold:xy(x, scy)
          fold:Draw()
          if step.locked then
            lockIcon:xy(x + w.eased/2, scy)
            local zoom = math.min(w.eased - 2, 16)
            lockIcon:diffuse(0, 0, 0, 1)
            lockIcon:zoomto(zoom, zoom)
            lockIcon:Draw()
          end
        end

        x = x + w.eased + clamp(w.eased / (FOLD_BORDER * 2), 0, 1) * FOLD_GAP
      end

      for _, v in pairs(folds) do
        v:update(dt * 16)
      end

      if selected then
        wheel:ease(selected:GetMeter(), selected:GetDifficulty())
        wheel:draw(48, scy)
      else
        wheel:set(0, nil)
      end

      if difficulty then
        local diff = DIFFICULTIES[difficulty]
        diffRepText:settext(string.upper(diff.name) .. ' // ')
        diffRepText:diffuse(diff.text:unpack())
        quad:diffuse(diff.color:unpack())
        stripes_color = diff.color
      else
        diffRepText:settext('SELECT A SONG // ')
        diffRepText:diffuse(0, 0, 0, 1)
        quad:diffuse(0.8, 0.8, 0.8, 1)
      end

      local barHeight = 32
      quad:xywh(sw - 16, scy, barHeight, sh)
      quad:Draw()

      bar_af:Draw()

      local textWidth = diffRepText:GetWidth() * diffRepText:GetZoomX()
      local startY = -((os.clock() * 16 + diffEase.eased * 32) % textWidth)
      for y = startY, sh + textWidth, textWidth do
        diffRepText:xy(sw - 16, y)
        diffRepText:Draw()
      end

      if song then
        local statX = 164
        local statY = 180
        do
          local label = statR:get('ARTIST')
          local value = statL:get(song:GetDisplayArtist())
          label:xy(statX, statY)
          label:Draw()
          value:xy(statX + 8, statY)
          value:Draw()
        end
        do
          local label = statR:get('LENGTH')
          local len = song:MusicLengthSeconds()
          local value = statL:get(formatTime(len))
          label:xy(statX, statY + 16)
          label:Draw()
          value:xy(statX + 8, statY + 16)
          value:Draw()
        end
        do
          local label = statR:get('BPM')
          local min = song:GetMinBPM()
          local max = song:GetMaxBPM()
           
          local str = tostring(math.floor(min))
          if min ~= max then
            str = tostring(math.floor(min)) .. ' - ' .. tostring(math.floor(max))
          end
          local value = statL:get(str)
          label:xy(statX, statY + 16 * 2)
          label:Draw()
          value:xy(statX + 8, statY + 16 * 2)
          value:Draw()
        end

        --probably not good for performance
        --whatever. i can optimize it later if needed
        local a1 = SCREENMAN()
        local a2 = a1(24)
        if a2 then
          local Pane = a2(2) --[[@as ActorFrame]]
          
          local numSteps = Pane('SongNumStepsText'):GetText()
          if numSteps then
            local stepLabel = chartStatsLabel:get('STEPS')
            local stepValue = chartStatsValue:get(numSteps)
            stepLabel:xy(scx*0.15,scy*1.3)
            stepValue:xy(scx*0.16,scy*1.3)

            stepLabel:Draw()
            stepValue:Draw()
          end
          
          local jumps = Pane('SongJumpsText'):GetText()
          if jumps then
            local jumpLabel = chartStatsLabel:get('JUMPS')
            local jumpValue = chartStatsValue:get(jumps)
            jumpLabel:xy(scx*0.15,scy*1.37)
            jumpValue:xy(scx*0.16,scy*1.37)
  
            jumpLabel:Draw()
            jumpValue:Draw()
          end

          local rolls = Pane('SongRollsText'):GetText()
          if rolls then
            local rollsLabel = chartStatsLabel:get('ROLLS')
            local rollsValue = chartStatsValue:get(rolls)
            rollsLabel:xy(scx*0.15,scy*1.44)
            rollsValue:xy(scx*0.16,scy*1.44)

            rollsLabel:Draw()
            rollsValue:Draw()
          end
          
          local mines = Pane('SongMinesText'):GetText()
          if mines then
            local minesLabel = chartStatsLabel:get('MINES')
            local minesValue = chartStatsValue:get(mines)
            minesLabel:xy(scx*0.15,scy*1.51)
            minesValue:xy(scx*0.16,scy*1.51)
  
            minesLabel:Draw()
            minesValue:Draw()
          end

          local hands = Pane('SongHandsText'):GetText()
          if hands then
            local handsLabel = chartStatsLabel:get('HANDS')
            local handsValue = chartStatsValue:get(hands)
            handsLabel:xy(scx*0.15,scy*1.58)
            handsValue:xy(scx*0.16,scy*1.58)
  
            handsLabel:Draw()
            if handsValue then
              --print(handsValue)
              handsValue:Draw()  
            end
            
          end

        end

      end

      if SelectOptionsPrompt and SelectOptionsPrompt:getstate() == 1 then
        settext1("PLEASE","LOADING")
        settext2("WAIT","OPTIONS")
      end

      doorAnim()


    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),

  ---@param fb_actor Sprite Fallback Actor from Stepmania
  doorclose = function (fb_actor)
    fb_actor:hidden(1)
    SelectOptionsPrompt = fb_actor
  end

}