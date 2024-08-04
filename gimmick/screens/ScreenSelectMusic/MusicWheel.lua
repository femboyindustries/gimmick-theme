local TextPool = require 'gimmick.textpool'
local easable = require 'gimmick.lib.easable'

---@class MusicWheel
local MusicWheel = {}

-- must be an ODD number such that we can determine the middle easily
local WHEEL_ITEMS = 17

local WHEEL_ITEM_WIDTH = 300
local WHEEL_ITEM_HEIGHT = 30

local METER_WIDTH = 30

-- defined ahead of time just due to how this works
MusicWheel.itemDrawFunc = nil
local lastDifficulty
local itemEases = {}
local itemI = 0

function MusicWheel.MusicWheel()
  return {
    NumWheelItems = function() return WHEEL_ITEMS end,
    ItemSpacingY = function() return WHEEL_ITEM_HEIGHT end,

    ---@param wheel Actor
    On = function(wheel)
      wheel:x(sw - 32 - WHEEL_ITEM_WIDTH / 2)
      wheel:y(scy + 4)
      -- resetting these; unsure why simply love stretches them
      wheel:zoomx(1)
      wheel:zoomy(1)
      --wheel:zoomx(0.86 * ((sw / sh) / (4/3)))
      --wheel:zoomy(0.96)

      MusicWheel.itemDrawFunc = nil -- to prevent accidental AVs
    end,

    Item = {
      On = function(item)
        if not MusicWheel.itemDrawFunc then
          error('itemDrawFunc not defined, likely forgot to call MusicWheel.init')
        end
        item:SetDrawFunction(MusicWheel.itemDrawFunc)
      end
    },
  }
end

---@param ctx Context
function MusicWheel.init(ctx)
  -- do song-related fetching

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

  -- actors

  local quad = ctx:Quad()
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

  itemI = 0
  itemEases = {}

  MusicWheel.itemDrawFunc = function(self)
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

    local frontCol, shadeCol = rgb(0.2, 0.2, 0.2), rgb(0.15, 0.15, 0.15)
    if not groupName:GetHidden() then
      frontCol, shadeCol = rgb(0.27, 0.27, 0.27), rgb(0.22, 0.22, 0.22)
    end

    quad:xywh(quadX + offX, 0, width, WHEEL_ITEM_HEIGHT)
    quad:diffuse(frontCol:unpack())
    quad:Draw()
    quad:xywh(quadX + offX, WHEEL_ITEM_HEIGHT / 4, width, WHEEL_ITEM_HEIGHT / 2)
    quad:diffuse(shadeCol:unpack())
    quad:Draw()

    quad:xywh(quadX + offX, -WHEEL_ITEM_HEIGHT / 2 + 1, width, 2)
    quad:diffuse(0, 0, 0, 1)
    quad:Draw()

    if not groupName:GetHidden() then
      local songsInGroup = groupLookup[groupName:GetText()]

      local margin = 30
      if not songsInGroup then margin = 0 end
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

      if songsInGroup then
        local meterT = meterText:get(tostring(#songsInGroup))

        quad:xywh(-WHEEL_ITEM_WIDTH / 2 + margin / 2 + offX, 2/2, margin, WHEEL_ITEM_HEIGHT-2)
        quad:diffuse(0.2, 0.2, 0.2, 1)
        quad:Draw()
        quad:xywh(-WHEEL_ITEM_WIDTH / 2 + margin / 2 + offX, WHEEL_ITEM_HEIGHT / 4, margin, WHEEL_ITEM_HEIGHT / 2)
        quad:diffuse(0.15, 0.15, 0.15, 1)
        quad:Draw()

        meterT:xy(-WHEEL_ITEM_WIDTH / 2 + margin / 2 + offX, 2)
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

        quad:xywh(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH / 2 + offX, 2/2, METER_WIDTH, WHEEL_ITEM_HEIGHT-2)
        quad:diffuse(diff.color:unpack())
        quad:Draw()
        quad:xywh(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH / 2 + offX, WHEEL_ITEM_HEIGHT / 4, METER_WIDTH,
          WHEEL_ITEM_HEIGHT / 2)
        quad:diffuse((diff.color * 0.85):unpack())
        quad:Draw()

        local meterT = meterText:get(tostring(curStep:GetMeter()))

        meterT:xy(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH / 2 + offX, 2)
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
    elseif not sortName:GetHidden() then
      local sortType = sortName:GetText()

      local t = itemText:get(sortType)
      local w = t:GetWidth() * 0.4
      t:xy(-w/2 + offX, 2)
      t:zoom(0.4)
      t:diffuse(1, 1, 1, 1)
      t:Draw()
    elseif not roulette:GetHidden() then
      quad:xywh(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH / 2 + offX, 2/2, METER_WIDTH, WHEEL_ITEM_HEIGHT-2)
      quad:diffuse(1, 1, 1, 1)
      quad:Draw()
      quad:xywh(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH / 2 + offX, WHEEL_ITEM_HEIGHT / 4, METER_WIDTH,
        WHEEL_ITEM_HEIGHT / 2)
      quad:diffuse(0.85, 0.85, 0.85, 1)
      quad:Draw()

      local meterT = meterText:get('?')

      meterT:xy(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH / 2 + offX, 2)
      meterT:diffuse(0, 0, 0, 1)
      meterT:zoom(0.45)
      meterT:Draw()

      local titleText = itemText:get('Random')
      titleText:xy(-WHEEL_ITEM_WIDTH / 2 + METER_WIDTH + 6 + offX, 2)
      titleText:zoom(0.4)
      titleText:diffuse(shsv((os.clock() * 0.4) % 1, 0.5, 1):unpack())
      titleText:Draw()
      titleText:diffuse(1, 1, 1, 1)
    else
      -- todo: lol course mode
      courseName:Draw()
    end

    if itemEases[index].eased > 0.1 then
      local glow = math.sqrt(itemEases[index].eased)
      local beat = (GAMESTATE:GetSongBeat() % 1)
      local bri = 0.3 - 0.1 * beat

      grad:diffuse(1, 1, 1, glow * bri)
      grad:blend('add')
      grad:xywh(quadX + offX, -WHEEL_ITEM_HEIGHT / 2 - 6, width, 12)
      grad:Draw()
      grad:xywh(quadX + offX, WHEEL_ITEM_HEIGHT / 2 + 6 + 2, width, -12)
      grad:Draw()
    end

    gradeDisplay0:Draw()
    gradeDisplay1:Draw()
  end
end

function MusicWheel.update(dt)
  for _, item in pairs(itemEases) do
    item:update(dt)
  end
  itemI = 0
end

function MusicWheel.setDifficulty(diff)
  lastDifficulty = diff
end

return MusicWheel