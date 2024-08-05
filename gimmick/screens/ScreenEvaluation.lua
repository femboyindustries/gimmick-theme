local TextPool = require 'gimmick.textpool'
local easable = require 'gimmick.lib.easable'
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

    local ease = easable(0, 12)



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

    --table.insert(fields, {})
    table.insert({},{}) --i felt bad removing the other one, please take this as a substitute

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

    ease:reset(0)
    ease:set(score * 0.0999999999)


    local inside_spacing = 10
    local item_spacing = sh * 0.08
    local judge_counts = ctx:ActorFrame()

    for i, field in ipairs(fields) do
      local af = ctx:ActorFrame()

      local name = ctx:BitmapText(FONTS.sans_serif,field.name or '')
      name:xy(inside_spacing * 0.5, 0)
      name:halign(0)
      name:zoom(0.5)

      local value = ctx:BitmapText(FONTS.monospace,field.value or '')
      value:halign(1)
      value:xy(-inside_spacing * 0.5, 0)
      value:zoom(0.8)

      ctx:addChild(af, value)
      ctx:addChild(af, name)

      af:y((item_spacing * i) - (item_spacing * (#fields+1) * 0.5))
      af:halign(0.5)

      ctx:addChild(judge_counts, af)
    end

    judge_counts:xy(sw*0.8, scy)
    judge_counts:halign(0.5)


    setDrawFunctionWithDT(self, function(dt)
      local full_score = pool:get(score)
      full_score:halign(0.5)
      full_score:zoom(1.5)
      full_score:xy(scx, scy * 1.3)
      full_score:Draw()

      ease:update(dt)

      judge_counts:Draw()
      --[[
        fields table
        {
          { value = "286", name = "Fantastic" },
          { value = "89", name = "Excellent" },
          { value = "45", name = "Great" },
          { value = "2", name = "Decent" },
          { value = "8", name = "Way Off" },
          { value = "5", name = "Miss" }, {  },
          { value = 14, total = 14, name = "Holds" },
          { value = 0, total = 3, name = "Mines" }
        }

      ]]
      full_score:zoom(0.5)
      --error("fart")


      --[[
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
      ]]
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
    else
      local winner = ctx:Sprite('Graphics/winner.png')
      local bg = ctx:Sprite('Mascots/backgrounds/jimble.jpg')
      bg:stretchto(0, 0, sw, sh)

      self:SetDrawFunction(function()
        bg:Draw()

        winner:scaletofit(scx - 100, scy - 100, scx + 100, scy + 100)
        winner:xy(scx, scy * 0.6)

        winner:Draw()
      end)
    end
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}