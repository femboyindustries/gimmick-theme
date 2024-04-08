---@param maskFunc fun(ctx: Context): (fun(): nil) @ Given a Context, returns a drawfunction
function gimmick.common.background(maskFunc)
  return gimmick.ActorScreen(function(self, ctx)
    local blur = gimmick.common.blurMask(ctx, maskFunc)

    local blank = ctx:Quad()
    blank:diffuse(0, 0, 0, 1)
    blank:xywh(scx, scy, sw, sh)

    local drawWallpaper = gimmick.common.wallpaper(ctx)

    self:SetDrawFunction(function()
      blank:diffuse(0, 0, 0, 1)
      blank:xywh(scx, scy, sw, sh)
      blank:skewx(0)
      blank:Draw()

      drawWallpaper()

      blur()
    end)
  end)
end