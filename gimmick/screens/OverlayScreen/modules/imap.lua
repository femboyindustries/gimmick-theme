local easable = require 'gimmick.lib.easable'
local save = require 'gimmick.save'

---@param ctx Context
return function(ctx)
  local imap = ctx:Sprite('Graphics/imap.png')

  imap:scaletofit(sw*0.5, sh * 0.83, sw*0.99, sh * 0.99)
  imap:valign(1)
  imap:halign(1)
  imap:xy(sw*0.99,sh*0.99)
  imap:diffusealpha(0)

  local function draw()
    imap:Draw()
  end

  local ease = easable(0, 6)
  local timer = 5
  local timer_active = false
  local cooldown = 0
  return {
    draw = function(dt)
      if not save.data.settings.show_imap then return end

      local seed = math.random(0, 50000)
      if seed == 3742 and SCREENMAN:GetTopScreen():GetName() ~= 'ScreenGameplay' and cooldown <= 0 then
        ease:set(1)
        timer_active = true
        cooldown = 20
      end
      if timer < 0 then
        ease:set(0)
        timer = 5
        timer_active = false
      end
      ease:update(dt)
      imap:diffusealpha(ease.eased)
      if timer_active then
        timer = timer - dt
      end
      cooldown = cooldown - dt
      draw()
    end
  }
end