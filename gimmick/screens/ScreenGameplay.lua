--[=[

-- letterboxing fix hook
-- TODO find a better place to put this

local ActorFrameTexture_SetWidth = ActorFrameTexture.SetWidth
ActorFrameTexture.SetWidth = function(self, width)
  -- we want to only apply this with modfiles, not the theme
  local src = debug.getinfo(2, 'S')
  if string.lower(string.sub(src.source, 1, 9)) == '@/themes/' or string.lower(string.sub(src.source, 1, 10)) == '@./themes/' then
    return ActorFrameTexture_SetWidth(self, width)
  end

  print('[NOTICE] Intercepting ActorFrameTexture.SetWidth call; if something crashes, blame me!!!!!!')
  return ActorFrameTexture_SetWidth(self, width * (_G.SCREEN_WIDTH / sw))
end

--[[
we're looking for xero.sprite-esque sprite changes:

  self:basezoomx(sw / dw)

and rewriting them to look like:

  self:basezoomx(sw / [INJECTED_DW])

however, we don't know what sprites are aft sprites and what sprites aren't, so
we listen for SetTexture calls to determine that, and adjust the basezoomx
]]

-- this hook exists to store the raw basezoomx

local spriteBaseZoomX = {}
setmetatable(spriteBaseZoomX, { __mode = 'k' })

local Sprite_basezoomx = Sprite.basezoomx
Sprite.basezoomx = function(self, zoomx)
  -- we want to only apply this with modfiles, not the theme
  local src = debug.getinfo(2, 'S')
  if string.lower(string.sub(src.source, 1, 9)) ~= '@/themes/' and string.lower(string.sub(src.source, 1, 10)) ~= '@./themes/' then
    print('[NOTICE] Intercepting Sprite.basezoomx call; if something crashes, blame me!!!!!!')
    print('Storing sprite ' .. tostring(self) .. '\'s basezoomx: ', zoomx)
    spriteBaseZoomX[tostring(self)] = zoomx
  end
  return Sprite_basezoomx(self, zoomx)
end

-- then this is to determine if it's an aft sprite or not

local Sprite_SetTexture = Sprite.SetTexture
Sprite.SetTexture = function(self, texture)
  -- we want to only apply this with modfiles, not the theme
  local src = debug.getinfo(2, 'S')

  if string.lower(string.sub(src.source, 1, 9)) ~= '@/themes/' and string.lower(string.sub(src.source, 1, 10)) ~= '@./themes/' then
    print('[NOTICE] Intercepting Sprite.SetTexture call; if something crashes, blame me!!!!!!')
    print('Sprite: ' .. tostring(self))
    local isAFT = string.sub(texture:GetPath(), 1, 17) == 'ActorFrameTexture'
    local basezoomx = spriteBaseZoomX[tostring(self)] or 1
    if isAFT then
      print('Found AFT: ' .. texture:GetPath())
      print('basezoomx: ', basezoomx)
      print('sw / dw', _G.SCREEN_WIDTH / _G.DISPLAY_WIDTH)
      if math.abs(basezoomx - (_G.SCREEN_WIDTH / _G.DISPLAY_WIDTH)) < 0.01 then
        print('Yep, this looks like `sw / dw`. Not anymore it\'s not')
        self:basezoomx(_G.SCREEN_WIDTH / (_G.DISPLAY_WIDTH * (_G.SCREEN_WIDTH / sw)))
      end
      --self:basezoomx(basezoomx * (_G.SCREEN_WIDTH / sw))
    else
      -- don't touch basezoomx otherwise just incase
      --self:basezoomx(basezoomx)
    end
  end
  return Sprite_SetTexture(self, texture)
end
]=]

return {
  Init = function(self)
    -- clear out our cache
    --for k in pairs(spriteBaseZoomX) do spriteBaseZoomX[k] = nil end

    _G.SCREEN_WIDTH = SCREEN_HEIGHT/3*4
    _G.SCREEN_CENTER_X = _G.SCREEN_WIDTH/2
    _G.SCREEN_RIGHT = _G.SCREEN_WIDTH
    _G.DISPLAY_WIDTH = _G.DISPLAY_HEIGHT/3*4
    _G.DISPLAY_RIGHT = _G.DISPLAY_WIDTH
    _G.DISPLAY_CENTER_X = _G.DISPLAY_WIDTH/2
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