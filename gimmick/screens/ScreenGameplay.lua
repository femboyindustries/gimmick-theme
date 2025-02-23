return {
  Init = function(self)
    _G.SCREEN_WIDTH = SCREEN_HEIGHT/3*4
    _G.SCREEN_CENTER_X = _G.SCREEN_WIDTH/2
    _G.SCREEN_RIGHT = _G.SCREEN_WIDTH

    self:x2((sw - _G.SCREEN_WIDTH)/2)
  end,
  overlay = gimmick.ActorScreen(function(self, ctx, scope)
    local incorrect = ctx:Sprite('Graphics/incorrect.png')
    local snd = ctx:ActorSound('Sounds/incorrect.ogg')
    local shouldPause = false
    local once = true
    local pausedAt = 0

    local modEnabled = false --TODO: make this a torturemod on ScreenPlayerOptions\

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

    local letterbox = ctx:Quad()
    letterbox:diffuse(0, 0, 0, 1)

    scope.event:on('press', function(pn, key)
      if key == 'Start' and not gimmick.s.OverlayScreen.modules.pause.isPaused() then
        gimmick.s.OverlayScreen.modules.pause.pause()
        return true
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

      local w = (sw - _G.SCREEN_WIDTH)/2
      letterbox:xywh(w/2, scy, w, sh)
      letterbox:Draw()
      letterbox:xywh(sw-w/2, scy, w, sh)
      letterbox:Draw()
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx) end)
}