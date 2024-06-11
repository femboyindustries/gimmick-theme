local actor235 = require 'gimmick.lib.actor235'
local easable = require 'gimmick.lib.easable'

-- must be an ODD number such that we can determine the middle easily
local WHEEL_ITEMS = 17

local WHEEL_ITEM_HEIGHT = 30

-- todo: should be moved somewhere else?
local DIFFICULTIES = {
  [COURSE_DIFFICULTY_BEGINNER] = {
    name = 'Easy',
    color = hex('#3FFFE4'),
    text = rgb(0, 0, 0),
  },
  [COURSE_DIFFICULTY_EASY] = {
    name = 'Normal',
    color = hex('#54FFAB'),
    text = rgb(0, 0, 0),
  },
  [COURSE_DIFFICULTY_REGULAR] = {
    name = 'Hard',
    color = hex('#FFEC75'),
    text = rgb(0, 0, 0),
  },
  [COURSE_DIFFICULTY_DIFFICULT] = {
    name = 'Harder',
    color = hex('#FF6651'),
    text = rgb(0, 0, 0),
  },
  [COURSE_DIFFICULTY_CHALLENGE] = {
    name = 'Insane',
    color = hex('#6A54FF'),
    text = rgb(0, 0, 0),
  },
  [COURSE_DIFFICULTY_EDIT] = {
    name = 'Demon',
    color = hex('B4B7BA'),
    text = rgb(0, 0, 0),
  }
}

return {
  Init = function(self)
    wheelActors = {}
  end,
  MusicWheel = {
    -- mostly all just testing

    NumWheelItems = function() return WHEEL_ITEMS       end,
    ItemSpacingY =  function() return WHEEL_ITEM_HEIGHT end,

    --RouletteOn = function(self) addActor(self) end,
    --SectionOn = function(self) addActor(self) end,
    --SongNameOn = function(self) addActor(self) end,
    --CourseNameOn = function(self) addActor(self) end,
    --SortOn = function(self) addActor(self) end,
  },
  overlay = gimmick.ActorScreen(function(self, ctx)
    local text = ctx:BitmapText(FONTS.sans_serif)
    local rating = ctx:BitmapText(FONTS.sans_serif)
    rating:shadowlength(0)
    text:shadowlength(0)
    text:zoom(0.35)
    local fold = ctx:Quad()

    local quad = ctx:Quad()

    ---@type table<number, easable>
    local folds = {}

    local meterEase = easable(0)
    local meterColor = easable(oklab.fromColor(DIFFICULTIES[DIFFICULTY_BEGINNER].color))

    local FOLD_BORDER = 6
    local FOLD_GAP = 6
    local TOTAL_FOLD_WIDTH = 240

    fold:align(0, 0.5)
    text:align(0, 0.5)

    local pie = ctx:Shader('Shaders/pie.frag')
    local pieActor = ctx:Sprite('Graphics/white.png')

    pieActor:addcommand('Init', function(a)
      a:SetShader(actor235.Proxy.getRaw(pie))
    end)

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

    local time = 0

    self:SetDrawFunction(function()
      local newTime = os.clock()
      local dt = newTime - time
      time = newTime

      local newSong = GAMESTATE:GetCurrentSong()
      if newSong ~= song then
        print('switch: ' .. (song and song:GetDisplayMainTitle() or ''))
        song = newSong
        local diffOffset = 0
        steps = {}
        difficulty = nil
        if song then
          for i, step in ipairs(song:GetAllSteps()) do
            steps[i] = {step:GetDifficulty() + diffOffset, step}
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
        diffEase.eased = -1
      end
      diffEase:update(dt * 8)

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
        local diff = DIFFICULTIES[diffI] or DIFFICULTIES[COURSE_DIFFICULTY_EDIT]

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
        local diff = DIFFICULTIES[selected:GetDifficulty()] or DIFFICULTIES[COURSE_DIFFICULTY_EDIT]
        local meter = selected:GetMeter() or 0

        meterEase:set(meter)
        meterColor:set(oklab.fromColor(diff.color))

        local fill = meterEase.eased / 20

        pieActor:diffuse(meterColor.eased:unpack())

        for cycle = 1, math.floor(1 + fill) do
          local widthPx = 10
          local size = 64 + (cycle - 1) * 32
          pieActor:xywh(48, scy, size, size)

          local a = clamp(fill - (cycle - 1), 0, 1)

          pie:uniform1f('width', 1 / (size * 0.5) * math.min(a * 20, 1))
          pie:uniform1f('radiusOffset', widthPx / (size * 0.5) * 0.5)
          pie:uniform1f('fill', 1)
          pieActor:diffusealpha(0.5)
          pieActor:Draw()

          pie:uniform1f('width', widthPx / (size * 0.5))
          pie:uniform1f('radiusOffset', 0)
          pie:uniform1f('fill', a)
          pieActor:diffusealpha(1)
          pieActor:Draw()
        end

        rating:settext(tostring(meter))
        rating:xy(48, scy)
        rating:diffuse(1, 1, 1, 1)
        rating:zoom(0.55)
        rating:Draw()
      else
        meterEase:set(0)
      end

      meterEase:update(dt * 20)
      meterColor:update(dt * 18)

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
      quad:xywh(sw - 30, scy, barHeight, sh)
      quad:Draw()

      local textWidth = diffRepText:GetWidth() * diffRepText:GetZoomX()
      local startY = -((os.clock() * 16 + diffEase.eased * 32) % textWidth)
      for y = startY, sh, textWidth do
        diffRepText:xy(sw - 30, y)
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