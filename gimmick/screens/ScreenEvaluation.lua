local TextPool = require 'gimmick.textpool'
local easable = require 'gimmick.lib.easable'
local wheel = require 'gimmick.lib.meterWheel'
local mascots = require 'gimmick.mascots'
local save = require 'gimmick.save'
local AWESOME = false

local judgements = {
  {
    code = 'Marvelous',
    score = TNS_MARVELOUS, -- TNS_MARVELOUS
    name = 'Fantastic',
    color = hex('27D0FE'),
  },
  {
    code = 'Perfect',
    score = TNS_PERFECT, -- TNS_PERFECT
    name = 'Excellent',
    color = hex('F6E213'),
  },
  {
    code = 'Great',
    score = TNS_GREAT, -- TNS_GREAT
    name = 'Great',
    color = hex('46E308'),
  },
  {
    code = 'Good',
    score = TNS_GOOD, -- TNS_GOOD
    name = 'Decent',
    color = hex('9C0AEB'),
  },
  {
    code = 'Boo',
    score = TNS_BOO, -- TNS_BOO
    name = 'Way Off',
    color = hex('FA7A04'),
  },
  {
    code = 'Miss',
    score = TNS_MISS, -- TNS_MISS
    name = 'Miss',
    color = hex('B50F00')
  },
}

---@type {string: string, file: string}
local grades = {
  [GRADE_TIER01] = {
    string = 'Quad i think',
    file = 'star-quad'
  },
  [GRADE_TIER02] = {
    string = '3 stars',
    file = 'star-triple'
  },
  [GRADE_TIER03] = {
    string = '2 stars',
    file = 'star-double'
  },
  [GRADE_TIER04] = {
    string = '1 star',
    file = 'star'
  },
  [GRADE_TIER05] = {
    string = 'S+',
    file = 's-plus'
  },
  [GRADE_TIER06] = {
    string = 'S',
    file = 's'
  },
  [GRADE_TIER07] = {
    string = 'S-',
    file = 's-minus'
  },
  [GRADE_TIER08] = {
    string = 'A+',
    file = 'a-plus'
  },
  [GRADE_TIER09] = {
    string = 'A',
    file = 'a'
  },
  [GRADE_TIER10] = {
    string = 'A-',
    file = 'a-minus'
  },
  [GRADE_TIER11] = {
    string = 'B+',
    file = 'b+plus'
  },
  [GRADE_TIER12] = {
    string = 'B',
    file = 'b'
  },
  [GRADE_TIER13] = {
    string = 'B-',
    file = 'b-minus'
  },
  [GRADE_TIER14] = {
    string = 'C+',
    file = 'c-plus'
  },
  [GRADE_TIER15] = {
    string = 'C',
    file = 'c'
  },
  [GRADE_TIER16] = {
    string = 'C-',
    file = 'c-minus'
  },
  [GRADE_TIER17] = {
    string = 'D+',
    file = 'd-plus'
  },
  [GRADE_TIER18] = {
    string = 'D',
    file = 'd'
  },
  [GRADE_TIER19] = {
    string = 'D-',
    file = 'd-minus'
  },
  [GRADE_TIER20] = {
    string = 'how did you manage this, E',
    file = 'star'
  },
  [GRADE_FAILED] = {
    string = 'F',
    file = 'f'
  },
}

local bn_width = 278
local bn_height = 109
local bn_x = scx * 0.35
local bn_y = scy * 0.3

return {
  Init = function(self) Trace('theme.com') end,


  --Position the Banner LargeBannerOnCommand from metrics.ini gives us
  Banner = {
    Width = bn_width,
    Height = bn_height,
    ---@param bn Sprite
    On = function(bn)
      bn:ztest(0)
      bn:xy(bn_x, bn_y)
    end
  },

  overlay = gimmick.ActorScreen(function(self, ctx, scope)
    local pool = TextPool.new(ctx, FONTS.sans_serif, nil, function(actor)
      actor:zoom(0.5)
      actor:align(0, 0.5)
    end)

    local pn = 0
    local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
    local chart = stats:GetPossibleSteps()[1]:GetNoteData()
    local song = GAMESTATE:GetCurrentSong()
    local steps = GAMESTATE:GetCurrentSteps(1)

    --handle hold and mine counts
    local holdsN = 0
    local minesN = 0
    for _, n in ipairs(chart) do
      if n.length then holdsN = holdsN + 1 end
      if n[3] == 'M' then minesN = minesN + 1 end
    end

    ---@type { name: string?, value: string?, total: string?, color: color?}[]
    local fields = {}

    for _, judg in ipairs(judgements) do
      table.insert(fields, {
        name = judg.name,
        value = tostring(stats:GetTapNoteScores(judg.score)),
        color = judg.color
      })
    end

    --table.insert(fields, {})
    introduceEntropyIntoUniverse()

    table.insert(fields, {
      name = 'Holds',
      value = stats:GetHoldNoteScores(2), -- HNS_OK
      total = holdsN,
      color = hex('#A0A0A0')
    })
    table.insert(fields, {
      name = 'Mines',
      value = stats:GetTapNoteScores(1), -- TNS_HITMINE
      total = minesN,
      color = hex('#A0A0A0')
    })

    local perc = stats:GetPercentDancePoints() * 100
    local score = string.format('%05.2f', math.max(perc, 0))

    local title = song:GetDisplayMainTitle()
    local subtitle = song:GetDisplaySubTitle()
    local description = steps:GetDescription()


    local inside_spacing = 10      --space between value
    local item_spacing = sh * 0.07 --space between items

    --the ActorFrame that holds the judgements table
    local judge_counts = ctx:ActorFrame()

    for i, field in ipairs(fields) do
      local af = ctx:ActorFrame()

      local name = ctx:BitmapText(FONTS.sans_serif, field.name or '')
      name:xy(inside_spacing * 0.5, 0)
      name:halign(0)
      name:zoom(0.5)
      name:diffuse(field.color:unpack())

      local value = ctx:BitmapText(FONTS.monospace, field.value or '')
      value:halign(1)
      value:xy(-inside_spacing * 0.5, 0)
      value:zoom(0.7)

      ctx:addChild(af, value)
      ctx:addChild(af, name)

      af:y((item_spacing * i) - (item_spacing * (#fields + 1) * 0.5))
      af:halign(0.5)

      ctx:addChild(judge_counts, af)
    end

    judge_counts:xy(sw * 0.85, scy * 0.63)
    judge_counts:halign(0.5)

    local musicrate = GAMESTATE:GetMusicRate()

    local is_disqualified = GAMESTATE:IsDisqualified(0)
    local disqualified
    if is_disqualified then
      disqualified = ctx:BitmapText(FONTS.sans_serif, 'DISQUALIFIED FROM RANKING')
      disqualified:xy(scx, scy * 1.20)
      disqualified:zoom(0.25)
    end

    local diff = wheel.new(ctx, scope)
    ---@diagnostic disable-next-line: param-type-mismatch
    diff.color = scope.tick:easable(DIFFICULTIES[GAMESTATE:PlayerDifficulty(0)].color)
    diff.meter:reset(0)
    local diff_int = steps:GetMeter()
    diff.meter:set(diff_int)
    diff.rating:settext(tostring(diff_int))

    local a1984
    if diff_int == 1984 then
      a1984 = ctx:Sprite('Graphics/1984.jpg')
    end


    --Grades
    local grade_int = GetGradeFromPercent(stats:GetPercentDancePoints())
    print(pretty(grades[grade_int]))

    --error('/Graphics/Grades/'..grades[grade_int].file..'.png')
    --TODO: Quads
    local gradeActor = ctx:Sprite('Graphics/Grades/' .. grades[grade_int].file .. '.png')

    local mascot
    if save.data.settings.mascot_enabled then
      --placeholder mascot grade
      mascot = ctx:Sprite('Mascots/grades/default.png')
    end


    local rateOverlay = ctx:Quad()

    setDrawFunctionWithDT(self, function(dt)
      local full_score = pool:get(score)
      full_score:halign(0.5)
      full_score:valign(0)
      full_score:zoom(1.4)
      full_score:xy(scx, scy * 0.6)
      full_score:Draw()

      local titleActor = pool:get(title)
      titleActor:xy(scx * 0.35, scy * 0.62)
      titleActor:halign(0.5)
      titleActor:valign(1)
      titleActor:maxwidth(278 / 0.4)
      titleActor:zoom(0.4)
      titleActor:Draw()

      local subtitleActor = pool:get(subtitle)
      subtitleActor:xy(scx * 0.35, scy * 0.69)
      subtitleActor:halign(0.5)
      subtitleActor:valign(1)
      subtitleActor:maxwidth(278 / 0.25)
      subtitleActor:zoom(0.25)
      subtitleActor:Draw()

      local descriptionActor = pool:get(description)
      descriptionActor:xy(scx * 0.24, scy * 0.9)
      descriptionActor:zoom(0.5)
      descriptionActor:diffuse(1, 1, 1, 1)
      descriptionActor:Draw()

      if musicrate ~= 1 then
        rateOverlay:halign(0.5)
        rateOverlay:valign(0.5)
        rateOverlay:xy(bn_x, bn_y)
        rateOverlay:SetWidth(bn_width)
        rateOverlay:SetHeight(bn_height)
        rateOverlay:diffuse(0, 0, 0, 0.7)
        rateOverlay:Draw()

        local rateActor = pool:get(tostring(musicrate) .. "x")
        rateActor:halign(0.5)
        rateActor:valign(0.5)
        rateActor:zoom(1.4)
        rateActor:xy(bn_x, bn_y)
        rateActor:diffuse(1, 1, 1, 1)
        rateActor:rotationz(-10)
        rateActor:Draw()
      end



      if is_disqualified then
        disqualified:Draw()
      end

      diff:draw(scx * 0.125, scy * 0.9)

      judge_counts:Draw()
      full_score:zoom(0.5)
      --error("fart")

      if diff_int == 1984 then
        a1984:stretchto(0, 0, sw, sh)
        a1984:Draw()
      end

      gradeActor:scaletofit(0, 0, scx * 0.5, scy * 0.5)
      gradeActor:xy(scx, scy * 0.3)
      gradeActor:valign(0.5)
      --gradeActor:xy(scx, scy * 0.06)
      gradeActor:Draw()

      if save.data.settings.mascot_enabled then
        --local paths = mascots.getPaths(save.data.settings.mascot)
        mascot:scaletofit(0, 0, sw * 0.4, sh * 0.4)
        mascot:valign(0)
        mascot:xy(scx, scy * 0.9)
        mascot:Draw()
      end
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
    if AWESOME then
      local awesome = ctx:Sprite('Graphics/awesome.png')
      awesome:xy(scx, scy)
      awesome:zoom(0.5)

      local t = 0

      setDrawFunctionWithDT(self, function(dt)
        t = t + dt

        awesome:diffusealpha(clamp(t - 3, 0, 1))
        awesome:Draw()

        if t > 5 then
          GAMESTATE:Crash('it would be so awesome')
        end
      end)

      return
    end

    local winner = ctx:Sprite('Graphics/winner.png')
    local bg = ctx:Sprite('Mascots/backgrounds/jimble.jpg')
    bg:stretchto(0, 0, sw, sh)
    bg:diffusealpha(0.6)

    self:SetDrawFunction(function()
      bg:Draw()

      --[[
      winner:scaletofit(scx - 100, scy - 100, scx + 100, scy + 100)
        winner:valign(0)
      winner:xy(scx, scy * 0.06)

      winner:Draw()
      ]]
    end)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}