local M = {}

---@param ctx Context
function M.init(self, ctx)
  local savefile = ctx:Sprite('Graphics/savefile.png')
  savefile:xy(sw - 32, sh - 32)

  local text = ctx:BitmapText(FONTS.monospace, 'Saving...')
  text:halign(1)
  text:shadowlength(0)
  text:xy(sw - 32 - 16 - 8, sh - 32)
  text:zoom(0.4)

  local drewSavefile = false

  local function draw()
    text:diffuse(0, 0, 0, 1)
    drawBorders(text, 1)
    text:diffuse(1, 1, 1, 1)
    text:Draw()
    savefile:Draw()
  end

  return function(dt)
    if drewSavefile then
      drewSavefile = false
      save.save()
    end
    if save.shouldSaveNextFrame then
      save.shouldSaveNextFrame = false
      drewSavefile = true
      draw()
    end
  end
end

return M