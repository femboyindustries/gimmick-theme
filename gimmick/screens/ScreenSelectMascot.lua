local easable = require 'gimmick.lib.easable'

local function getChoicePos(i)
  return scx - 80 - i * 10, scy + i * 40
end

local choices = {}
local mascots = getFolderContents('Graphics/Mascots/')

for index, value in ipairs(mascots) do
  choices[index] = {name = value,command='stopmusic;'}
end

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
    local render_targets = {}
    for index, mascot in ipairs(mascots) do
        local bmt = ctx:BitmapText(FONTS.monospace,mascot)
        bmt:xy(scx,scy*(1+index*0.1))
        render_targets[index] = bmt
    end

    self:SetDrawFunction(function()
      for i, target in ipairs(render_targets) do
          target:Draw()
      end
    end)
  end),
}