
return {
    Init = function(self) Trace('theme.com') end,
    overlay = gimmick.ActorScreen(function(self, ctx)
    end),
    underlay = gimmick.ActorScreen(function(self, ctx)
    end),
    header = gimmick.ActorScreen(function(self, ctx)
    end),
    footer = gimmick.ActorScreen(function(self, ctx)
    end),

    Choices = gimmick.LineProvider({
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
    }),

    Line1 = function()
        local t = gimmick.OptionRowBase()

        return t
	end
}
        