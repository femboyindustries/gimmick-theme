return {
  Init = function(self)
    for i = 1,2 do
      local arrow = self('Arrows'..i)
      arrow:x(SCREEN_CENTER_X + (i == 1 and -150 or 150))
    end

    for _,v in ipairs {'Song', 'Group'} do
      local child = self(v .. 'Banner')
      child:width(418)
      child:height(164)
      child:zoom(.5)
    end
    -- help
    local stb = self('SongTextBanner')
    self('SongBanner'):y(scy - 90)
    stb:y(scy - 90)
    self('GroupBanner'):y(scy - 140)

    for k,v in ipairs {'', 'Source'} do
      local child = self(v .. 'Meter')
      child:xy(scx + 170, scy - 10 + (60*(k-1)))
    end
  end,
  overlay = gimmick.ActorScreen(function(self, ctx) end),
  underlay = gimmick.common.background(function(ctx) return function() end end),
  Description = function(self)
    self:x(scx)
  end,
  Label = function(self)
    self:x(50) -- SCREEN_LEFT is 0. lmao
  end,
}