local actor235 = require 'gimmick.lib.actor235'
local easable = require 'gimmick.lib.easable'

-- must be an ODD number such that we can determine the middle easily
local WHEEL_ITEMS = 17

-- todo: should be moved somewhere else?
local DIFFICULTIES = {
  [COURSE_DIFFICULTY_BEGINNER] = {
    name = 'Easy',
    color = hex('C1006F'),
  },
  [COURSE_DIFFICULTY_EASY] = {
    name = 'Normal',
    color = hex('8200A1'),
  },
  [COURSE_DIFFICULTY_REGULAR] = {
    name = 'Hard',
    color = hex('413AD0'),
  },
  [COURSE_DIFFICULTY_DIFFICULT] = {
    name = 'Harder',
    color = hex('0073FF'),
  },
  [COURSE_DIFFICULTY_CHALLENGE] = {
    name = 'Insane',
    color = hex('00ADC0'),
  },
  [COURSE_DIFFICULTY_EDIT] = {
    name = 'Demon',
    color = hex('B4B7BA'),
  }
}

return {
  Init = function(self)
    wheelActors = {}
  end,
  MusicWheel = {
    -- mostly all just testing

    NumWheelItems = function()
      return WHEEL_ITEMS
    end,

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
    local quad = ctx:Quad()

    ---@type table<number, easable>
    local folds = {}

    local meterEase = easable(0)

    local FOLD_BORDER = 6
    local FOLD_GAP = 6
    local TOTAL_FOLD_WIDTH = 230

    quad:align(0, 0.5)
    text:align(0, 0.5)

    local pie = ctx:Shader('Shaders/pie.frag')
    local pieActor = ctx:Sprite('Graphics/white.png')

    pieActor:addcommand('Init', function(a)
      a:SetShader(actor235.Proxy.getRaw(pie))
    end)

    ---@type Song
    local song = nil
    ---@type {[1]: number, [2]: Steps}[]
    local steps = {}

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

      if not selected then return end

      local x = 96
      quad:SetHeight(20)
      quad:skewx(-0.2)

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

        quad:diffuse(diff.color:unpack())
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
          quad:SetWidth(w.eased)
          quad:xy(x, scy)
          quad:Draw()
          text:settext(step:GetDescription())
          text:diffuse(0, 0, 0, 1)
          text:xy(x + FOLD_BORDER, scy)
          text:Draw()
        else
          if not step.fake then
            w:set(FOLD_BORDER * 2)
          end
          quad:SetWidth(w.eased)
          quad:xy(x, scy)
          quad:Draw()
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

        local fill = meterEase.eased / 20

        for cycle = 1, math.floor(1 + fill) do
          local widthPx = 10
          local size = 64 + (cycle - 1) * 32
          pie:uniform1f('width', widthPx / (size * 0.5))
          pie:uniform1f('fill', clamp(fill - (cycle - 1), 0, 1))
          pieActor:xywh(48, scy, size, size)
          pieActor:diffuse(diff.color:unpack())
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
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}