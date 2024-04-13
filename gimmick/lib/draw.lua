function drawBorders(actor, amp, passes)
  amp = amp or 1
  passes = passes or 1

  for x = -passes, passes do
    for y = -passes, passes do
      actor:xy2(x * amp, y * amp)
      actor:Draw()
    end
  end

  actor:xy2(0, 0)
end

---@param ctx Context
---@param recreate boolean? @ Useful for OverlayScreens where the initialization step happens twice
function aft(ctx, recreate)
  local aft = ctx:ActorFrameTexture()

  aft:SetWidth(dw)
  aft:SetHeight(dh)
  aft:EnableDepthBuffer(false)
  aft:EnableAlphaBuffer(false)
  aft:EnableFloat(false)
  aft:EnablePreserveTexture(true)
  aft:Create()
  if recreate then
    aft:Recreate()
  end

  event.on('resize', function(w, h)
    aft:SetWidth(w)
    aft:SetHeight(h)
    aft:Recreate()
  end)

  return aft
end

---@param ctx Context
---@param recreate boolean? @ Useful for OverlayScreens where the initialization step happens twice
function aftSpritePair(ctx, recreate)
  local tex = aft(ctx, recreate)
  local sprite = ctx:Sprite()

  sprite:basezoomx(sw / dw)
  sprite:basezoomy(-sh / dh)
  sprite:x(scx)
  sprite:y(scy)

  event.on('resize', function(w, h)
    sprite:basezoomx(sw / w)
    sprite:basezoomy(-sh / h)
    sprite:x(scx)
    sprite:y(scy)
  end)

  sprite:addcommand('Init', function()
    sprite:SetTexture(tex:GetTexture())
  end)

  return tex, sprite
end