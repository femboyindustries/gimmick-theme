local easable = require 'gimmick.lib.easable'
local mascots = require 'gimmick.mascots'

local function getChoicePos(i)
  return scx - 80 - i * 10, scy + i * 40
end

local active_i = 1 -- Default to the first element
local mascotPaths = {}
local mascotNames = mascots.getMascots()

for _, mascot in ipairs(mascotNames) do
  mascotPaths[#mascotPaths+1] = mascots.getPaths(mascot)
end


local choiceSelectedX = {}
local choiceSelectedY = {}
for i = 1, #mascotNames do
  choiceSelectedX[i] = easable(0, 28)
  choiceSelectedY[i] = easable(0, 28)
end

return {
  PrevScreen="ScreenTitleMenu",
  Init = function(self)
  end,

  underlay = gimmick.ActorScreen(function(self,ctx)
    local mascot_actors = {}
    local background_actors = {}

    for index, value in ipairs(mascotNames) do
      local actor = ctx:Sprite(mascotPaths[index]['character'])
      actor:scaletofit(0,0,sw*0.5,sh*0.5)
      actor:xy(scx*0.6,scy)
      actor:ztest(1)
      actor:zbuffer(1)
      table.insert(mascot_actors,actor)

      local background = ctx:Sprite(mascotPaths[index]['background'])
      background:scaletocover(0,0,sw,sh)

      table.insert(background_actors,background)
 
    end

    local cursor = easable(1,28)
    local angle_step = (2 * math.pi) / #mascot_actors -- Full circle divided by the number of actors

    --check if button was the pressed olast frame, if not dont update the pressed status
    local lastMenuRightPress = 0
    local menuRightCooldown = 0.1 -- Cooldown in seconds
    event.on('press',function(pn,button) 
      if(button == 'MenuRight') then
        local currentTime = os.clock() -- Get the current time
        if currentTime - lastMenuRightPress > menuRightCooldown then
          active_i = active_i+1
          cursor:set(active_i)
          lastMenuRightPress = currentTime -- Update the time of the last press
        end
      end

      if(button == 'MenuLeft') then
        local currentTime = os.clock() -- Get the current time
        if currentTime - lastMenuRightPress > menuRightCooldown then
          active_i = active_i-1
          cursor:set(active_i)
          lastMenuRightPress = currentTime -- Update the time of the last press
        end
      end
    end) --( imdex of actor - cursor/active -> math.sin ) * 5

    self:fov(60)

    local oldt = 0
    self:SetDrawFunction(function(self)
      local newt = os.clock()
      local dt = newt - oldt
      oldt = newt --t thands for thog

      cursor:update(dt)
      for i, mascot in ipairs(mascot_actors) do
        local a = (i - cursor.eased) * angle_step
        a = a % (2 * math.pi)
        local x, y = math.cos(a), math.sin(a)
        mascot:x((x*(sw*0.3))+scx)
        mascot:z((y*(sh*0.3)))
        mascot:Draw()
      end

    end)

  end)
}