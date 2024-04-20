local function init(self)
  ---@type ActorFrame
  local screen = self('EditMenu')

  for i = 1,2 do
    local arrow = screen:GetChildAt(i - 1)
    arrow:x(SCREEN_CENTER_X + (i == 1 and -150 or 150))
  end

  for _,v in ipairs {'Song', 'Group'} do
    local child = screen(v .. 'Banner')
    child:SetWidth(418)
    child:SetHeight(164)
    child:zoom(.5)
  end
  -- help
  local stb = screen('SongTextBanner')
  screen('SongBanner'):y(scy - 90)
  stb:y(scy - 90)
  screen('GroupBanner'):y(scy - 140)

  for k,v in ipairs {'', 'Source'} do
    local child = screen(v .. 'Meter')
    child:xy(scx + 170, scy - 10 + (60*(k-1)))
  end
end

return {
  Init = function(self)
    self:addcommand('Ready', function() init(self) end)
    self:queuecommand('Ready')
  end,
  overlay = gimmick.ActorScreen(function(self, ctx)
  end),
  underlay = gimmick.common.background(function(ctx) return function() end end),
  Description = function(self)
    self:x(scx)
  end,
  Label = function(self)
    self:x(50) -- SCREEN_LEFT is 0. lmao
  end,
}