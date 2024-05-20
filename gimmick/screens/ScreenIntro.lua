local save = require 'gimmick.save'


local vids = getFolderContents('Graphics/intro/')



vids = filter(vids, function(value)
  local ending = ".mp4"
  return string.sub(value, - #ending) == ending
end)

local keyset = {}
for k in pairs(vids) do
    table.insert(keyset, k)
end
local choice = string.sub(vids[keyset[math.random(#keyset)]], 1, -5)
print(pretty(vids),choice)


return {
  Init = function(self, ctx)
    Trace('intro')
  end,
  overlay = gimmick.ActorScreen(function(self, ctx)
    if save.data.settings.show_bootup then
      local intro = ctx:Sprite('Graphics/intro/' .. choice .. '.mp4')
      intro:stretchto(0, 0, sw, sh)
      intro:animate(0)

      local wait = 0

      local sound = ctx:ActorSound('Graphics/intro/' .. choice .. '.ogg')
      sound:addcommand('Init', function(s)
        wait = s:get():GetLengthSeconds()
        s:get():Play()
        intro:animate(1)
        self:addcommand('penis', function()
          SCREENMAN:SetNewScreen('ScreenTitleMenu')
        end)
        self:sleep(wait)
        self:queuecommand('penis')
      end)
    else
      local q = ctx:Quad()
      q:stretchto(0,0,sw,sh)
      q:diffuse(0,0,0,1)

      self:addcommand('penis', function()
        SCREENMAN:SetNewScreen('ScreenTitleMenu')
      end)
      self:sleep(0.1)
      self:queuecommand('penis')
    end
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)

  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
  background = gimmick.ActorScreen(function(self, ctx) end),

  delay = save.data.settings.show_bootup and 99999 or -100

}