local easable = require 'gimmick.lib.easable'
local MeterWheel = require 'gimmick.lib.meterWheel'
local barlib = require 'gimmick.bar'
local MusicWheel = require 'gimmick.screens.ScreenSelectMusic.MusicWheel'

return {
  MusicWheel = MusicWheel.MusicWheel(),
  Banner = {
    ---@param bn FadingBanner
    On = function(bn)
      bn:ztest(0)
      -- this is only vaguely better than magic numbers
      bn:xy((48 + 96 + 240)/2, 135)
      --bn:effectclock('bgm')
      --bn:wag()
    end
  },
  overlay = gimmick.ActorScreen(function(self, ctx)
    MusicWheel.init(ctx)

    local bar = barlib.new(ctx)
    local bar_af = bar.actorframe
    local bar_ease = easable(0,24)
    bar_af:xy(scx * 0.5, scy * 1.5)

    local wheel = MeterWheel.new(ctx)
    
    local text = ctx:BitmapText(FONTS.sans_serif)
    text:shadowlength(0)
    text:zoom(0.35)
    local fold = ctx:Quad()

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
    local diffEase = easable(0)

    ---@type Song
    local song = nil
    ---@type {[1]: number, [2]: Steps}[]
    local steps = {}
    local difficulty = nil

    --local test = ctx:Sprite('Graphics/_missing.png')

    setDrawFunctionWithDT(self, function(dt)
      MusicWheel.update(dt)
      bar_ease:update(dt)

      local newSong = GAMESTATE:GetCurrentSong()
      if newSong ~= song then
        print('switch: ' .. (song and song:GetDisplayMainTitle() or ''))
        song = newSong
        local diffOffset = 0
        steps = {}
        difficulty = nil
        if song then
          for i, step in ipairs(song:GetAllSteps()) do
            steps[i] = { step:GetDifficulty() + diffOffset, step }
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
      diffEase:update(dt * 8)

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

      ---@type table<number, Steps | { fake: true }>
      local renderSteps = {}

      for k in pairs(folds) do
        renderSteps[k] = { fake = true }
      end
      for k in pairs(DIFFICULTIES) do
        renderSteps[k] = { fake = true }
      end
      for _, stepSet in ipairs(steps) do
        renderSteps[stepSet[1]] = stepSet[2]
      end

      for diffI = 0, (countKeys(renderSteps) - 1) do
        local step = renderSteps[diffI]
        local diff = DIFFICULTIES[diffI] or DIFFICULTIES[DIFFICULTY_EASY]

        folds[diffI] = folds[diffI] or easable(0)
        local w = folds[diffI]

        fold:diffuse(diff.color:unpack())
        if (not step.fake) and step == selected then
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
          text:settext(step:GetDescription())
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
        end

        x = x + w.eased + clamp(w.eased / (FOLD_BORDER * 2), 0, 1) * FOLD_GAP
      end

      for _, v in pairs(folds) do
        v:update(dt * 16)
      end

      if selected then
        wheel:ease(selected:GetMeter(), selected:GetDifficulty())
        wheel:draw(dt, 48, scy)
      else
        wheel:set(0, nil)
      end

      if difficulty then
        local diff = DIFFICULTIES[difficulty]
        diffRepText:settext(string.upper(diff.name) .. ' // ')
        diffRepText:diffuse(diff.text:unpack())
        quad:diffuse(diff.color:unpack())
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
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}