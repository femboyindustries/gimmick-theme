---@param ctx Context
---@param scope Scope
---@param maskFunc fun(ctx: Context): (fun():  nil) @ Given a Context, returns a drawfunction
---@param radius number?
function gimmick.common.blurMask(ctx, scope, maskFunc, radius)
  radius = radius or 25

  local blank = ctx:Quad()
  blank:diffuse(0, 0, 0, 1)
  blank:xywh(scx, scy, sw, sh)

  local maskDrawFunc = maskFunc(ctx)

  local maskAFT = aft(ctx, scope, true)

  local blurShaderV = ctx:Shader('Shaders/blurMask.frag')
  local blurShaderH = ctx:Shader('Shaders/blurMask.frag')
  blurShaderH:define('H', true)
  blurShaderH:compileImmediate()

  local fauxShader = ctx:Shader('Shaders/blurMaskFaux.frag')

  local blurAFTV, blurSpriteV = aftSpritePair(ctx, scope, true)

  local blurAFTH, blurSpriteH = aftSpritePair(ctx, scope, true)

  blurShaderV:uniform1f('strength', 1)
  blurShaderV:uniform1f('radius', radius)
  blurShaderH:uniform1f('strength', 1)
  blurShaderH:uniform1f('radius', radius)

  blurSpriteH:addcommand('Init', function()
    blurShaderV:uniformTexture('samplerMask', maskAFT:GetTexture())
    blurShaderH:uniformTexture('samplerMask', maskAFT:GetTexture())
    blurSpriteV:SetShader(actorgen.Proxy.getRaw(blurShaderV))
    blurSpriteH:SetShader(actorgen.Proxy.getRaw(blurShaderH))
    fauxShader:uniformTexture('samplerBack', blurAFTV:GetTexture())
  end)

  return function()
    if not save.data.settings.do_blur then
      blurAFTV:Draw()

      blank:Draw()
      maskDrawFunc()
      maskAFT:Draw()

      blurSpriteH:SetShader(actorgen.Proxy.getRaw(fauxShader))
      blurSpriteH:SetTexture(maskAFT:GetTexture())
      blurSpriteH:Draw()

      return
    end

    blurSpriteH:SetShader(actorgen.Proxy.getRaw(blurShaderH))
    blurSpriteH:SetTexture(blurAFTH:GetTexture())

    blurAFTV:Draw()

    blank:Draw()
    maskDrawFunc()
    maskAFT:Draw()

    blurSpriteV:Draw()
    blurAFTH:Draw()
    blurSpriteH:Draw()
  end
end