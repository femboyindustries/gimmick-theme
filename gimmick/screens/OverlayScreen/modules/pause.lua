---@param ctx Context
---@param scope Scope
return function (ctx, scope)
  local pauseQuad = ctx:Quad()
  local pauseText = ctx:BitmapText(FONTS.sans_serif)
  local paused = false
  local pauseButtonIdx = 1
  local pauseButtons = {
    { 'Resume', function()
      SCREENMAN:GetTopScreen():PauseGame(false)
      SCREENMAN:SetInputMode(0)
      -- todo: disqualify player
    end },
    { 'Restart', function()
      SCREENMAN:GetTopScreen():playcommand('Off')
      GAMESTATE:ApplyGameCommand('mod, clearall, 3x, Overhead, scalable')
      SCREENMAN:SetNewScreen('ScreenGameplay')
    end },
    { 'Exit', function()
      SCREENMAN:GetTopScreen():playcommand('Off')
      GAMESTATE:ApplyGameCommand('mod, clearall, 3x, Overhead, scalable')
      SCREENMAN:SetNewScreen('ScreenSelectMusic')
    end },
  }

  local M = {}
  
  function M.pause()
    paused = true
    SCREENMAN:GetTopScreen():PauseGame(true)
    SCREENMAN:SetInputMode(1)
  end
  function M.unpause()
    paused = false
    SCREENMAN:GetTopScreen():PauseGame(false)
    SCREENMAN:SetInputMode(0)
  end
  function M.isPaused()
    return paused
  end

  -- using global events to cancel presses
  event:on('press', function(pn, key)
    if not paused then return end
    if key == 'MenuDown' or key == 'MenuRight' then
      pauseButtonIdx = pauseButtonIdx + 1
      if pauseButtonIdx > #pauseButtons then pauseButtonIdx = 1 end
    end
    if key == 'MenuUp' or key == 'MenuLeft' then
      pauseButtonIdx = pauseButtonIdx - 1
      if pauseButtonIdx < 1 then pauseButtonIdx = #pauseButtons end
    end
    if key == 'Start' then
      M.unpause()
      pauseButtons[pauseButtonIdx][2]()
    end
    return true
  end)

  function M.draw()
    if not paused then return end

    pauseQuad:xywh(scx, scy, sw, sh)
    pauseQuad:diffuse(0, 0, 0, 0.4)
    pauseQuad:Draw()

    pauseText:settext('Paused')
    pauseText:diffuse(0.7, 0.7, 0.7, 1)
    pauseText:zoom(0.6)
    pauseText:xy(scx, 40)
    pauseText:Draw()

    for i, opt in ipairs(pauseButtons) do
      local selected = pauseButtonIdx == i
      if selected then
        pauseText:diffuse(1, 0, 1, 1)
      else
        pauseText:diffuse(1, 1, 1, 1)
      end
      pauseText:settext(opt[1])
      pauseText:zoom(0.45)
      pauseText:xy(scx, scy + ((i - 1) - (#pauseButtons - 1)/2) * 24)
      pauseText:Draw()
    end
  end
  
  return M
end