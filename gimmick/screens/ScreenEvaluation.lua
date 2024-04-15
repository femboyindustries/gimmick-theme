local AWESOME = false

return {
  Init = function(self) Trace('theme.com') end,
  overlay = gimmick.ActorScreen(function(self, ctx)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
    if AWESOME then
      local awesome = ctx:Sprite('Graphics/awesome.png')
      awesome:xy(scx, scy)
      awesome:zoom(0.5)

      local oldT = os.clock()
      local t = 0

      self:SetDrawFunction(function()
        local newT = os.clock()
        local dt = newT - oldT
        oldT = newT
        t = t + dt

        awesome:diffusealpha(clamp(t - 3, 0, 1))
        awesome:Draw()

        if t > 5 then
          GAMESTATE:Crash('it would be so awesome')
        end
      end)

      return
    end

    
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}
