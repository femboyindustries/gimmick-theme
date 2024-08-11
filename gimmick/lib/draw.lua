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
---@param scope Scope
---@param recreate boolean? @ Useful for OverlayScreens where the initialization step happens twice
function aft(ctx, scope, recreate)
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

  scope.event:on('resize', function(w, h)
    print(aft, 'resizing: ', w, 'x', h)
    aft:SetWidth(w)
    aft:SetHeight(h)
    aft:Recreate()
  end)

  return aft
end

---@param ctx Context
---@param scope Scope
---@param recreate boolean? @ Useful for OverlayScreens where the initialization step happens twice
function aftSpritePair(ctx, scope, recreate)
  local tex = aft(ctx, scope, recreate)
  local sprite = ctx:Sprite()

  sprite:basezoomx(sw / dw)
  sprite:basezoomy(-sh / dh)
  sprite:x(scx)
  sprite:y(scy)

  scope.event:on('resize', function(w, h)
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

---@param actor ActorFrame
---@param callback fun(dt: number): void
function setDrawFunctionWithDT(actor, callback)
  local lastT -- unset so the first tick is ignored
  actor:SetDrawFunction(function()
    lastT = lastT or os.clock()
    local t = os.clock()
    local dt = t - lastT
    lastT = t
    callback(dt)
  end)
end