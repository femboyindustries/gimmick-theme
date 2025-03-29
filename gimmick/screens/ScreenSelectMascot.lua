local easable = require 'gimmick.lib.easable'
local mascots = require 'gimmick.mascots'
local TextPool = require 'gimmick.textpool'
local save = require 'gimmick.save'

--the index that will be saved
local active_i = 1
--displayed selection
local selected = 1
local cursor = easable(1, 28)


local mascotPaths = {}
local mascotNames = mascots.getMascots()
for _, mascot in ipairs(mascotNames) do
  mascotPaths[#mascotPaths + 1] = mascots.getPaths(mascot)
end

if save.data.settings.mascot_enabled then
  local res = find(mascotNames,save.data.settings.mascot)
  if res then
    active_i,selected = res,res
    cursor:reset(res)
  end
end


-- Register the input event handling outside of the returned table
local lastMenuRightPress = 0
local menuRightCooldown = 0.05

-- Define the function to handle input events, you can register it outside the table
local function handleInputEvents(pn, button)
  if SCREENMAN:GetTopScreen():GetName() == 'ScreenSelectMascot' then
    local currentTime = os.clock()
    if button == 'MenuRight' or button == 'MenuLeft' then
      if currentTime - lastMenuRightPress > menuRightCooldown then
        if button == 'MenuRight' then
          selected = (selected % #mascotNames) + 1
          active_i = active_i + 1
        elseif button == 'MenuLeft' then
          selected = selected - 1
          if selected < 1 then
            selected = #mascotNames
          end
          active_i = active_i - 1
        end
        lastMenuRightPress = currentTime
        cursor:set(active_i)
      end
    elseif button == 'Start' then
      print('gay people tomorrow 10am')
      save.data.settings.mascot = mascotNames[selected]
      save.save()
      SCREENMAN:SystemMessage("Your mascot is now: "..mascotNames[selected])
    end
  end
end

return {
  PrevScreen = "ScreenSelectOptions",
  Init = function(self)
  end,

  overlay = gimmick.ActorScreen(function(self, ctx, scope)
    scope.event:on('press', handleInputEvents) -- Register the event handler

    local mascot_actors = {}
    local background_actors = {}
    local bmt = TextPool.new(ctx, FONTS.sans_serif, nil, function(actor)
      actor:xy(scx * 1.5, scy * 0.5)
      actor:zoom(0.3)
    end)

    for index, value in ipairs(mascotNames) do
      local actor = ctx:Sprite(mascotPaths[index]['character'])
      actor:scaletofit(0, 0, sw * 0.5, sh * 0.5)
      actor:xy(scx * 0.6, scy)
      actor:ztest(1)
      actor:zbuffer(1)
      table.insert(mascot_actors, actor)

      local background = ctx:Sprite(mascotPaths[index]['background'])
      background:scaletocover(0, 0, sw, sh)
      table.insert(background_actors, background)
    end

    local description = bmt:get(mascots.getDescription(mascotNames[selected]))
    local name = bmt:get(mascotNames[selected])
    local disclaimer = bmt:get('Press Enter to save your selection!')

    disclaimer:zoom(0.7)
    disclaimer:xy(scx,scy*0.2)

    name:zoom(1)
    name:xy(scx * 0.8, sh * 0.9)

    self:fov(70)
    local darken = ctx:Quad()
    darken:diffuse(0, 0, 0, 0.2)
    darken:stretchto(0, 0, sw, sh)

    local angle_step = (2 * math.pi) / #mascot_actors

    setDrawFunctionWithDT(self, function(dt)
      -- Update background and darken effect
      background_actors[selected]:Draw()
      darken:Draw()

      
      description:settext(mascots.getDescription(mascotNames[selected]))
      name:settext(mascotNames[selected])

      cursor:update(dt)

      local offset = math.pi / 2 - ((selected - active_i) * angle_step)
      for i, mascot in ipairs(mascot_actors) do
        if selected == i then
          local t = os.clock()
          local timescale = 5
          mascot:diffusealpha(1)
          mascot:x2(math.sin(t*timescale)*15)
          mascot:y2(math.abs(math.cos((t*timescale)-math.pi)*10)*-1)
          mascot:rotationz(math.cos(t*timescale+math.pi)*5)
        else
          mascot:x2(0)
          mascot:y2(0)
          mascot:rotationz(0)
          mascot:diffusealpha(0.2)
        end
        local a = ((i - cursor.eased) * angle_step) + offset
        a = a % (2 * math.pi)
        local x, y = math.cos(a), math.sin(a)
        mascot:x((x * (sw * 0.3)) + scx * 0.8)
        mascot:z((y * (sh * 0.3)))
        mascot:Draw()
      end
      disclaimer:Draw()
      description:Draw()
      name:Draw()
    end)
  end)
}
