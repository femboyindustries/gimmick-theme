local easable = require 'gimmick.lib.easable'

local function getChoicePos(i)
  return scx - 80 - i * 10, scy + i * 40
end


local selected_index = 0
local mascot_paths = {}
local mascots = getFolderContents('Graphics/Mascots/')

for _, mascot in ipairs(mascots) do
  mascot_paths[#mascot_paths+1] = getMascotPath(mascot,true)
end

local choiceSelected = {}
for i = 1, #mascots do
  choiceSelected[i] = easable(0, 28)
end

return {
  PrevScreen="ScreenTitleMenu",
  Init = function(self)
  end,
  underlay3 = gimmick.ActorScreen(function (self, ctx)
    --[[
      --Look mom im introducing technical debt
      local config = {
        halign = 0.5,
        valign = 0.5,
        width = 100,
        height = sh * 0.6,
      }
      local actors = {}
      for _, value in ipairs(mascots) do
        actors[#actors+1] = ctx:BitmapText(FONTS.sans_serif,value)
      end

      for _, value in ipairs(actors) do
        value:zoom(0.5)
        value:shadowlength(0)
      end

      local bg = ctx:Quad()
      bg:diffuse(1,1,1,0.2)
      bg:xy(scx, scy)
      bg:SetWidth(config['width'])
      bg:SetHeight(config['height'])

      local af = flexbox(ctx,config,actors)
      af:xy(scx, scy)

      self:SetDrawFunction(function()
        --bg:Draw()
        af:Draw()
      end)
    ]]
  end),

  underlay = gimmick.ActorScreen(function(self,ctx)
    local mascot_actors = {}
    for index, value in ipairs(mascots) do
      local actor = ctx:Sprite(mascot_paths[index])
      actor:scaletofit(0,0,sw*0.5,sh*0.5)
      actor:xy(scx,scy)
      table.insert(mascot_actors,actor)
    end

    --check if button was the pressed olast frame, if not dont update the pressed status
    event.on('press',function(pn,button) 
      if(button == 'MenuUp') then
        print('up')
      end
    end)

    self:SetDrawFunction(function(self)
      for index, value in ipairs(mascot_actors) do
        value:Draw()
      end
    end)
  end)
}