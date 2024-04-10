local BLUR_WIDTH = 400
local BLUR_SKEW = 80

local BACK_C = hex('19232a')

return {
  --Init = function(self)
  --  print('hello from ScreenTitleMenu')
  --  print(actorToString(self))
  --end,
  underlay = gimmick.ActorScreen(function(self, ctx)
    local blank = ctx:Quad()
    blank:diffuse(BACK_C:unpack())

    local logo = ctx:Sprite('Graphics/NotITG')
    logo:xy(scx, scy - 50)
    logo:zoom(1)

    self:SetDrawFunction(function()
      blank:xywh(scx, scy, BLUR_WIDTH - 60, sh)
      blank:skewx((BLUR_SKEW + math.sin(os.clock() / 2) * 10) / (BLUR_WIDTH - 60))
      blank:Draw()

      logo:diffuse(BACK_C:unpack())
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
      mask:skewx((BLUR_SKEW + math.sin(os.clock() / 2) * 10) / BLUR_WIDTH)
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
      name = 'Elevate to Admin',
      command = 'stopmusic;screen,ScreenMayf'
    },
    {
      name = 'Exit',
      command = 'stopmusic;screen,ScreenExit'
    }
  })
}