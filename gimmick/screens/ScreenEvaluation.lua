local TextPool = require 'gimmick.textpool'
local AWESOME = false

local judgements = {
  {
    code = 'Marvelous',
    score = 8, -- TNS_MARVELOUS
    name = 'Fantastic',
  },
  {
    code = 'Perfect',
    score = 7, -- TNS_PERFECT
    name = 'Excellent',
  },
  {
    code = 'Great',
    score = 6, -- TNS_GREAT
    name = 'Great',
  },
  {
    code = 'Good',
    score = 5, -- TNS_GOOD
    name = 'Decent',
  },
  {
    code = 'Boo',
    score = 4, -- TNS_BOO
    name = 'Way Off',
  },
  {
    code = 'Miss',
    score = 3, -- TNS_MISS
    name = 'Miss',
  },
}

return {
  Init = function(self) Trace('theme.com') end,
  overlay = gimmick.ActorScreen(function(self, ctx)
    local pool = TextPool.new(ctx, FONTS.sans_serif, nil, function(actor)
      actor:zoom(0.5)
      actor:align(0, 0.5)
    end)



    local pn = 0
    local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
    local chart = stats:GetPossibleSteps()[1]:GetNoteData()

    local holdsN = 0
    local minesN = 0
    for _, n in ipairs(chart) do
      if n.length then holdsN = holdsN + 1 end
      if n[3] == 'M' then minesN = minesN + 1 end
    end

    ---@type { name: string?, value: string?, total: string? }[]
    local fields = {}

    for _, judg in ipairs(judgements) do
      table.insert(fields, {
        name = judg.name,
        value = tostring(stats:GetTapNoteScores(judg.score)),
      })
    end

    table.insert(fields, {})

    table.insert(fields, {
      name = 'Holds',
      value = stats:GetHoldNoteScores(2), -- HNS_OK
      total = holdsN,
    })
    table.insert(fields, {
      name = 'Mines',
      value = stats:GetTapNoteScores(1), -- TNS_HITMINE
      total = minesN,
    })

    local perc = stats:GetPercentDancePoints() * 100
    local decimal = string.format('%02d', math.floor(perc))
    local fractional = string.format('%02d', math.floor((perc % 1) * 100 + 0.5))
    local score = decimal .. '.' .. fractional

    self:SetDrawFunction(function()
      local full_score = pool:get(score)

      full_score:zoom(1)
      full_score:xy(15, 30)
      full_score:Draw()

      full_score:zoom(0.5)

      for i, field in ipairs(fields) do
        local y = 60 + 30 * i

        if field.name then
          local text = pool:get(field.name)
          text:xy(15, y)
          text:Draw()
        end

        if field.value then
          local text = pool:get(field.value)
          text:xy(140, y)
          text:Draw()
        end

        if field.total then
          local text = pool:get('/')
          text:xy(160, y)
          text:Draw()

          local text = pool:get(field.total)
          text:xy(180, y)
          text:Draw()
        end
      end
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
    if AWESOME then
      local awesome = ctx:Sprite('Graphics/awesome.png')
      awesome:xy(scx, scy)
      awesome:zoom(0.5)

      local oldT = os.clock()
      local t = 0

      self:SetDrawFunction(function()
        local newT = os.clock()
        local dt = newT - oldT
        oldT = newT
        t = t + dt

        awesome:diffusealpha(clamp(t - 3, 0, 1))
        awesome:Draw()

        if t > 5 then
          GAMESTATE:Crash('it would be so awesome')
        end
      end)

      return
    else
      local winner = ctx:Sprite('Graphics/winner.png')
      self:SetDrawFunction(function()
        winner:xy(scx, scy)
        winner:scaletofit(scx - 100, scy - 100, scx + 100, scy + 100)
        winner:Draw()
      end)
    end
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}