local easable = require 'gimmick.lib.easable'
local mascots = require 'gimmick.mascots'
require 'gimmick.lib.vector2D'

local function getChoicePos(i)
  return scx - 80 - i * 10, scy + i * 40
end

local particles = {}

function spawnParticle()
  table.insert(particles, {
    pos = vector(math.random(0,sw), 0),
    vel = vector(math.random()*50-25, math.random()*60-30),
  })
end

local GRAVITY = 10
local FRICTION = 0.99

local spawnT = 0

local choices = {
  {
    name = 'Play',
    command = 'stopmusic;style,versus;PlayMode,regular;lua,function() PREFSMAN:SetPreference(\'InputDuplication\',1) end;Difficulty,beginner;deletepreparedscreens;screen,ScreenSelectMusic',
  },
  {
    name = 'Edit',
    command = 'stopmusic;screen,ScreenEditMenu',
  },
  {
    name = 'Options',
    command = 'stopmusic;screen,ScreenOptionsMenu',
  },
  {
    name = 'Elevate to Admin',
    command = 'stopmusic;screen,ScreenMayf'
  },
  {
    name = 'TEMP - Choose Mascot',
    command = 'stopmusic;screen,ScreenSelectMascot'
  },
  {
    name = 'Exit',
    command = 'stopmusic;screen,ScreenExit'
  }
}

local choiceSelected = {}
for i = 1, #choices do
  choiceSelected[i] = easable(0, 28)
end

return {
  Init = function(self)
    gimmick.s.ScreenOptionsMenu.resetStack()
  end,
  underlay = gimmick.ActorScreen(function(self, ctx)
    local gradShader = ctx:Shader('Shaders/grad.frag')
    gradShader:uniform2f('res', dw, dh)
    gradShader:uniform4f('col1', hex('fe8257'):unpack())
    gradShader:uniform4f('col2', hex('cd63f4'):unpack())

    local grad = ctx:Sprite('Graphics/white.png')

    grad:addcommand('Init', function(s) s:SetShader(actorgen.Proxy.getRaw(gradShader)) end)

    local logo = ctx:Sprite('Graphics/NotITG')

    logo:addcommand('Init', function(s) s:SetShader(actorgen.Proxy.getRaw(gradShader)) end)


    if save.data.settings.mascot_enabled then
      char = ctx:Sprite(mascots.getPaths(save.data.settings.mascot)['character'])
      if save.data.settings.mascot == 'jolly' then
        --char:vibrate()
        --char:effectmagnitude(1,1,1)
        char:zoom(sw*0.0006)
      else
        char:scaletofit(scx*1.3,scy*0.1,sw*0.95,sh*0.9)
        char:xy(SCREEN_WIDTH*0.83,scy)
      end
      
    end

    local oldt = os.clock()
    self:SetDrawFunction(function()
      local newt = os.clock()
      local dt = newt - oldt
      oldt = newt

      --blank:xywh(scx, scy, BLUR_WIDTH - 60, sh)
      --blank:skewx((BLUR_SKEW + math.sin(os.clock() / 2) * 10) / (BLUR_WIDTH - 60))
      --blank:Draw()

      local zoom = 0.9
      logo:zoom(zoom)
      local x, y = scx - 100, scy - 90
      local w, h = logo:GetWidth() * zoom, logo:GetHeight() * zoom
      logo:xy(x, y)
      gradShader:uniform1f('top', (y - h/2)/sh)
      gradShader:uniform1f('bottom', (y + h/2)/sh)
      gradShader:uniform1f('left', (x - w/2)/sw)
      gradShader:uniform1f('right', (x + w/2)/sw)
      gradShader:uniform1f('vert', 0.5)

      gradShader:uniform1f('vert', 0.5)
      gradShader:uniform1f('a', 1)

      drawBorders(logo, 2)

      gradShader:uniform1f('a', 0)

      logo:Draw()

      gradShader:uniform1f('vert', 1)

      for i = 1, #choices do
        choiceSelected[i]:update(dt)

        local x, y = getChoicePos(i)
        local xRight = x + 150
        local cx, cy = (0 + xRight) / 2, y
        grad:xywh(0, cy, xRight * 2, 35)
        grad:diffuse(1, 1, 1, 1)

        gradShader:uniform1f('top', (y - 15) / sh)
        gradShader:uniform1f('bottom', (y + 15) / sh)
        gradShader:uniform1f('a', 1 - choiceSelected[i].eased)

        grad:Draw()

        grad:xywh(0, cy, xRight * 2 - 6, 35 - 6)

        gradShader:uniform1f('top', (y - 15) / sh)
        gradShader:uniform1f('bottom', (y + 15) / sh)
        gradShader:uniform1f('a', choiceSelected[i].eased)
        grad:diffuse((mix(hex('ffd8ff'), rgb(1, 1, 1), choiceSelected[i].eased)):unpack())

        grad:Draw()
        if save.data.settings.mascot_enabled then
          if save.data.settings.mascot == 'jolly' then
            --lol
            spawnT = spawnT - dt
            if spawnT < 0 then
              spawnParticle()
              spawnT = spawnT + 1/30
            end
            
            for i = #particles, 1, -1 do
              local p = particles[i]
              p.pos = p.pos + p.vel * dt
              p.vel = p.vel + vector(0, GRAVITY) * dt
              p.vel = p.vel * math.pow(FRICTION, dt)
              char:xy(p.pos:unpack())
              char:Draw()
              if p.pos.y > sh then
                table.remove(particles, i)
              end
            end
          end
          char:Draw()
        end
      end
    end)
  end),
  background = gimmick.common.background(function(ctx)
    --local mask = ctx:Quad()
    --mask:diffuse(1, 0.6, 0.5, 1)
    --mask:xywh(scx, scy, BLUR_WIDTH, sh)
    return function()
      --mask:skewx((BLUR_SKEW + math.sin(os.clock() / 2) * 10) / BLUR_WIDTH)
      --mask:Draw()
    end
  end),
  choices = gimmick.ChoiceProvider(choices, function(self, ctx, i, name)
    local grad = ctx:Shader('Shaders/grad.frag')
    local x, y = getChoicePos(i)
    grad:uniform2f('res', dw, dh)
    grad:uniform1f('top', (y - 15) / sh)
    grad:uniform1f('bottom', (y + 15) / sh)
    grad:uniform1f('vert', 1)
    grad:uniform4f('col1', hex('fe8257'):unpack())
    grad:uniform4f('col2', hex('cd63f4'):unpack())
    local text = ctx:BitmapText(FONTS.sans_serif, name)
    text:horizalign('center')
    text:xy(x, y)
    text:shadowlength(0)
    text:diffusealpha(0)
    text:zoom(0.5)
    text:sleep(0.1 * i)
    text:accelerate(0.4)
    text:diffusealpha(1)

    text:addcommand('Init', function()
      text:SetShader(actorgen.Proxy.getRaw(grad))
    end)

    text:addcommand('GainFocus', function()
      choiceSelected[i]:set(1)
    end)
    text:addcommand('LoseFocus', function()
      choiceSelected[i]:set(0)
    end)
    --text:addcommand('Off', function()
    --  text:sleep(.2) text:linear(.5) text:diffusealpha(0)
    --end)

    self:SetDrawFunction(function()
      grad:uniform1f('a', 1 - choiceSelected[i].eased)
      text:Draw()
    end)
  end)
}