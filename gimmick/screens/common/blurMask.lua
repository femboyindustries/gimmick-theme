local DO_BLUR = true

---@param ctx Context
---@param maskFunc fun(ctx: Context): (fun(): nil) @ Given a Context, returns a drawfunction
function gimmick.common.blurMask(ctx, maskFunc)
  local blurShaderV = ctx:Shader('Shaders/blurMaskV.frag')
  local blurShaderH = ctx:Shader('Shaders/blurMaskH.frag')

  local blank = ctx:Quad()
  blank:diffuse(0, 0, 0, 1)
  blank:xywh(scx, scy, sw, sh)

  local maskDrawFunc = maskFunc(ctx)

  local maskAFT = ctx:ActorFrameTexture()

  maskAFT:SetWidth(dw)
  maskAFT:SetHeight(dh)
  maskAFT:EnableDepthBuffer(false)
  maskAFT:EnableAlphaBuffer(false)
  maskAFT:EnableFloat(false)
  maskAFT:EnablePreserveTexture(true)
  maskAFT:Create()

  local blurAFTV = ctx:ActorFrameTexture()

  blurAFTV:SetWidth(dw)
  blurAFTV:SetHeight(dh)
  blurAFTV:EnableDepthBuffer(false)
  blurAFTV:EnableAlphaBuffer(false)
  blurAFTV:EnableFloat(false)
  blurAFTV:EnablePreserveTexture(true)
  blurAFTV:Create()

  local blurSpriteV = ctx:Sprite()

  blurSpriteV:basezoomx(sw / dw)
  blurSpriteV:basezoomy(-sh / dh)
  blurSpriteV:x(scx)
  blurSpriteV:y(scy)

  local blurAFTH = ctx:ActorFrameTexture()

  blurAFTH:SetWidth(dw)
  blurAFTH:SetHeight(dh)
  blurAFTH:EnableDepthBuffer(false)
  blurAFTH:EnableAlphaBuffer(false)
  blurAFTH:EnableFloat(false)
  blurAFTH:EnablePreserveTexture(true)
  blurAFTH:Create()

  local blurSpriteH = ctx:Sprite()

  blurSpriteH:basezoomx(sw / dw)
  blurSpriteH:basezoomy(-sh / dh)
  blurSpriteH:x(scx)
  blurSpriteH:y(scy)

  blurShaderV:uniform1f('strength', 1)
  blurShaderV:uniform1f('radius', 25)
  blurShaderH:uniform1f('strength', 1)
  blurShaderH:uniform1f('radius', 25)

  blurSpriteH:addcommand('Init', function()
    blurShaderV:uniformTexture('samplerMask', maskAFT:GetTexture())
    blurShaderH:uniformTexture('samplerMask', maskAFT:GetTexture())
    blurSpriteV:SetShader(actorgen.Proxy.getRaw(blurShaderV))
    blurSpriteV:SetTexture(blurAFTV:GetTexture())
    blurSpriteH:SetShader(actorgen.Proxy.getRaw(blurShaderH))
    blurSpriteH:SetTexture(blurAFTH:GetTexture())
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