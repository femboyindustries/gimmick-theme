local easable = require 'gimmick.lib.easable'

local function getChoicePos(i)
  return scx - 80 - i * 10, scy + i * 40
end




local active = {}
local mascot_paths = {}
local mascots = mascotList()

for _, mascot in ipairs(mascots) do
  mascot_paths[#mascot_paths+1] = getMascotPaths(mascot)
  active[#active+1] = false 
end

--this lets us wrap around the table
--e.g. assuming {1,2,3,4} we can do tbl[2] to get 2 but we can also do tbl[6] to get 2
local active_metatable = {
  __index = function(table,key)
    local actual_key = (key-1)%#table+1
    return rawget(table,actual_key)
  end
}
setmetatable(active,active_metatable)

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

      1,2,3,4,5,6
    ]]
  end),

  underlay = gimmick.ActorScreen(function(self,ctx)
    local mascot_actors = {}
    for index, value in ipairs(mascots) do
      local actor = ctx:Sprite(mascot_paths[index]['character'])
      actor:scaletofit(0,0,sw*0.5,sh*0.5)
      actor:xy(scx*0.6,scy)
      table.insert(mascot_actors,actor)
      active[4] = true
    end

    --check if button was the pressed olast frame, if not dont update the pressed status

    local lastMenuRightPress = 0
    local menuRightCooldown = 0.1 -- Cooldown in seconds
    event.on('press',function(pn,button) 
      if(button == 'MenuRight') then
        local currentTime = os.clock() -- Get the current time
        if currentTime - lastMenuRightPress > menuRightCooldown then
        local fart = search(active,true) --i remember when jill told me not to name things silly
        if not fart then return end --fortunately jill is currently in a vc playing shipwrecked 64 and not monitoring me :3
        active[fart] = false
        active[fart+1] = true
        lastMenuRightPress = currentTime -- Update the time of the last press
        end
      end
    end)

    self:SetDrawFunction(function(self)
      local active_i = 1 -- Default to the first element
      for i = 1, #active do
        if active[i] then
          active_i = i
          break
        end
      end
    
      for index, value in ipairs(mascot_actors) do
        local position_index = (index - active_i) % #mascot_actors
        if position_index < 0 then
          position_index = position_index + #mascot_actors
        end
        if position_index == 0 then
          value:xy(scx*0.6, scy) -- Active mascot
        elseif position_index < #mascot_actors / 2 then
          value:xy(scx*0.3, scy) -- Mascots before the active
        else
          value:xy(scx*0.9, scy) -- Mascots after the active
        end
        value:Draw()
      end
    end)
    
  end)
}