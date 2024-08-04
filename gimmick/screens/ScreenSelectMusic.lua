local actor235 = require 'gimmick.lib.actor235'
local easable = require 'gimmick.lib.easable'
local TextPool = require 'gimmick.textpool'
local barlib = require 'gimmick.bar'

-- must be an ODD number such that we can determine the middle easily
local WHEEL_ITEMS = 17

local WHEEL_ITEM_WIDTH = 300
local WHEEL_ITEM_HEIGHT = 30

-- todo: should be moved somewhere else?
local DIFFICULTIES = {
  [DIFFICULTY_BEGINNER] = {
    name = 'Easy',
    color = hex('#3FFFE4'),
    text = rgb(0, 0, 0),
  },
  [DIFFICULTY_EASY] = {
    name = 'Normal',
    color = hex('#54FFAB'),
    text = rgb(0, 0, 0),
  },
  [DIFFICULTY_MEDIUM] = {
    name = 'Hard',
    color = hex('#FFEC75'),
    text = rgb(0, 0, 0),
  },
  [DIFFICULTY_HARD] = {
    name = 'Harder',
    color = hex('#FF6651'),
    text = rgb(0, 0, 0),
  },
  [DIFFICULTY_CHALLENGE] = {
    name = 'Insane',
    color = hex('#6A54FF'),
    text = rgb(0, 0, 0),
  },
  [DIFFICULTY_EDIT] = {
    name = 'Demon',
    color = hex('B4B7BA'),
    text = rgb(0, 0, 0),
  }
}

local itemDrawFunc

return {
  Init = function(self)
    wheelActors = {}
  end,
  MusicWheel = {
    -- mostly all just testing

    NumWheelItems = function() return WHEEL_ITEMS end,
    ItemSpacingY = function() return WHEEL_ITEM_HEIGHT end,

    --RouletteOn = function(self) addActor(self) end,
    --SectionOn = function(self) addActor(self) end,
    --SongNameOn = function(self) addActor(self) end,
    --CourseNameOn = function(self) addActor(self) end,
    --SortOn = function(self) addActor(self) end,

    ---@param wheel Actor
    On = function(wheel)
      print('/!\\ ALERTA !!!!! everything fine')

      wheel:x(sw - 32 - WHEEL_ITEM_WIDTH / 2)
      wheel:y(scy + 4)
      -- resetting these; unsure why simply love stretches them
      wheel:zoomx(1)
      wheel:zoomy(1)
      --wheel:zoomx(0.86 * ((sw / sh) / (4/3)))
      --wheel:zoomy(0.96)
    end,

    Item = {
      On = function(item)
        print('/!\\ ALERTA !!!!! VIRUSE !!!!!! ON YOUR COMPUTER /!\\')
        item:SetDrawFunction(itemDrawFunc)
        glog = item
      end
    },
  },
  Banner = {
    ---@param bn FadingBanner
    On = function(bn)
      bn:ztest(0)
      --bn:effectclock('bgm')
      --bn:wag()
    end
  },
  overlay = gimmick.ActorScreen(function(self, ctx)
    local bar = barlib.new(ctx)
    local bar_af = bar.actorframe
    bar_af:xy(scx * 0.5, scy * 1.5)
    
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
    local meterColor = easable(DIFFICULTIES[DIFFICULTY_BEGINNER].color)

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
    local lastDifficulty = DIFFICULTY_CHALLENGE

    local allSongs = SONGMAN:GetAllSongs()
    ---@type table<string, Song>
    local songLookup = {}
    setmetatable(songLookup, { __mode = 'v' })
    local groupLookup = {}

    for _, song in ipairs(allSongs) do
      local dir = song:GetSongDir()
      local _, _, groupPath, songPath = string.find(dir, '/([^/]+)/([^/]+)/$')
      groupLookup[groupPath] = groupLookup[groupPath] or {}
      table.insert(groupLookup[groupPath], song)
    end

    --local test = ctx:Sprite('Graphics/_missing.png')
    local wheelQuad = ctx:Quad()
    local itemText = TextPool.new(ctx, FONTS.sans_serif, WHEEL_ITEMS * 3,
      function(a)
        a:shadowlength(0)
        a:align(0, 0.5)
      end)
    local meterText = TextPool.new(ctx, FONTS.sans_serif, WHEEL_ITEMS,
      function(a)
        a:shadowlength(0)
        a:align(0.5, 0.5)
      end)
    local grad = ctx:Sprite('Graphics/grad.png')

    local itemI = 0
    local itemEases = {}

    local METER_WIDTH = 30

    itemDrawFunc = function(self)
      --[[
        ActorFrame[MusicWheelItem]: {
          Sprite[],                        m_sprBar
          BitmapText[]: "",                m_text (?)
          Sprite[],                        m_sprSongBar
          Sprite[],                        m_sprSectionBar
          Sprite[],                        m_sprExpandedBar
          Sprite[],                        m_sprModeBar
          Sprite[],                        m_sprSortBar
          Sprite[],                        m_WheelNotifyIcon
          ActorFrame[]: {                  m_TextBanner (song name)
            BitmapText[Title]: "Alien",
            BitmapText[Subtitle]: "",
            BitmapText[Artist]: "BAKUBAKU DOKIN"
          },
          BitmapText[]: "1 - wips",        m_textSection (group name)
          BitmapText[]: "",                m_textRoulette
          BitmapText[CourseName]: "",      m_textCourse
          BitmapText[Sort]: "",            m_textSort
          Sprite[GradeP0Sprite],           m_GradeDisplay[0]
          Sprite[GradeP1Sprite]            m_GradeDisplay[1]
        }
      ]]

      itemI = itemI + 1

      local selected = itemI == WHEEL_ITEMS

      local songName = self(9) --[[@as ActorFrame]]
      local groupName = self(10) --[[@as BitmapText]]
      local roulette = self(11) --[[@as BitmapText]]
      local courseName = self(12) --[[@as BitmapText]]
      local sortName = self(13) --[[@as BitmapText]]
      local gradeDisplay0 = self(14) --[[@as Sprite]]
      local gradeDisplay1 = self(15) --[[@as Sprite]]

      local index = table.concat({ songName(1):GetText(), groupName:GetText() }, '')

      if itemEases[index] == nil then
        itemEases[index] = easable(0, 16)
      end
      itemEases[index]:set(selected and 1 or 0)
      local offX = itemEases[index].eased * -20

      local width = WHEEL_ITEM_WIDTH - offX
      local quadX = -WHEEL_ITEM_WIDTH / 2 + width / 2

      wheelQuad:xywh(quadX + offX, 0, width, WHEEL_ITEM_HEIGHT)
      wheelQuad:diffuse(0.2, 0.2, 0.2, 1)
      wheelQuad:Draw()
      wheelQuad:xywh(quadX + offX, WHEEL_ITEM_HEIGHT / 4, width, WHEEL_ITEM_HEIGHT / 2)
      wheelQuad:diffuse(0.15, 0.15, 0.15, 1)
      wheelQuad:Draw()

      wheelQuad:xywh(quadX + offX, -WHEEL_ITEM_HEIGHT / 2 + 1, width, 2)
      wheelQuad:diffuse(0, 0, 0, 1)
      wheelQuad:Draw()

      if itemEases[index].eased > 0.1 then
        local glow = math.sqrt(itemEases[index].eased)
        local beat = (GAMESTATE:GetSongBeat() % 1)
        local bri = 0.3 - 0.1 * beat

        grad:diffuse(1, 1, 1, glow * bri)
        grad:blend('add')
        grad:xywh(quadX + offX, -WHEEL_ITEM_HEIGHT / 2 - 6, width, 12)
        grad:Draw()
        grad:xywh(quadX + offX, WHEEL_ITEM_HEIGHT / 2 + 6, width, -12)
        grad:Draw()
      end

      if not groupName:GetHidden() then
        local margin = 30
        local pad = 5

        local t = itemText:get(groupName:GetText())
        local w = t:GetWidth() * 0.4
        t:xy(margin + -w/2 + offX, 2)
        t:zoom(0.4)
        t:diffuse(0.8, 0.8, 0.8, 1)
        t:Draw()

        --local leftBar = (WHEEL_ITEM_WIDTH/2 - w/2 - pad) - pad
        --local rightBar = (width - w/2 - pad)

        --wheelQuad:diffuse(0.8, 0.8, 0.8, 0.7)
        --wheelQuad:xywh(margin + -w/2 - pad - leftBar/2 + offX, 0, leftBar, 1)
        --wheelQuad:Draw()
        --wheelQuad:xywh(margin + w/2 + pad + rightBar/2 + offX, 0, rightBar, 1)
        --wheelQuad:Draw()
        t:diffuse(1, 1, 1, 1)

        local songsInGroup = groupLookup[groupName:GetText()]
        if songsInGroup then
          local meterT = meterText:get(tostring(#songsInGroup))

          wheelQuad:xywh(-WHEEL_ITEM_WIDTH / 2 + margin / 2 + offX, 0, margin, WHEEL_ITEM_HEIGHT)
          wheelQuad:diffuse(0, 0, 0, 0.3)
          wheelQuad:Draw()

          meterT:xy(-WHEEL_ITEM_WIDTH / 2 + margin / 2 + offX, 0)
          meterT:diffuse(0.6, 0.6, 0.6, 1)
          meterT:zoom(0.45)
          meterT:Draw()
        end
      elseif not songName:GetHidden() and not songName(1):GetHidden() then
        local title = songName(1)
        local subtitle = songName(2)
        local artist = songName(3)

        local titleT = title:GetText()
        local subtitleT = (not subtitle:GetHidden()) and subtitle:GetText() or ''
        local artistT = artist:GetText()

        local cacheKey = table.concat({ titleT, subtitleT, artistT }, '')
        if not songLookup[cacheKey] then
          for _, song in ipairs(allSongs) do
            -- this sucks
            -- https://github.com/openitg/openitg/blob/f2c129fe65c65e4a9b3a691ff35e7717b4e8de51/src/Song.cpp#L1413
            -- if ShowNativeLanguage is on, then titleC == titleCT
            -- todo: warn the user, try and tell them to turn it off?
            -- it's turned on by default on a regular nitg setup

            local titleC = song:GetDisplayMainTitle()
            local titleCT = song:GetTranslitMainTitle()

            local artistC = song:GetDisplayArtist()
            local artistCT = song:GetTranslitArtist()

            local subtitleC = song:GetDisplaySubTitle()
            local subtitleCT = song:GetTranslitSubTitle()

            if
                (titleC == titleT or titleCT == titleT) and
                (artistC == artistT or artistCT == artistT) and
                (subtitleC == subtitleT or subtitleCT == subtitleT)
            then
              songLookup[cacheKey] = song
              break
            end
          end
        end

        local song = songLookup[cacheKey]

        if song then
          local curStep
          local steps = song:GetAllSteps()
          for _, step in ipairs(steps) do
            if step:GetDifficulty() == lastDifficulty then
              curStep = step
              break
            end
          end
          curStep = curStep or steps[1]
          local diff = DIFFICULTIES[curStep:GetDifficulty()]

          wheelQuad:xywh(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH / 2 + offX, 0, METER_WIDTH, WHEEL_ITEM_HEIGHT)
          wheelQuad:diffuse(diff.color:unpack())
          wheelQuad:Draw()
          wheelQuad:xywh(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH / 2 + offX, WHEEL_ITEM_HEIGHT / 4, METER_WIDTH,
            WHEEL_ITEM_HEIGHT / 2)
          wheelQuad:diffuse((diff.color * 0.85):unpack())
          wheelQuad:Draw()

          local meterT = meterText:get(tostring(curStep:GetMeter()))

          meterT:xy(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH / 2 + offX, 0)
          meterT:diffuse(diff.text:unpack())
          meterT:zoom(0.45)
          meterT:Draw()
        end

        local titleText = itemText:get(titleT)
        titleText:xy(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH + 6 + offX, 2)
        titleText:zoom(0.4)

        if not subtitle:GetHidden() and subtitleT ~= '' then
          titleText:xy(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH + 6 + offX, -5 + 2)
          titleText:Draw()
          local subtitleText = itemText:get(subtitleT)
          subtitleText:xy(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH + 6 + offX, 5 + 2)
          subtitleText:zoom(0.22)
          subtitleText:Draw()
        else
          titleText:Draw()
        end
      else
        -- todo: implement the rest, abstract it
        roulette:Draw()
        courseName:Draw()
        sortName:Draw()
      end
      gradeDisplay0:Draw()
      gradeDisplay1:Draw()
    end

    setDrawFunctionWithDT(self, function(dt)
      for _, item in pairs(itemEases) do
        item:update(dt)
      end

      itemI = 0

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
        lastDifficulty = difficulty
        diffEase.eased = -1
      end
      diffEase:update(dt * 8)

      if selected then
        bar:set(selected:GetMeter() * 0.1)
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
        local diff = DIFFICULTIES[selected:GetDifficulty()] or DIFFICULTIES[DIFFICULTY_EDIT]
        local meter = selected:GetMeter() or 0

        meterEase:set(meter)
        meterColor:set(diff.color)

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