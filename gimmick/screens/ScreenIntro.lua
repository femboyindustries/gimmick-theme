local save = require 'gimmick.save'

function unique(array)
  local seen = {}
  local result = {}

  for key, value in pairs(array) do
      if not seen[value] then
          result[key] = value
          seen[value] = true
      end
  end

  return result
end

local vids = getFolderContents('Graphics/intro/')
print('BITCH',pretty(vids))

vids = filter(vids, function(value)
  local ending = ".mp4"
  return string.sub(value, - #ending) == ending
end)

vids = unique(vids)

print('FUCK',pretty(vids))
local keyset = {}
local choices = {}
for k, v in pairs(vids) do
  table.insert(keyset, k)
  table.insert(choices, #choices + 1, string.sub(v, 1, -5))
end

--local choice = string.sub(vids[keyset[math.random(#keyset)]], 1, -5)



return {
  Init = function(self, ctx)
    Trace('intro')
  end,
  overlay = gimmick.ActorScreen(function(self, ctx)
    if save.data.settings.show_bootup then
      --[[
      local intro = ctx:Sprite('Graphics/intro/' .. choice .. '.mp4')

      intro:stretchto(0, 0, sw, sh)

      local wait = 0

      local sound = ctx:ActorSound('Graphics/intro/' .. choice .. '.ogg')

      intro:animate(1)
      sound:addcommand('Init', function(s)

        wait = s:get():GetLengthSeconds()
        s:get():Play()
        --intro:animate(1)
        self:addcommand('penis', function()

          intro:animate(0)
          error('fuck')
        end)

        self:sleep(wait)
        self:queuecommand('penis')

      end)
      ]]

      local sounds = {}
      local selected_sounds = {}

      for index, value in ipairs(choices) do
        print('hello!', value)
        local sound = ctx:ActorSound('Graphics/intro/' .. value .. '.ogg')
        local video = ctx:Sprite('Graphics/intro/' .. value .. '.mp4')
        video:hidden(1)
        video:animate(0)
        video:stretchto(0, 0, sw, sh)
        sound:addcommand('Init', function(s)
          table.insert(sounds, {
            sound = sound,
            video = video,
            length = s:get():GetLengthSeconds(),
          })
        end)

        sound:addcommand('Play', function(s)
          s:get():Play()
        end)
        video:addcommand('Play', function(s)
          s:hidden(0)
          s:animate(1)
        end)
        sound:addcommand('Stop', function(s)
          s:stop()
        end)
        video:addcommand('Stop', function(s)
          s:hidden(1)
          s:animate(0)
        end)
      end

      self:addcommand('penis', function()
        SCREENMAN:SetNewScreen('ScreenTitleMenu')
      end)

      self:addcommand('On', function()
        -- Shuffle sounds to ensure random order
        for i = #sounds, 2, -1 do
          local j = math.random(i)
          sounds[i], sounds[j] = sounds[j], sounds[i]
        end

        local total_length = 0

        -- Select sounds and calculate total length
        for _, sound in ipairs(sounds) do
          if total_length + sound.length < tonumber(save.data.settings.bootup_duration) then
            table.insert(selected_sounds, sound)
            total_length = total_length + sound.length
          end
        end

        local wait = 0
        for index, entry in ipairs(selected_sounds) do
          entry.sound:sleep(wait)
          entry.video:sleep(wait)

          wait = wait + entry.length

          entry.sound:queuecommand('Play')
          entry.video:queuecommand('Play')

          entry.sound:sleep(entry.length)
          entry.video:sleep(entry.length)

          entry.sound:queuecommand('Stop')
          entry.video:queuecommand('Stop')
        end

        self:sleep(total_length)
        self:queuecommand('penis')
      end)
    else
      local q = ctx:Quad()
      q:stretchto(0, 0, sw, sh)
      q:diffuse(0, 0, 0, 1)

      self:addcommand('penis', function()
        SCREENMAN:SetNewScreen('ScreenTitleMenu')
      end)
      self:sleep(0.00000001)
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