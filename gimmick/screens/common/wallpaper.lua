local USE_SHADER = false

---@param ctx Context
function gimmick.common.wallpaper(ctx)
  local bgShaderSpr
  if USE_SHADER then
    local bgShader = ctx:Shader('Shaders/topologica.frag')
    bgShaderSpr = ctx:Sprite('Graphics/_missing.png')
    bgShaderSpr:xywh(scx, scy, sw, sh)
    bgShaderSpr:diffuse(1, 0, 1, 1)
    bgShaderSpr:tween(9e9, function()
      bgShader:uniform1f('ptime', os.clock())
    end)

    bgShaderSpr:addcommand('Init', function(self)
      self:SetShader(actorgen.Proxy.getRaw(bgShader))
    end)
  else
    bgShaderSpr = ctx:Sprite('Graphics/background.png')
    bgShaderSpr:scaletocover(0, 0, sw, sh)
  end

  return function()
    bgShaderSpr:Draw()
  end
end