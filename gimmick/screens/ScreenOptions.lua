
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

    Line01 = {
	
		Name = "Weight",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = AllChoices(),
		LoadSelections = function(self, list, pn)
			local val = PROFILEMAN:GetProfile(pn):GetWeightPounds()
			if val <= 0 then val = 100 end
			for i = 1,table.getn(self.Choices) do
				if val == IndexToPounds(i) then
					list[i] = true
					return
				end
			end
			list[20] = true -- 100 lbs
		end,
		SaveSelections = function(self, list, pn)
			for i = 1,table.getn(self.Choices) do
				if list[i] then
					PROFILEMAN:GetProfile(pn):SetWeightPounds( IndexToPounds(i) )
					return
				end
			end
		end,
	}	
}
        