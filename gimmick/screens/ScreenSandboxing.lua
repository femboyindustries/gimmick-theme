bar = require 'gimmick.bar'
local a = true
return {
  Init = function(self) Trace('theme.com') end,
  overlay = gimmick.ActorScreen(function(self, ctx)
    local bar1 = bar:new(ctx)

    bar1:addcommand('init', function()
      --bar:sub(0.2)
      bar:set(4)
    end)
    bar:set(2.4)
    local oldt = os.clock()
    local timer = 2

    setDrawFunctionWithDT(self, function(dt)
      if bar:getBarLevel() < 0.1 then
      end
      bar1:Draw()

      if timer < 1.5 and timer > 1.45 then
        --bar:set(2.1)
      end

      if timer < 0.1 then
        timer = 2
        if math.random() < 0.5 then
          bar:sub(math.random())
        else
          bar:add(math.random())
        end

      end
      timer = timer - dt
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}