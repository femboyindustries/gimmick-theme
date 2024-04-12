local options = require 'gimmick.options'

return {
  overlay = gimmick.ActorScreen(function(self, ctx)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
    local bg = ctx:Sprite('Graphics/_missing')
    bg:scaletocover(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),

  --- El soyjak
  lines = options.LineProvider('ScreenOptions', {
    options.option.settingToggle('Console (Ctrl+9)', 'console')
  }),
}
