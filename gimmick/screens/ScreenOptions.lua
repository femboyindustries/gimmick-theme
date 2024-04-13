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
    {
      type = 'lua',
      optionRow = options.option.settingChoice('Console Layout', 'console_layout', keys(require 'gimmick.lib.layouts')),
    },
    {
      type = 'conf',
      pref = 'SoundVolume',
    },
    {
      type = 'conf',
      pref = 'AspectRatio',
    },
    {
      type = 'conf',
      pref = 'EventMode',
    },
    {
      type = 'lua',
      optionRow = options.option.button('Button that creates a SystemMessage that says "penis"', 'Button that creates a SystemMessage that says "penis"', function()
        SCREENMAN:SystemMessage('penis')
        delayedSetScreen('ScreenOptionsMenu')
      end)
    }
  }),
}
