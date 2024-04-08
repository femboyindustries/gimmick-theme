local BLUR_WIDTH = 400
local BLUR_SKEW = 80

return {
  --Init = function(self)
  --  print('hello from ScreenTitleMenu')
  --  print(actorToString(self))
  --end,
  underlay = gimmick.ActorScreen(function(self, ctx)
    local blank = ctx:Quad()
    blank:diffuse(0, 0, 0, 1)

    local logo = ctx:Sprite('Graphics/NotITG')
    logo:xy(scx, scy - 50)
    logo:zoom(1)

    self:SetDrawFunction(function()
      -- GAMESTATE:GetSongTime() kind of snaps in the first few frames, prob will add an aux to this later
      -- edit: I do not feel like adding multiple aux actors for this rn -rya
      blank:xywh(scx - BLUR_WIDTH/2, scy, 2, sh)
      blank:skewx((BLUR_SKEW / 2) + math.sin(GAMESTATE:GetSongTime() / 2) * 10)
      blank:Draw()
      blank:xywh(scx + BLUR_WIDTH/2, scy, 2, sh)
      blank:skewx((BLUR_SKEW / 2) + math.sin(GAMESTATE:GetSongTime() / 2) * 10)
      blank:Draw()

      logo:diffuse(0, 0, 0, 1)
      drawBorders(logo, 2)

      logo:diffuse(1, 1, 1, 1)
      logo:Draw()
    end)
  end),
  background = gimmick.common.background(function(ctx)
    local mask = ctx:Quad()
    mask:diffuse(1, 0.6, 0.5, 1)
    mask:xywh(scx, scy, BLUR_WIDTH, sh)
    return function()
      mask:skewx((BLUR_SKEW / BLUR_WIDTH) + math.sin(GAMESTATE:GetSongTime() / 2) * 0.05)
      mask:Draw()
    end
  end),
  choices = gimmick.ChoiceProvider({
    {
      name = 'Play',
      command = 'stopmusic;style,versus;PlayMode,regular;lua,function() PREFSMAN:SetPreference(\'InputDuplication\',1) end;Difficulty,beginner;deletepreparedscreens;screen,ScreenSelectMusic',
    },
    {
      name = 'Edit',
      command = 'stopmusic;screen,ScreenEditMenu',
    },
    {
      name = 'Options',
      command = 'stopmusic;screen,ScreenOptionsMenu',
    },
    {
      name = 'Exit',
      command = 'stopmusic;screen,ScreenExit'
    }
  })
}