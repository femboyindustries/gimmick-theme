local DO_BLUR = true

---@param ctx Context
---@param maskFunc fun(ctx: Context): (fun(): nil) @ Given a Context, returns a drawfunction
---@param radius number?
function gimmick.common.blurMask(ctx, maskFunc, radius)
  radius = radius or 25

  local blurShaderV = ctx:Shader('Shaders/blurMask.frag')
  local blurShaderH = ctx:Shader('Shaders/blurMask.frag')
  blurShaderH:define('H', true)
  blurShaderH:compileImmediate()

  local blank = ctx:Quad()
  blank:diffuse(0, 0, 0, 1)
  blank:xywh(scx, scy, sw, sh)

  local maskDrawFunc = maskFunc(ctx)

  local maskAFT = aft(ctx, true)

  local blurAFTV, blurSpriteV = aftSpritePair(ctx, true)

  local blurAFTH, blurSpriteH = aftSpritePair(ctx, true)

  blurShaderV:uniform1f('strength', 1)
  blurShaderV:uniform1f('radius', radius)
  blurShaderH:uniform1f('strength', 1)
  blurShaderH:uniform1f('radius', radius)

  blurSpriteH:addcommand('Init', function()
    blurShaderV:uniformTexture('samplerMask', maskAFT:GetTexture())
    blurShaderH:uniformTexture('samplerMask', maskAFT:GetTexture())
    blurSpriteV:SetShader(actorgen.Proxy.getRaw(blurShaderV))
    blurSpriteH:SetShader(actorgen.Proxy.getRaw(blurShaderH))
  end)

  return function()
    blurAFTV:Draw()

    blank:Draw()
    maskDrawFunc()
    maskAFT:Draw()

    blurSpriteV:Draw()
    blurAFTH:Draw()
    blurSpriteH:Draw()
  end
end