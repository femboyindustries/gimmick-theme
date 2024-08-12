require 'gimmick.lib.easings'

local player = {}

---@type { name: string, tween: fun(self: Actor, n: number) }[]
player.judgmentTweens = {
  {
    name = "Simply Love",
    tween = function(self)
      self:zoom(1.05) self:decelerate(0.1) self:zoom(1) self:sleep(0.6) self:accelerate(0.2) self:zoom(0)
    end
  },
  {
    name = "ITG2",
    tween = function(self, n)
      self:zoomx(1.3) self:zoomy(1.7) self:decelerate(0.1) self:zoom(1) self:sleep(1) self:accelerate(0.2) self:zoom(0)
      if n == 1 then self:glowshift() self:effectperiod(0.05) self:effectcolor1(1,1,1,0) self:effectcolor2(1,1,1,0.5) end
    end
  },
  {
    name = "GrooveNights",
    tween = function(self)
      self:zoom(1.15) self:decelerate(0.1) self:zoom(1) self:sleep(1) self:accelerate(0.2) self:zoom(0)
    end
  },
  {
    name = "ITG Retro",
    tween = function(self)
      self:zoomx(1.1) self:zoomy(1.4) self:decelerate(0.1) self:zoom(1) self:sleep(1) self:accelerate(0.2) self:zoom(0)
    end
  },
  {
    -- ᐅᓪᓗᕆᐊᖅ
    name = "Ky_Dash",
    tween = function(self)
      self:zoomx(0.7) self:zoomy(0.9) self:tween(.7, outElastic) self:zoom(1) self:tween(.2, with1param(inBack, 2.5)) self:zoom(0)
    end
  },
  {
    name = "SLG Jose's Modification",
    tween = function(self)
      self:zoom(1.15) self:bounceend(0.2) self:zoom(1) self:sleep(0.6) self:accelerate(0.2) self:zoom(0)
    end
  }
}

---@type { name: string, tween: fun(self: Actor) }[]
player.holdJudgmentTweens = {
  {
    name = "Simply Love",
    tween = function(self)
      self:diffuse(1,1,1,1) self:zoom(.5) self:sleep(.5) self:zoom(0)
    end
  },
  {
    name = "ITG2",
    tween = function(self)
      self:diffuse(1,1,1,1) self:zoom(1.25) self:linear(0.3) self:zoomx(1) self:zoomy(1) self:sleep(0.5) self:diffuse(1,1,1,0)
    end
  }
}

local COMBO_SCALE = 0.7
---@type { name: string, tween: fun(self: Actor) }[]
player.comboTweens = {
  {
    name = "Static",
    tween = function(self)
      self:zoom(COMBO_SCALE)
    end
  },
  {
    name = "Simply Love",
    tween = function(self)
      local combo = self:GetZoom()
      local newZoom = scale(combo,50,3000,0.8,1.8)
      self:zoom(COMBO_SCALE * newZoom) self:linear(0.05) self:zoom(COMBO_SCALE * newZoom)
    end
  },
  {
    -- ᐅᓪᓗᕆᐊᖅ
    name = "Ky_Dash",
    tween = function(self)
      local y = self:GetY() self:zoom(COMBO_SCALE) self:tween(0.05, outCirc) self:y(y - 12) self:tween(0.2, outBounce) self:y(y)
    end
  }
}

-- capturing actors

---@param self Player
---@param n number?
function player.init(self, n)
  if not n then
    local name = self:GetName()
    n = tonumber(string.sub(name, string.len(name)))
    if not n then
      warn('Cannot find player number of ' .. tostring(self) .. ' (' .. name .. ')')
      return
    end
  end

  print('! Found P' .. n .. ' (' .. tostring(self) .. ')')
  print('  Judgment tween:      ' .. player.judgmentTweens[save.data.settings.judgment_tween].name)
  print('  Hold judgment tween: ' .. player.holdJudgmentTweens[save.data.settings.hold_judgment_tween].name)
  print('  Combo tween:         ' .. player.comboTweens[save.data.settings.combo_tween].name)

  -- just for debugging purposes
  paw['P' .. n] = self

  -- OffCommand defined here does not work; look at player.judgment if needed
end

---@param self ActorFrame
function player.judgment(self)
  print('! Found judgment (' .. tostring(self) .. ')')
  player.init(self:GetParent() --[[@as Player]])

  self:removecommand('On')
  -- OnCommand is called again after this on SetAwake, so once for P1 and P2 by
  -- default, unless you're in the editor
  self:addcommand('On', player.judgmentReady)
  -- OffCommand is only called on song finish, not on backing out, so the screen
  -- must handle deinit if needed
end

---@param self ActorFrame
function player.judgmentReady(self)
  local sprite = self:GetChildAt(0) --[[@as Sprite]]
  if not sprite then return end

  -- Loading the sprite must be done in here rather than player.judgment because
  -- else it gets overridden
  sprite:Load(
    -- todo: make this configurable
    THEME:GetPath(EC_GRAPHICS, '' , '_Judgments/Bold')
  )

  --sprite:diffusealpha(0.5)
end

---@param self ActorFrame
function player.combo(self)
  print('! Found combo (' .. tostring(self) .. ')')

  local num = self:GetChild('Number') --[[@as BitmapText]]

  num:shadowlength(0)
  num:align(0.5, 0)
  num:diffusealpha(0.95)

  self:removecommand('On')
end

-- events

function player.onJudgment(self, grade)
  local tween = player.judgmentTweens[save.data.settings.judgment_tween]
  if not tween then return end
  tween.tween(self, grade)
end

function player.onHoldJudgment(self, grade)
  local tween = player.holdJudgmentTweens[save.data.settings.hold_judgment_tween]
  if not tween then return end
  tween.tween(self)
end

function player.onCombo(self)
  local tween = player.comboTweens[save.data.settings.combo_tween]
  if not tween then return end
  tween.tween(self)
end

return player