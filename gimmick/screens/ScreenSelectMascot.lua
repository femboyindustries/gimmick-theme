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
      halign = 0.5,
      valign = 0.5,
      width = 100,
      height = sh * 0.6,
    }
    local actors = {
      ctx:BitmapText(FONTS.sans_serif,'poop'),
      ctx:BitmapText(FONTS.sans_serif,'she'),
      ctx:BitmapText(FONTS.sans_serif,'andrew tate')
    }

    local bg = ctx:Quad()
    bg:diffuse(1,1,1,0.2)
    bg:xy(scx, scy)
    bg:SetWidth(config['width'])
    bg:SetHeight(config['height'])

    local af = flexbox(ctx,config,actors)
    af:xy(scx, scy)

    self:SetDrawFunction(function()
      bg:Draw()
      af:Draw()
    end)
    
  end),
}