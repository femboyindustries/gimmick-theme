
return {
  Init = function(self)
    if not gimmick.getSaved() then
      gimmick.saveInit()
    end
  end,
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
  Line1 = function()
    local t = gimmick.OptionRowBase('Console (Ctrl+9)')

    t.Choices = {'ON', 'OFF'}
    t.LayoutType = 'ShowAllInRow'
    t.LoadSelections = function(self,list) 
      local option = search(t.Choices,gimmick.getSavedOption('Console')) or 1 
      list[option] = true 
    end
    t.SaveSelections = function(self,list)
      gimmick.ezSave('Console',t.Choices[search(list,true)] or 1)
    end

    return t
	end
}
        