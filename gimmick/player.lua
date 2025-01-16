require 'gimmick.lib.easings'

local player = {}

-- thank you Ky for most of these

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
  },
  {
    name = "Gimmick",
    tween = function(self)
      self:zoomy(0.5) self:zoomx(1.3) self:skewx(0.2) self:tween(0.1,outBack) self:zoomx(1) self:skewx(0) self:zoomy(1) self:sleep(0.6) self:tween(0.2,inBack) self:skewx(-0.5) self:zoomx(0) self:zoomy(0.1) self:sleep(0) self:skewx(0)
    end
  }
}

---@type { name: string, tween: fun(self: Actor) }[]
player.holdJudgmentTweens = {
  {
    name = "Simply Love",
    tween = function(self)
      self:diffuse(1,1,1,1) self:zoom(1) self:sleep(.5) self:zoom(0)
    end
  },
  {
    name = "ITG2",
    tween = function(self)
      self:diffuse(1,1,1,1) self:zoom(1.25) self:linear(0.3) self:zoomx(1) self:zoomy(1) self:sleep(0.5) self:diffuse(1,1,1,0)
    end
  },
  {
    name = "Gimmick",
    tween = function(self)
      self:zoomy(1.2) self:zoomx(1.5) self:tween(0.2,outBack) self:zoomx(1) self:zoomy(1) 
    end
  }
}

local COMBO_SCALE = 0.7
---@type { name: string, tween: fun(self: Actor, combo: number) }[]
player.comboTweens = {
  {
    name = "Static",
    tween = function(self)
      self:zoom(COMBO_SCALE)
    end
  },
  {
    name = "Simply Love",
    tween = function(self, combo)
      local newZoom = scale(combo,50,3000,0.8,1.8)
      self:zoom(COMBO_SCALE * newZoom) self:linear(0.05) self:zoom(COMBO_SCALE * newZoom)
    end
  },
  {
    name = "ITG2",
    tween = function(self, combo)
      local newZoom = scale(combo,0,500,0.9,1.4)
      self:zoom(1.2*newZoom) self:linear(0.05) self:zoom(newZoom)
    end
  },
  {
    name = "GrooveNights",
    tween = function(self, combo)
      local newZoom = scale(combo,0,500,0.9,1.4)
      self:zoom(1.05*newZoom) self:linear(0.05) self:zoom(newZoom)
    end
  },
  {
    -- ᐅᓪᓗᕆᐊᖅ
    name = "Ky_Dash",
    tween = function(self)
      local y = self:GetY() self:zoom(COMBO_SCALE) self:tween(0.05, outCirc) self:y(y - 12) self:tween(0.2, outBounce) self:y(y)
    end
  },
  {
    name = "Gimmick",
    tween = function(self)
      self:zoomy(0.5) self:zoomx(1.1) self:tween(0.1,outBack) self:zoomx(1) self:zoomy(1) 
    end
  }
}

-- capturing actors

---@param plr Player
---@return number
function player.getPlayerNumber(plr)
  local name = plr:GetName()
  n = tonumber(string.sub(name, string.len(name)))
  if n then return n end
  warn('Cannot find player number of ' .. tostring(plr) .. ' (' .. name .. ')')
  return 1
end

function player.getJudgementTween(pn)
  local plrData = save.getPlayerData(pn)
  local name = plrData.judgment_tween
  for _, tween in ipairs(player.judgmentTweens) do
    if tween.name == name then return tween end
  end
end

function player.getHoldJudgementTween(pn)
  local plrData = save.getPlayerData(pn)
  local name = plrData.hold_judgment_tween
  for _, tween in ipairs(player.holdJudgmentTweens) do
    if tween.name == name then return tween end
  end
end

function player.getComboTween(pn)
  local plrData = save.getPlayerData(pn)
  local name = plrData.combo_tween
  for _, tween in ipairs(player.comboTweens) do
    if tween.name == name then return tween end
  end
end

---@param self Player
---@param pn number?
function player.init(self, pn)
  if not pn then
    pn = player.getPlayerNumber(self)
  end

  print('! Found P' .. pn .. ' (' .. tostring(self) .. ')')
  print('  Judgment tween:      ' .. player.getJudgementTween(pn).name)
  print('  Hold judgment tween: ' .. player.getHoldJudgementTween(pn).name)
  print('  Combo tween:         ' .. player.getComboTween(pn).name)

  -- just for debugging purposes
  paw['P' .. pn] = self

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

function player.getJudgements()
  local judg = getFolderContents('Graphics/_Judgments/', true)
  local names = {}
  for _, filename in ipairs(judg) do
    table.insert(names, stripFilename(filename))
  end
  return names
end

function player.getHoldJudgements()
  local judg = getFolderContents('Graphics/_HoldJudgments/', true)
  local names = {}
  for _, filename in ipairs(judg) do
    table.insert(names, stripFilename(filename))
  end
  return names
end

---@param self ActorFrame
function player.judgmentReady(self)
  local sprite = self:GetChildAt(0) --[[@as Sprite]]
  if not sprite then return end

  local pn = player.getPlayerNumber(self:GetParent() --[[@as Player]])

  -- Loading the sprite must be done in here rather than player.judgment because
  -- else it gets overridden
  sprite:Load(
    THEME:GetPath(EC_GRAPHICS, '' , '_Judgments/' .. save.getPlayerData(pn).judgment_skin)
  )

  --sprite:diffusealpha(0.5)
end

---@param num BitmapText
function player.initCombo(num, skipAlign)
  num:shadowlength(0)
  if not skipAlign then
    num:align(0.5, 0)
  end
  num:diffusealpha(0.95)
end

---@param self ActorFrame
function player.combo(self)
  print('! Found combo (' .. tostring(self) .. ')')

  local num = self:GetChild('Number') --[[@as BitmapText]]
  player.initCombo(num)

  self:removecommand('On')
end

-- events

function player.onJudgment(self, grade, pn)
  if not pn then
      -- todo: store this info _somehow_ so it doesn't have to get called each time
    pn = player.getPlayerNumber(self:GetParent() --[[@as Player]])
  end
  local tween = player.getJudgementTween(pn)
  if not tween then return end
  self:finishtweening()
  tween.tween(self, grade)
end

function player.onHoldJudgment(self, grade, pn)
  if not pn then
      -- todo: store this info _somehow_ so it doesn't have to get called each time
    pn = player.getPlayerNumber(self:GetParent() --[[@as Player]])
  end
  local tween = player.getHoldJudgementTween(pn)
  if not tween then return end
  self:finishtweening()
  tween.tween(self)
end

---@param self BitmapText
function player.onCombo(self, pn, combo)
  if not pn then
      -- todo: store this info _somehow_ so it doesn't have to get called each time
    pn = player.getPlayerNumber(self:GetParent() --[[@as Player]])
  end
  local tween = player.getComboTween(pn)
  if not tween then return end
  self:finishtweening()
  tween.tween(self, combo)
end

return player