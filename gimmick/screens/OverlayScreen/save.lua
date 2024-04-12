local M = {}

function M.init(self, ctx)
  return function(dt)
    if save.shouldSaveNextFrame then
      save.shouldSaveNextFrame = false
      save.save()
    end
  end
end

return M