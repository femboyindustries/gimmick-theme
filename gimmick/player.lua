local player = {}

---@param player Player
function player.init(player)

end

---@param self ActorFrame
function player.judgment(self)
  local sprite = self:GetChildAt(0) --[[@as Sprite]]
  if not sprite then return end
  sprite:Load(
    -- todo: make this configurable
    THEME:GetPath( EC_GRAPHICS, '' , '_Judgments/Bold' ) 
  )
end

function player.onJudgment(self, grade)
  -- todo: make these swappable
  -- simply love
  self:zoom(1.05) self:decelerate(.1) self:zoom(1) self:sleep(.6) self:accelerate(.2) self:zoom(0)
  -- itg
  --self:zoomx(1.3) self:zoomy(1.7) self:decelerate(0.1) self:zoom(1) self:sleep(1) self:accelerate(0.2) self:zoom(0)
end

function player.onHoldJudgment(self, grade)
  -- simply love
  self:diffuse(1,1,1,1) self:zoom(.5) self:sleep(.5) self:zoom(0)
  -- itg
  --self:diffuse(1,1,1,1) self:zoom(1.25) self:linear(0.3) self:zoomx(1) self:zoomy(1) self:sleep(0.5) self:diffuse(1,1,1,0)
end

return player