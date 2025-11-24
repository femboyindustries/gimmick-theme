---@diagnostic disable: need-check-nil

--These need to be provided by something else (ScreenGameplay?)
--TODO: replace these placeholders
BX_CurCustomLife = { 0.5, 0.5 }
BX_DispCustomLife = { 0.5, 0.5 }
BX_CustomLifeChanges = { { { 0, 0.5 } }, { { 0, 0.5 } } }
BX_DisplayedGraph = 'Life'
BX_SaltyResets = 0

BX_SaltyResetPos = {}

---@param ctx Context
---@param scope Scope
return function(ctx, scope)
  function math.round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
  end

  function math.clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
  end

  oplot_plotWidth, oplot_plotHeight = 301, 112
  oplot_plotWidthSml, oplot_plotHeightSml = 150, 112
  oplot_xOffset, oplot_yOffset = 160, 0
  oplot_dotDims, oplot_plotMargin = 2, 4
  oplot_maxOffset = math.round(PREFSMAN:GetPreference('JudgeWindowScale') *
    PREFSMAN:GetPreference('JudgeWindowSecondsBoo') * 1000)

  oplot_songs = STATSMAN:GetCurStageStats():GetPossibleSongs()

  oplot_finalSecond = 0
  for i = 1, table.getn(oplot_songs) do
    oplot_finalSecond = oplot_finalSecond + oplot_songs[i]:StepsLengthSeconds()
  end

  function oplot_cumulativeTime(beat, song)
    local starttime = 0
    if GAMESTATE:IsCourseMode() then
      if song > 0 then
        for i = 1, song do
          starttime = starttime + oplot_songs[i]:StepsLengthSeconds()
        end
      end
      return starttime + oplot_songs[song + 1]:GetElapsedTimeFromBeat(beat)
    else
      return starttime + GAMESTATE:GetCurrentSong():GetElapsedTimeFromBeat(beat)
    end
  end

  function oplot_cumulativeTimeTime(tim, song)
    local starttime = 0
    if GAMESTATE:IsCourseMode() then
      if song > 0 then
        for i = 1, song do
          starttime = starttime + oplot_songs[i]:StepsLengthSeconds()
        end
      end
      return starttime + tim
    else
      return starttime + tim
    end
  end

  oplot_spellCards = { nil, nil }

  if not GAMESTATE:IsCourseMode() then
    local s = GAMESTATE:GetCurrentSong()
    oplot_spellCards = { s:GetSpellCards(), s:GetSpellCards() }

    for pn = 1, 2 do
      if table.getn(oplot_spellCards[pn]) == 0 then
        oplot_spellCards[pn] = nil
      end
    end
  else
    for pn = 1, 2 do
      if GAMESTATE:IsPlayerEnabled(pn - 1) then
        local starttime = 0
        local steps = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn - 1):GetPossibleSteps()
        if not steps then
          SCREENMAN:SystemMessage("steps is nil, dont care + didnt ask")
          return
        end
        oplot_spellCards[pn] = {}
        for i = 1, table.getn(oplot_songs) do
          table.insert(oplot_spellCards[pn], {
            StartBeat = starttime,
            EndBeat = starttime + oplot_songs[i]:StepsLengthSeconds(),
            Color = { 1, 1, 1, 1 },
            Name = oplot_songs[i]:GetDisplayMainTitle(),
            Difficulty = steps[i]:GetMeter()
          })
          starttime = starttime + oplot_songs[i]:StepsLengthSeconds()
        end
      end
    end
  end


  function oplot_fitX(beat, song, w, xo, s, e) -- Scale time values to fit within plot width.
    if not w then w = oplot_plotWidth end
    if not xo then xo = 0 end
    local perc = 0
    if s and e then
      local bt = GAMESTATE:GetCurrentSong():GetElapsedTimeFromBeat(beat)
      local st = GAMESTATE:GetCurrentSong():GetElapsedTimeFromBeat(s)
      local et = GAMESTATE:GetCurrentSong():GetElapsedTimeFromBeat(e)
      perc = (bt - st) / (et - st)
    else
      song = song or GAMESTATE:GetCurrentSong()
      if not song then error('uh oh!', 2) end
      perc = oplot_cumulativeTime(beat, song) / oplot_finalSecond
    end

    if not s then s = 0 end
    if not e then e = oplot_finalSecond end
    return math.clamp(perc, 0, 1) * w - w / 2 + xo
  end

  function oplot_fitXTime(beat, song, w, xo, s, e) -- Scale time values to fit within plot width.
    if not w then w = oplot_plotWidth end
    if not xo then xo = 0 end
    local perc = 0
    if s and e then
      local bt = oplot_cumulativeTime(beat, song)
      local st = s
      local et = e
      perc = (bt - st) / (et - st)
    else
      if not song then error('uh oh!', 2) end
      perc = oplot_cumulativeTime(beat, song) / oplot_finalSecond
    end

    if not s then s = 0 end
    if not e then e = oplot_finalSecond end
    return math.clamp(perc, 0, 1) * w - w / 2 + xo
  end

  function oplot_fitXTimeBar(t) -- Scale time values to fit within plot width.
    return t / oplot_finalSecond * oplot_plotWidth - oplot_plotWidth / 2
  end

  function oplot_fitY(y, h, yo) -- Scale offset values to fit within plot height
    if not h then h = oplot_plotHeight end
    if not yo then yo = 0 end
    return -1 * y / oplot_maxOffset * h / 2 + yo
  end

  oplot_hidden = { 1, 1 }
  curcard = { 0, 0 }

  oplot_gw = {
    PREFSMAN:GetPreference('PercentScoreWeightMarvelous'),
    PREFSMAN:GetPreference('PercentScoreWeightPerfect'),
    PREFSMAN:GetPreference('PercentScoreWeightGreat'),
    PREFSMAN:GetPreference('PercentScoreWeightGood'),
    PREFSMAN:GetPreference('PercentScoreWeightBoo'),
    PREFSMAN:GetPreference('PercentScoreWeightMiss')
  }

  function offsetToJudgeColor(offset, scale)
    local offset = math.abs(offset)
    if not scale then
      scale = PREFSMAN:GetPreference('JudgeWindowScale')
    end
    if offset <= scale * PREFSMAN:GetPreference('JudgeWindowSecondsMarvelous') then
      return 153 / 255, 204 / 255, 255 / 255, 1
    elseif offset <= scale * PREFSMAN:GetPreference('JudgeWindowSecondsPerfect') then
      return 242 / 255, 203 / 255, 048 / 255, 1
    elseif offset <= scale * PREFSMAN:GetPreference('JudgeWindowSecondsGreat') then
      return 134 / 255, 249 / 255, 168 / 255, 1
    elseif offset <= scale * PREFSMAN:GetPreference('JudgeWindowSecondsGood') then
      return 196 / 255, 133 / 255, 255 / 255, 1
    elseif offset <= scale * PREFSMAN:GetPreference('JudgeWindowSecondsBoo') then
      return 201 / 255, 066 / 255, 016 / 255, 1
    else
      return 201 / 255, 041 / 255, 041 / 255, 1
    end
  end

  function gradeToJudgeColor(grade)
    if grade == 1 then
      return 153 / 255, 204 / 255, 255 / 255, 1
    elseif grade == 2 then
      return 242 / 255, 203 / 255, 048 / 255, 1
    elseif grade == 3 then
      return 134 / 255, 249 / 255, 168 / 255, 1
    elseif grade == 4 then
      return 196 / 255, 133 / 255, 255 / 255, 1
    elseif grade == 5 then
      return 201 / 255, 066 / 255, 016 / 255, 1
    else
      return 201 / 255, 041 / 255, 041 / 255, 1
    end
  end

  function offsetToJudgeWindow(offset, scale)
    local offset = math.abs(offset)
    if not scale then
      scale = PREFSMAN:GetPreference('JudgeWindowScale')
    end
    if offset <= scale * PREFSMAN:GetPreference('JudgeWindowSecondsMarvelous') then
      return 1
    elseif offset <= scale * PREFSMAN:GetPreference('JudgeWindowSecondsPerfect') then
      return 2
    elseif offset <= scale * PREFSMAN:GetPreference('JudgeWindowSecondsGreat') then
      return 3
    elseif offset <= scale * PREFSMAN:GetPreference('JudgeWindowSecondsGood') then
      return 4
    elseif offset <= scale * PREFSMAN:GetPreference('JudgeWindowSecondsBoo') then
      return 5
    else
      return 6
    end
  end

  scope.event.new('UpdateSpellDisplayP1')
  scope.event.new('UpdateSpellDisplayP2')


  local host = ctx:ActorFrame()
  host:xy(SCREEN_WIDTH * 0.5 - 157, SCREEN_HEIGHT * 0.5 + 72 - 14)
  host:hidden(1)

  local background = ctx:Quad()
  background:diffuse(0, 0, 0, 0.6)
  background:y(-30)
  background:zoomto(305, 176)
  ctx:addChild(host, background)

  local unlabeledQuad1 = ctx:Quad()
  unlabeledQuad1:zoomto(305, 999)
  unlabeledQuad1:diffuse(hex('#1E282F'):unpack())
  ctx:addChild(host, unlabeledQuad1)

  local regionMarkers = ctx:Polygon()
  ---@param self Polygon
  regionMarkers:addcommand('Make', function(self)
    local vert = 0;

    if not GAMESTATE:IsCourseMode() then
      local s = GAMESTATE:GetCurrentSong()
      local sc = s:GetSpellCards()
      --spellcard table contains:
      --StartBeat, EndBeat (float)
      --Name (string)
      --Color (table of rgba)

      local lab = s:GetLabels()

      self:SetNumVertices(table.getn(lab) * 4 + table.getn(sc) * 4)

      for i = 1, table.getn(sc) do
        local x1 = oplot_fitX((sc[i].StartBeat))
        local x2 = oplot_fitX((sc[i].EndBeat))
        local y1 = oplot_fitY(oplot_maxOffset + 4)
        local y2 = oplot_fitY(-oplot_maxOffset - 4)

        self:SetVertexPosition(vert + 0, x1, y1, 0)
        self:SetVertexPosition(vert + 1, x2, y1, 0)
        self:SetVertexPosition(vert + 2, x2, y2, 0)
        self:SetVertexPosition(vert + 3, x1, y2, 0)

        for j = 0, 3 do
          self:SetVertexColor(vert + j, sc[i].Color[1], sc[i].Color[2], sc[i].Color[3], sc[i].Color[4] * 0.6)
        end

        vert = vert + 4
      end

      for i = 1, table.getn(lab) do
        local x = oplot_fitX((lab[i].Beat))
        local y1 = oplot_fitY(oplot_maxOffset + 4)
        local y2 = oplot_fitY(-oplot_maxOffset - 4)

        self:SetVertexPosition(vert + 0, x, y1, 1)
        self:SetVertexPosition(vert + 1, x + 1, y1, 1)
        self:SetVertexPosition(vert + 2, x + 1, y2, 1)
        self:SetVertexPosition(vert + 3, x, y2, 1)

        vert = vert + 4
      end
    else
      local lab = oplot_songs

      self:SetNumVertices(table.getn(lab) * 4)

      for i = 1, table.getn(lab) do
        local x = oplot_fitXTimeBar(oplot_cumulativeTime(0, i - 1))
        local y1 = oplot_fitY(oplot_maxOffset + 4)
        local y2 = oplot_fitY(-oplot_maxOffset - 4)

        self:SetVertexPosition(vert + 0, x, y1, 1)
        self:SetVertexPosition(vert + 1, x + 1, y1, 1)
        self:SetVertexPosition(vert + 2, x + 1, y2, 1)
        self:SetVertexPosition(vert + 3, x, y2, 1)

        vert = vert + 4
      end
    end
  end)
  regionMarkers:SetDrawMode('quads')
  regionMarkers:sleep(0)
  regionMarkers:queuecommand('Make')
  ctx:addChild(host, regionMarkers)

  --the bar that represents 0ms offset
  local centerBar = ctx:Quad()
  centerBar:zoomto(oplot_plotWidth + oplot_plotMargin, 1)
  centerBar:diffuse(offsetToJudgeColor(0))
  ctx:addChild(host, centerBar)

  --the lines that mark where judgements start and end
  local judgementLines = ctx:Polygon()
  ---@param self Polygon
  judgementLines:addcommand('Make', function(self)
    local scale = PREFSMAN:GetPreference('JudgeWindowScale')
    local fantabars = {
      1000 * scale * PREFSMAN:GetPreference('JudgeWindowSecondsMarvelous'),
      1000 * scale * PREFSMAN:GetPreference('JudgeWindowSecondsPerfect'),
      1000 * scale * PREFSMAN:GetPreference('JudgeWindowSecondsGreat'),
      1000 * scale * PREFSMAN:GetPreference('JudgeWindowSecondsGood'),
    }
    self:SetNumVertices(table.getn(fantabars) * 8)
    local vert = 0
    for i = 1, table.getn(fantabars) do
      --o[#o+1] = Def.Quad{InitCommand=cmd(y, oplot_fitY(tst[judge]*fantabars[i]); zoomto,oplot_plotWidth+oplot_plotMargin,1;diffuse,byJudgment(bantafars[i]))}
      --o[#o+1] = Def.Quad{InitCommand=cmd(y, oplot_fitY(-tst[judge]*fantabars[i]); zoomto,oplot_plotWidth+oplot_plotMargin,1;diffuse,byJudgment(bantafars[i]))}

      self:SetVertexPosition(vert + 0, -oplot_plotWidth / 2 - oplot_plotMargin / 2, -oplot_fitY(fantabars[i]), 0)
      self:SetVertexPosition(vert + 1, oplot_plotWidth / 2 + oplot_plotMargin / 2, -oplot_fitY(fantabars[i]), 0)
      self:SetVertexPosition(vert + 2, oplot_plotWidth / 2 + oplot_plotMargin / 2, -oplot_fitY(fantabars[i]) + 1, 0)
      self:SetVertexPosition(vert + 3, -oplot_plotWidth / 2 - oplot_plotMargin / 2, -oplot_fitY(fantabars[i]) + 1, 0)

      self:SetVertexPosition(vert + 4, -oplot_plotWidth / 2 - oplot_plotMargin / 2, oplot_fitY(fantabars[i]) + 1, 0)
      self:SetVertexPosition(vert + 5, oplot_plotWidth / 2 + oplot_plotMargin / 2, oplot_fitY(fantabars[i]) + 1, 0)
      self:SetVertexPosition(vert + 6, oplot_plotWidth / 2 + oplot_plotMargin / 2, oplot_fitY(fantabars[i]), 0)
      self:SetVertexPosition(vert + 7, -oplot_plotWidth / 2 - oplot_plotMargin / 2, oplot_fitY(fantabars[i]), 0)

      for j = 0, 7 do
        self:SetVertexColor(vert + j, offsetToJudgeColor((fantabars[i] / 1000) + 0.002))
      end

      vert = vert + 8
    end
  end)
  judgementLines:SetDrawMode('quads')
  judgementLines:sleep(0)
  judgementLines:queuecommand('Make')
  ctx:addChild(host, judgementLines)

  local yBorders = ctx:Quad()
  yBorders:zoomto(oplot_plotWidth + oplot_plotMargin, oplot_plotHeight + oplot_plotMargin)
  yBorders:diffuse(0.1, 0.1, 0.1, 0.8)
  ctx:addChild(host, yBorders)

  --I didnt choose the name here
  local BX_CustomLifeGraph_1bg = ctx:Polygon()
  BX_CustomLifeGraph_1bg:SetDrawMode('quadstrip')
  ---@param self Polygon
  BX_CustomLifeGraph_1bg:addcommand('MakeAndUpdate', function(self)
    if GAMESTATE:IsCourseMode() then return end

    local pn = 1
    local ss = STATSMAN:GetCurStageStats()
    local pss = ss:GetPlayerStageStats(pn - 1)
    local dvt = pss:GetOffsetVector()
    local nrt = pss:GetNoteRowVector()
    local mrt = pss.GetMineRowVector and
        pss:GetMineRowVector() or {}
    local nrs = pss:GetNoteSongVector()
    local vert = 0;
    local totaldvt = 0
    local avdvt = 0

    local alpha = 0.3


    local w, xo, s, e = nil, nil, nil, nil


    local function MRC(num)
      local colors = {}
      --[[
				if num > 5 then
					colors[1] = 1-((num-5)/5)
					colors[2] = 1
					colors[3] = 0
				else
					colors[1] = 1
					colors[2] = ((num)/5)
					colors[3] = 0
				end
				]] -- looked weird with the newer background approach
      local col1 = { 252 / 255, 108 / 255, 133 / 255 }
      local col2 = { 144 / 255, 239 / 255, 144 / 255 }
      colors = { col1[1] * (1 - num / 5) + col2[1] * (num / 5), col1[2] * (1 - num / 5) + col2[2] * (num / 5), col1[3] *
      (1 - num / 5) + col2[3] * (num / 5) }
      return colors
    end

    if table.getn(BX_CustomLifeChanges[pn]) <= 1 then
      self:hidden(1)
      self:diffusealpha(0)
    else
      self:SetNumVertices(2)
      local vert = 2;

      self:SetVertexPosition(0, 0, oplot_fitY(180), 1)
      self:SetVertexColor(0, 1, 1, 1, 1)
      self:SetVertexPosition(1, 0, oplot_fitY(-180), 1)
      self:SetVertexColor(1, 1, 1, 1, 1)

      self:SetNumVertices(table.getn(BX_CustomLifeChanges[pn]) * 2)
      for i, lc in pairs(BX_CustomLifeChanges[pn]) do
        local x = oplot_fitX(lc[1])
        local y = oplot_fitY(lc[2] * 360) + (oplot_plotHeight / 2)
        local catc = MRC(lc[2] * 10)
        self:SetVertexPosition((i - 1) * 2, x, y, 0)
        self:SetVertexColor((i - 1) * 2, catc[1] * .75, catc[2] * .75, 0, alpha)
        self:SetVertexPosition((i - 1) * 2 + 1, x, oplot_fitY(0) + (oplot_plotHeight / 2), 0)
        self:SetVertexColor((i - 1) * 2 + 1, 1, 0, 0, alpha)
      end

      self:SetLineWidth(1)
      --self:SetPolygonMode(1)
    end
  end)
  BX_CustomLifeGraph_1bg:sleep(0)
  BX_CustomLifeGraph_1bg:queuecommand('MakeAndUpdate')
  ctx:addChild(host, BX_CustomLifeGraph_1bg)

  local BX_CustomLifeGraph_1 = ctx:Polygon()
  BX_CustomLifeGraph_1:SetDrawMode('LineStrip')
  ---@param self Polygon
  BX_CustomLifeGraph_1:addcommand('MakeAndUpdate', function(self)
    if GAMESTATE:IsCourseMode() then return end

    --Trace('HEY! P1 SCATTERPLOT IS SUPPOSED TO DO SOMETHING')
    local pn = 1
    local ss = STATSMAN:GetCurStageStats()
    local pss = ss:GetPlayerStageStats(pn - 1)
    local dvt = pss:GetOffsetVector()
    local nrt = pss:GetNoteRowVector()
    local mrt = pss.GetMineRowVector and
        pss:GetMineRowVector() or {}
    local nrs = pss:GetNoteSongVector()
    local vert = 0;
    local totaldvt = 0
    local avdvt = 0

    local alpha = 0.9


    local w, xo, s, e = nil, nil, nil, nil


    local function MRC(num)
      local colors = {}
      --[[
      if num > 5 then
        colors[1] = 1-((num-5)/5)
        colors[2] = 1
        colors[3] = 0
      else
        colors[1] = 1
        colors[2] = ((num)/5)
        colors[3] = 0
      end
      ]] -- looked weird with the newer background approach
      local col1 = { 252 / 255, 108 / 255, 133 / 255 }
      local col2 = { 144 / 255, 239 / 255, 144 / 255 }
      colors = { col1[1] * (1 - num / 5) + col2[1] * (num / 5), col1[2] * (1 - num / 5) + col2[2] * (num / 5), col1[3] *
      (1 - num / 5) + col2[3] * (num / 5) }
      return colors
    end

    if table.getn(BX_CustomLifeChanges[pn]) <= 1 then
      self:hidden(1)
      self:diffusealpha(0)
    else
      self:SetNumVertices(2)
      local vert = 2;

      self:SetVertexPosition(0, 0, oplot_fitY(180), 1)
      self:SetVertexColor(0, 1, 1, 1, alpha)
      self:SetVertexPosition(1, 0, oplot_fitY(-180), 1)
      self:SetVertexColor(1, 1, 1, 1, alpha)

      self:SetNumVertices(table.getn(BX_CustomLifeChanges[pn]))
      if table.getn(BX_CustomLifeChanges[pn]) > 1 then
        for i, lc in pairs(BX_CustomLifeChanges[pn]) do
          local x = oplot_fitX(lc[1])
          local y = oplot_fitY(lc[2] * 360) + (oplot_plotHeight / 2)
          local catc = MRC(lc[2] * 10)
          self:SetVertexPosition(i - 1, x, y, 0)
          self:SetVertexColor(i - 1, catc[1] * .75, catc[2] * .75, 0, alpha)
        end
      end
      self:SetLineWidth(2)
    end
  end)
  BX_CustomLifeGraph_1:sleep(0)
  BX_CustomLifeGraph_1:queuecommand('MakeAndUpdate')
  ctx:addChild(host, BX_CustomLifeGraph_1)

  local judgementCountFrame = ctx:Quad()
  judgementCountFrame:zoomto(305, 999)
  judgementCountFrame:diffuse(hex('#1E282F'):unpack())
  ctx:addChild(host, judgementCountFrame)

  local scrollbarDivider = ctx:Quad()
  scrollbarDivider:zoomto(305, 999)
  scrollbarDivider:diffuse(0, 0, 0, 1)
  ctx:addChild(host, scrollbarDivider)

  local scrollbarBg = ctx:Quad()
  scrollbarBg:zoomto(305, 999)
  scrollbarBg:diffuse(0.2, 0.2, 0.2, 1)
  ctx:addChild(host, scrollbarBg)

  local scrollbarLocation = ctx:Quad()
  scrollbarLocation:zoomto(305, 999)
  scrollbarLocation:diffuse(0.8, 0.8, 0.8, 1)
  ctx:addChild(host, scrollbarLocation)

  --why are these just blank, why nothing like positioning -mayf
  local regionTitle = ctx:BitmapText(FONTS.sans_serif)
  ctx:addChild(host, regionTitle)
  local regionDifficulty = ctx:BitmapText(FONTS.sans_serif)
  ctx:addChild(host, regionDifficulty)
  local regionScore = ctx:BitmapText(FONTS.sans_serif)
  ctx:addChild(host, regionScore)
  local regionFNs = ctx:BitmapText(FONTS.sans_serif)
  ctx:addChild(host, regionFNs)
  local regionEXs = ctx:BitmapText(FONTS.sans_serif)
  ctx:addChild(host, regionEXs)
  local regionGRs = ctx:BitmapText(FONTS.sans_serif)
  ctx:addChild(host, regionGRs)
  local regionDCs = ctx:BitmapText(FONTS.sans_serif)
  ctx:addChild(host, regionDCs)
  local regionWOs = ctx:BitmapText(FONTS.sans_serif)
  ctx:addChild(host, regionWOs)
  local regionMSs = ctx:BitmapText(FONTS.sans_serif)
  ctx:addChild(host, regionMSs)

  local judgements = { regionFNs, regionEXs, regionGRs, regionDCs, regionWOs, regionMSs }

  local judgementHits = ctx:Polygon()
  judgementHits:SetDrawMode('Quads')
  ---@param self Polygon
  judgementHits:addcommand('Make', function(self)
    local pn = 1
    local ss = STATSMAN:GetCurStageStats()
    local pss = ss:GetPlayerStageStats(pn - 1)
    local dvt = pss:GetOffsetVector()
    local nrt = pss:GetNoteRowVector()
    local mrt = pss.GetMineRowVector and
        pss:GetMineRowVector() or {}
    local nrs = pss:GetNoteSongVector()

    self:SetNumVertices(4 * table.getn(nrt) + 4 * table.getn(mrt))

    local tns = { 0, 0, 0, 0, 0, 0 }
    local poss = 0
    local act = 0

    local w, xo, s, e = nil, nil, nil, nil

    if curcard[pn] > 0 then
      w = oplot_plotWidth - 80
      xo = 30
      s = oplot_spellCards[pn][curcard[pn]].StartBeat
      e = oplot_spellCards[pn][curcard[pn]].EndBeat
    end

    local vert = 0;
    for i = 1, table.getn(nrt) do
      --Trace('note '..i..' '..tostring(s)..' '..tostring(e))

      --if s and e and ((not GAMESTATE:IsCourseMode() nrt[i]/48 < s or nrt[i]/48 > e) or (not GAMESTATE:IsCourseMode() nrt[i]/48 < s or nrt[i]/48 > e)) then
      if s and e and ((not GAMESTATE:IsCourseMode() and (nrt[i] / 48 < s or nrt[i] / 48 > e)) or (GAMESTATE:IsCourseMode() and nrs[i] + 1 ~= curcard[pn])) then
        --continue, but it's dealing with verts, so we can't...

        for j = 0, 3 do
          self:SetVertexColor(vert + j, 0, 0, 0, 0)
          self:SetVertexPosition(vert + j, -9999, 0, 0)
        end

        vert = vert + 4

        --Trace('note '..i..' is in SONG '..nrs[i]..' beat '..(nrt[i]/48)..' (SKIPPED)')
      else
        --TODO: FIX TIME???? <- came with the code -mayf
        local x = GAMESTATE:IsCourseMode() and oplot_fitXTime(nrt[i] / 48, nrs[i], w, xo, s, e) or
            oplot_fitX(nrt[i] / 48, nrs[i], w, xo, s, e)
        local y = oplot_fitY(oplot_maxOffset + 4)
        if dvt[i] ~= 1000 then y = oplot_fitY(dvt[i]) end

        if math.abs(y) > oplot_plotHeight / 2 then
          y = oplot_fitY(oplot_maxOffset + 4)
        end

        --Trace('note '..i..' is in SONG '..nrs[i]..' beat '..nrt[i]/48)

        self:SetVertexPosition(vert + 0, x - oplot_dotDims / 2, y - oplot_dotDims / 2, 0)
        self:SetVertexPosition(vert + 1, x + oplot_dotDims / 2, y - oplot_dotDims / 2, 0)
        self:SetVertexPosition(vert + 2, x + oplot_dotDims / 2, y + oplot_dotDims / 2, 0)
        self:SetVertexPosition(vert + 3, x - oplot_dotDims / 2, y + oplot_dotDims / 2, 0)

        for j = 0, 3 do
          self:SetVertexColor(vert + j, offsetToJudgeColor(dvt[i] / 1000))
        end

        if curcard[pn] > 0 then
          local jw = offsetToJudgeWindow(dvt[i] / 1000)
          tns[jw] = tns[jw] + 1
        end

        vert = vert + 4
      end
    end

    if not GAMESTATE:IsCourseMode() then
      for i = 1, table.getn(mrt) do
        if s and e and (mrt[i] / 48 < s or mrt[i] / 48 > e) then
          --continue, but it's dealing with verts, so we can't...

          for j = 0, 3 do
            self:SetVertexColor(vert + j, 0, 0, 0, 0)
            self:SetVertexPosition(vert + j, -9999, 0, 0)
          end

          vert = vert + 4
        else
          local x = GAMESTATE:IsCourseMode() and oplot_fitXTime(mrt[i] / 48, 1, w, xo, s, e) or
              oplot_fitX(mrt[i] / 48, 1, w, xo, s, e)
          local y = oplot_fitY(-oplot_maxOffset + 4)

          self:SetVertexPosition(vert + 0, x - oplot_dotDims / 2, y - oplot_dotDims / 2, 0)
          self:SetVertexPosition(vert + 1, x + oplot_dotDims / 2, y - oplot_dotDims / 2, 0)
          self:SetVertexPosition(vert + 2, x + oplot_dotDims / 2, y + oplot_dotDims / 2, 0)
          self:SetVertexPosition(vert + 3, x - oplot_dotDims / 2, y + oplot_dotDims / 2, 0)

          for j = 0, 3 do
            self:SetVertexColor(vert + j, .6, .6, .6, 1)
          end

          vert = vert + 4
        end
      end
    end

    if true then
      if curcard[pn] > 0 then
        local color = oplot_spellCards[pn][curcard[pn]].Color
        if color[1] == 0 and color[2] == 0 and color[3] == 0 then color = { 1, 1, 1, 1 } end

        regionTitle:horizalign('left')
        regionTitle:x(-148 + 7)
        regionTitle:y(-104)
        regionTitle:shadowlength(0)
        regionTitle:diffuse(color[1], color[2], color[3], 1)
        regionTitle:zoom(.75)
        regionTitle:maxwidth(294 / .75)
        regionTitle:settext(oplot_spellCards[pn][curcard[pn]].Name)

        if tonumber(GAMESTATE:GetVersionDate()) >= 20181211 then
          regionDifficulty:horizalign('left')
          regionDifficulty:x(-148 + 7)
          regionDifficulty:y(-104 + 20)
          regionDifficulty:shadowlength(0)
          regionDifficulty:diffuse((color[1] + 2) / 3, (color[2] + 2) / 3, (color[3] + 2) / 3, 1)
          regionDifficulty:zoom(.6)
          regionDifficulty:maxwidth(294 / .6)
          regionDifficulty:settext('Difficulty: ' .. oplot_spellCards[pn][curcard[pn]].Difficulty)
        end

        for i = 1, 6 do
          judgements[i]:diffuse(gradeToJudgeColor(i))
          judgements[i]:horizalign('left')
          judgements[i]:x(-148 + 7)
          judgements[i]:zoom(.5)
          judgements[i]:y(-61 + 15 * (i + 1))
          judgements[i]:shadowlength(0)
          judgements[i]:settext(tostring(tns[i]))

          poss = poss + (5 * tns[i])
          act = act + (oplot_gw[i] * tns[i])
        end

        regionScore:horizalign('left')
        regionScore:x(-148 + 7)
        regionScore:y(-63 + 15 * 1)
        regionScore:shadowlength(0)
        regionScore:zoom(.55)
        regionScore:maxwidth(294 / .6)
        if poss > 0 then
          regionScore:settext(string.format('%.2f', (act / poss) * 100))
        else
          regionScore:settext(string.format('%.2f', 0))
        end
      else
        regionTitle:settext('')
        regionDifficulty:settext('')
        regionScore:settext('')

        for i = 1, 6 do
          judgements[i]:settext('')
        end
      end
    end


    local judgsum = 0
    local judgsump = 0
    local judgsump_len = 0

    for i = 1, table.getn(dvt) do
      if dvt[i] ~= 1000 then
        judgsum = judgsum + dvt[i]
        judgsump = judgsump + dvt[i] * (1 / offsetToJudgeWindow(dvt[i]))
        judgsump_len = judgsump_len + 1
      end
    end

    p1_avgoffset = judgsum / table.getn(dvt)
    p1_avgpoffset = judgsump / judgsump_len
  end)
  judgementHits:sleep(0.02)
  judgementHits:queuecommand('Make')
  ctx:addChild(host, judgementHits)

  local BX_CustomTimingGraph1 = ctx:Polygon()
  BX_CustomTimingGraph1:SetDrawMode('LineStrip')
  ---@param self Polygon
  BX_CustomTimingGraph1:addcommand('MakeAndUpdate', function(self)
    if GAMESTATE:IsCourseMode() then return end
    --Trace('HEY! P1 SCATTERPLOT IS SUPPOSED TO DO SOMETHING')
    local pn = 1
    local ss = STATSMAN:GetCurStageStats()
    local pss = ss:GetPlayerStageStats(pn - 1)
    local dvt = pss:GetOffsetVector()
    local nrt = pss:GetNoteRowVector()
    local mrt = pss.GetMineRowVector and
        pss:GetMineRowVector() or {}
    local nrs = pss:GetNoteSongVector()
    local vert = 0;
    local totaldvt = 0
    local avdvt = 0

    self:diffusealpha(0.5)
    self:glowshift()
    self:effectperiod(4)
    self:effectcolor1(0, 0, 0, 0)
    self:effectcolor1(1, 0, 0, 0.5)
    self:SetNumVertices(table.getn(nrt))
    for a = 1, table.getn(nrt) do
      totaldvt = 0
      local avcount = 0
      local x = oplot_fitX(nrt[a] / 48)

      for t = -15, 15 do
        if nrt[a + t] then
          totaldvt = totaldvt + dvt[a + t]
          avcount = avcount + 1
          avdvt = totaldvt / avcount

          if math.abs(avdvt) > 1000 then
            avdvt = 1000
          end
          --Trace('### NRT '..a..' - '..dvt[a+t]..'')
        end
      end

      local y = oplot_fitY(avdvt)

      if math.abs(y) > oplot_plotHeight / 2 then
        y = oplot_fitY(oplot_maxOffset + 4)
      end

      self:SetVertexPosition(a - 1, x, y, 0)
      self:SetVertexColor(a - 1, 1, 1, 1, 1)
    end
    self:SetLineWidth(3)
  end)
  BX_CustomTimingGraph1:hidden(1)
  BX_CustomTimingGraph1:sleep(0)
  BX_CustomTimingGraph1:queuecommand('MakeAndUpdate')

  local resetContainer = ctx:ActorFrame()

  local Rline = ctx:Quad()
  Rline:xywh(0, 0, 2, oplot_plotHeight - 4)
  Rline:diffusealpha(0.2)
  ctx:addChild(resetContainer, Rline)

  --thats what the text says. I cant get more descriptive than that
  local R = ctx:BitmapText(FONTS.sans_serif)
  R:settext('R')
  R:xy(2, -oplot_plotHeight / 3 - 6)
  R:diffusealpha(0.2)
  R:vertalign('top')
  R:zoom(0.5)
  R:horizalign('left')
  ctx:addChild(resetContainer, R)

  setDrawFunctionWithDT(resetContainer, function(dt)
    local quad = Rline
    local label = R

    for _, r in ipairs(BX_SaltyResetPos) do
      local x = oplot_fitX(r, 1)
      quad:x(x)
      label:x(x + 3)
      quad:Draw()
      label:Draw()
    end
  end)

  ctx:addChild(host, resetContainer)

  local lateMarker = ctx:BitmapText(FONTS.sans_serif)
  ---@param self BitmapText
  lateMarker:addcommand('DoText', function(self)
    self:settext('Late (+' .. oplot_maxOffset .. 'ms)')
  end)
  lateMarker:xy(oplot_plotWidth / 2, -oplot_plotHeight / 2 - 6)
  lateMarker:shadowlength(0)
  lateMarker:zoom(0.4)
  lateMarker:diffusealpha(0.2)
  lateMarker:horizalign('right')
  lateMarker:vertalign('top')
  lateMarker:queuecommand('DoText')
  ctx:addChild(host, lateMarker)

  local earlyMarker = ctx:BitmapText(FONTS.sans_serif)
  earlyMarker:addcommand('DoText', function(self)
    self:settext('Early (-' .. oplot_maxOffset .. 'ms)')
  end)
  earlyMarker:xy(oplot_plotWidth / 2, oplot_plotHeight / 2 - 6)
  earlyMarker:shadowlength(0)
  earlyMarker:zoom(0.4)
  earlyMarker:diffusealpha(0.2)
  earlyMarker:horizalign('right')
  earlyMarker:vertalign('bottom')
  earlyMarker:queuecommand('DoText')
  ctx:addChild(host, earlyMarker)

  local playCount = ctx:BitmapText(FONTS.sans_serif)
  playCount:hidden(1)
  playCount:xy(83, -98)
  playCount:zoom(.8)
  playCount:shadowlength(0)

  local prof = PROFILEMAN:GetMachineProfile()
  local plays = math.floor(prof:GetSongNumTimesPlayed(GAMESTATE:GetCurrentSong()) / 2)

  if plays == 0 then
    playCount:settext('No plays')
  elseif plays == 1 then
    playCount:settext('First play')
  else
    playCount:settext(plays .. ' plays')
  end
  ctx:addChild(host, playCount)

  local resetCount = ctx:BitmapText(FONTS.sans_serif)
  resetCount:hidden(1)
  resetCount:xy(83, -74)
  resetCount:zoom(.5)
  resetCount:diffuse(1, 1, 1, 0.6)
  resetCount:shadowlength(0)

  if BX_SaltyResets == 0 then
    resetCount:hidden(1)
    resetCount:settext('')
  else
    resetCount:settext(BX_SaltyResets .. ' resets')
  end
  ctx:addChild(host, resetCount)

  local freakyOffsetStats = ctx:BitmapText(FONTS.sans_serif)
  freakyOffsetStats:addcommand('DoText', function()
    if p1_avgoffset and p1_avgpoffset then
      freakyOffsetStats:settext('MEAN ' ..
        (math.floor(p1_avgoffset * 1000) / 1000) .. 'ms WMEAN ' .. (math.floor(p1_avgpoffset * 100) / 100) .. 'ms')
    else
      freakyOffsetStats:sleep(0.1)
      freakyOffsetStats:queuecommand('DoText')
    end
  end)
  freakyOffsetStats:hidden(0)
  freakyOffsetStats:xy(150, -128)
  freakyOffsetStats:zoom(0.4)
  freakyOffsetStats:shadowlength(0)
  freakyOffsetStats:horizalign('right')
  freakyOffsetStats:diffuse(0.9, 0.9, 0.9, 1)
  ctx:addChild(host, freakyOffsetStats)

  local regionMinimap = ctx:Quad()
  regionMinimap:hidden(1)
  --check UpdateSpellDisplayP1 for this actors behavior
  ctx:addChild(host, regionMinimap)


  scope.event:on('press', function(pn, btn)
    --forcing playernumber for now
    local pn = 1

    --line 212-231
    if pn == 1 and btn == "Left" then
      if oplot_hidden[pn] == 1 then
        --host:hidden(0)
      else
        --host:hidden(1)
      end
      curcard[pn] = 0;
      oplot_hidden[pn] = oplot_hidden[pn] * -1
      scope.event:call('UpdateSpellDisplayP1')
    end

    --line 234-250
    if pn == 1 and btn == "Up" then
      if oplot_spellCards[pn] then
        curcard[pn] = curcard[pn] - 1

        if oplot_hidden[pn] == 1 then
          host:hidden(0)
          curcard[pn] = 0
          oplot_hidden[pn] = -1
        end

        if curcard[pn] < 0 then
          curcard[pn] = table.getn(oplot_spellCards[pn])
        end
        scope.event:call('UpdateSpellDisplayP1')
      end
    end

    --line 252-266
    if pn == 1 and btn == "Down" then
      local pn = 1
      if oplot_spellCards[pn] then
        curcard[pn] = curcard[pn] + 1

        if oplot_hidden[pn] == 1 then
          host:hidden(0)
          curcard[pn] = 0
          oplot_hidden[pn] = -1
        end
        if curcard[pn] > table.getn(oplot_spellCards[pn]) then
          curcard[pn] = 0
        end
        scope.event:call('UpdateSpellDisplayP1')
      end
    end

    --TODO: wtf is StepP1MenuSelectMessageCommand
    --line 268-284
    if pn == 1 and btn == "MenuSelect" then
      if BX_DisplayedGraph == 'Life' then
        BX_DisplayedGraph = 'Timing'
        BX_CustomLifeGraph_1:hidden(1)
        BX_CustomLifeGraph_1bg:hidden(1)
        BX_CustomTimingGraph1:hidden(0)
      else
        BX_DisplayedGraph = 'Life'
        BX_CustomLifeGraph_1:hidden(0)
        BX_CustomLifeGraph_1bg:hidden(0)
        BX_CustomTimingGraph1:hidden(1)
      end
    end

    --happens for both players check line 1119
    if btn == "Right" then
      local pn = 2
      curcard[pn] = 0;
      oplot_hidden[pn] = oplot_hidden[pn] * -1
      scope.event:call('UpdateSpellDisplayP2')
    end
  end)

  scope.event:on('UpdateSpellDisplayP1', function()
    local pn = 1

    if curcard[pn] == 0 then
      if BX_DisplayedGraph == 'Life' then
        BX_CustomLifeGraph_1bg:hidden(0)
        BX_CustomTimingGraph1:hidden(1)
        BX_CustomLifeGraph_1:hidden(0)
      else
        BX_CustomLifeGraph_1bg:hidden(1)
        BX_CustomLifeGraph_1:hidden(1)
        BX_CustomTimingGraph1:hidden(0)
      end
    else
      BX_CustomLifeGraph_1bg:hidden(1)
      BX_CustomLifeGraph_1:hidden(1)
      BX_CustomTimingGraph1:hidden(1)
    end

    judgementHits:queuecommand('Make')

    --line 292-299
    if curcard[pn] == 0 then
      --background:y(0)
      unlabeledQuad1:x(70 + 12)
      unlabeledQuad1:y(-88)
      unlabeledQuad1:zoomto(135, 60)
      unlabeledQuad1:hidden(1)
      regionMarkers:hidden(0)
      judgementCountFrame:hidden(1)
      scrollbarDivider:hidden(1)
      scrollbarBg:hidden(1)
      scrollbarLocation:hidden(1)
      playCount:hidden(0)
      resetCount:hidden(0)
      regionMinimap:hidden(1)
    else
      background:y(-30)
      unlabeledQuad1:x(0)
      unlabeledQuad1:y(-88)
      unlabeledQuad1:zoomto(305, 60)
      unlabeledQuad1:hidden(1)
      regionMarkers:hidden(1)
      judgementCountFrame:zoomto(60, 114)
      judgementCountFrame:x(-152 + 31)
      judgementCountFrame:y(0)
      judgementCountFrame:hidden(0)
      local color = oplot_spellCards[pn][curcard[pn]].Color
      judgementCountFrame:diffuse(color[1] * 0.3, color[2] * 0.3, color[3] * 0.3, 1)
      scrollbarDivider:x(-148)
      scrollbarDivider:y(-30)
      scrollbarDivider:zoomto(8, 176)
      scrollbarDivider:hidden(0)
      scrollbarBg:x(-150)
      scrollbarBg:y(-30)
      scrollbarBg:zoomto(6, 176)
      scrollbarBg:hidden(0)
      scrollbarLocation:x(-150)
      scrollbarLocation:y(-30 - 88 + 8 + 160 * ((curcard[pn] - 1) / (table.getn(oplot_spellCards[pn]) - 1)))
      scrollbarLocation:zoomto(6, 16)
      scrollbarLocation:hidden(0)
      playCount:hidden(1)
      resetCount:hidden(1)

      regionMinimap:hidden(0)

      if not GAMESTATE:IsCourseMode() then
        local sc = oplot_spellCards[pn]
        local i = curcard[pn]
        local x1 = oplot_fitX((sc[i].StartBeat))
        --local x1 = oplot_fitX(0)
        local x2 = oplot_fitX((sc[i].EndBeat))

        regionMinimap:stretchto(x1, 60, x2, 92)
        regionMinimap:diffuseshift()
        regionMinimap:effectperiod(.5)
        regionMinimap:effectcolor1(sc[i].Color[1], sc[i].Color[2], sc[i].Color[3], sc[i].Color[4] * .4)
        regionMinimap:effectcolor2(sc[i].Color[1], sc[i].Color[2], sc[i].Color[3], sc[i].Color[4] * .1)
      else
        local sc = oplot_spellCards[pn]
        local i = curcard[pn]
        local x1 = oplot_fitXTimeBar(oplot_cumulativeTimeTime(0, i - 1))
        --local x1 = oplot_fitX(0)
        local x2 = oplot_fitXTimeBar(oplot_cumulativeTimeTime(oplot_songs[i]:StepsLengthSeconds(), i - 1))

        regionMinimap:stretchto(x1, 60, x2, 92)
        regionMinimap:diffuseshift()
        regionMinimap:effectperiod(.5)
        regionMinimap:effectcolor1(sc[i].Color[1], sc[i].Color[2], sc[i].Color[3], sc[i].Color[4] * .4)
        regionMinimap:effectcolor2(sc[i].Color[1], sc[i].Color[2], sc[i].Color[3], sc[i].Color[4] * .1)
      end
    end
  end)

  oplot_hidden[1] = 1
  host:hidden(0)
  scope.event:call('UpdateSpellDisplayP1')

  setDrawFunctionWithDT(host, function(dt)
    background:Draw()
    --unsure what this one does
    --unlabeledQuad1:Draw()
    regionMarkers:Draw()
    centerBar:Draw()
    judgementLines:Draw()

    --TODO: Track life
    --BX_CustomLifeGraph_1bg:Draw()
    --BX_CustomLifeGraph_1:Draw()

    judgementCountFrame:Draw()
    scrollbarDivider:Draw()
    scrollbarBg:Draw()
    scrollbarLocation:Draw()
    regionTitle:Draw()
    regionDifficulty:Draw()
    regionScore:Draw()
    regionFNs:Draw()
    regionEXs:Draw()
    regionGRs:Draw()
    regionDCs:Draw()
    regionWOs:Draw()
    regionMSs:Draw()
    judgementHits:Draw()

    BX_CustomTimingGraph1:Draw()
    resetContainer:Draw()

    lateMarker:Draw()
    earlyMarker:Draw()
    playCount:Draw()
    resetCount:Draw()
    freakyOffsetStats:Draw()
    --regionMinimap:Draw()
  end)

  return host
end