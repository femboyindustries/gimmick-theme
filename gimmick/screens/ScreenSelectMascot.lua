local easable = require 'gimmick.lib.easable'

local function getChoicePos(i)
  return scx - 80 - i * 10, scy + i * 40
end




local choices = {}
local mascots_actors = {}
local mascots = getFolderContents('Graphics/Mascots/')

local choiceSelected = {}
for i = 1, #choices do
  choiceSelected[i] = easable(0, 28)
end

return {
  PrevScreen="ScreenTitleMenu",
  Init = function(self)
    print('Init is good')
  end,
  underlay = gimmick.ActorScreen(function (self, ctx)
    local config = {
      x_pos = scx,
      y_pos = scy,
      halign = 0.5,
      valign = 0.5,
      width = 0,
      height = 300,
    }
    

    flexbox(ctx,config)
    
  end),
}