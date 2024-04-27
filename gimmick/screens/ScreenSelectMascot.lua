local easable = require 'gimmick.lib.easable'
local mascots = require 'gimmick.mascots'
local TextPool = require 'gimmick.textpool'

local function getChoicePos(i)
  return scx - 80 - i * 10, scy + i * 40
end

local active_i = 1 -- Default to the first element
local selected = 1
local mascotPaths = {}
local mascotNames = mascots.getMascots()

for _, mascot in ipairs(mascotNames) do
  mascotPaths[#mascotPaths+1] = mascots.getPaths(mascot)
end


return {
  PrevScreen="ScreenTitleMenu",
  Init = function(self)
  end,

  overlay = gimmick.ActorScreen(function(self,ctx)
    local mascot_actors = {}
    local background_actors = {}

    local bmt = ctx:BitmapText(FONTS.sans_serif,'What the meow')
    bmt:xy(scx*1.5,scy*0.5)
    bmt:zoom(0.3)

    local bmt = TextPool.new(ctx, FONTS.sans_serif, nil, function(actor)
      actor:xy(scx*1.5,scy*0.5)
      actor:zoom(0.3)
    end)

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

    local description = bmt:get(mascots.getDescription(mascotNames[selected]))
    local name = bmt:get(mascotNames[selected])

    name:zoom(1)
    name:xy(scx*0.8,sh*0.9)

    local cursor = easable(1,28)

    --check if button was the pressed olast frame, if not dont update the pressed status
    local lastMenuRightPress = 0
    local menuRightCooldown = 0.1 -- Cooldown in seconds
    event.on('press', function(pn, button)
      if button == 'MenuRight' then
        local currentTime = os.clock()
        if currentTime - lastMenuRightPress > menuRightCooldown then
          selected = (selected % #mascotNames) + 1 
          active_i = active_i + 1
          cursor:set(active_i)
          lastMenuRightPress = currentTime
          description:settext(mascots.getDescription(mascotNames[selected]))
          name:settext(mascotNames[selected])
        end
      elseif button == 'MenuLeft' then
        local currentTime = os.clock()
        if currentTime - lastMenuRightPress > menuRightCooldown then
          selected = selected - 1
      if selected < 1 then  -- checks if it goes below 1 and wraps around to the last index
        selected = #mascotNames
      end
      active_i = active_i - 1
          cursor:set(active_i)
          lastMenuRightPress = currentTime
          description:settext(mascots.getDescription(mascotNames[selected]))
          name:settext(mascotNames[selected])
        end
      end
    end)

    self:fov(60)

    local darken = ctx:Quad()
    darken:diffuse(0,0,0,0.2)
    darken:stretchto(0,0,sw,sh)

    

    local oldt = 0
    local angle_step = (2 * math.pi) / #mascot_actors
    self:SetDrawFunction(function()
      background_actors[selected]:Draw()
      darken:Draw()
      

      local newt = os.clock()
      local dt = newt - oldt
      oldt = newt --t thands for thog
      cursor:update(dt)

      local offset = math.pi/2 - ((selected - active_i) * angle_step)
      for i, mascot in ipairs(mascot_actors) do
        local a = ((i - cursor.eased) * angle_step)+offset
        a = a % ((2 * math.pi))
        local x, y = math.cos(a), math.sin(a)
        if selected ~= i then
          mascot:diffusealpha(0.2)
        else
          mascot:diffusealpha(1)
        end
        mascot:x((x*(sw*0.3))+scx*0.8)
        mascot:z((y*(sh*0.3)))
        mascot:Draw()
        
      end
      description:Draw()
      name:Draw()
    end)

  end)
}