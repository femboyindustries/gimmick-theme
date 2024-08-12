return {
  Init = function(self)
  end,
  overlay = gimmick.ActorScreen(function(self, ctx)
    local incorrect = ctx:Sprite('Graphics/incorrect.png')
    local snd = ctx:ActorSound('Sounds/incorrect.ogg')
    local shouldPause = false
    local once = true
    local pausedAt = 0

    local modEnabled = false --TODO: make this a torturemod on ScreenPlayerOptions

    incorrect:stretchto(0, 0, sw, sh)
    incorrect:hidden(1)
    incorrect:blend('add')


    incorrect:addcommand('Fk_P1_W6Message', function(self)
      shouldPause = true
    end)
    snd:addcommand('Fk_P1_W6Message', function(self)
      if modEnabled then
        self:get():Play()
      end
    end)

    self:SetDrawFunction(function()
      if shouldPause and modEnabled then
        SCREENMAN:GetTopScreen():PauseGame(true)
        incorrect:hidden(0)
        if once then
          once = false
          pausedAt = os.clock()
        end

        if os.clock() - pausedAt > 0.256 then
          SCREENMAN:GetTopScreen():PauseGame(false)
          shouldPause = false
          incorrect:hidden(1)
          once = true
        end
      end

      incorrect:Draw()
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx) end)
}