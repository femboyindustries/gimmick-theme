-- must be an ODD number such that we can determine the middle easily
local WHEEL_ITEMS = 11

local wheelActors = {}

local function addActor(actor)
  table.insert(wheelActors, actor)
end

return {
  Init = function(self)
    wheelActors = {}
  end,
  MusicWheel = {
    NumWheelItems = function()
      return WHEEL_ITEMS
    end,

    RouletteOn = function(self) addActor(self) end,
    SectionOn = function(self) addActor(self) end,
    SongNameOn = function(self) addActor(self) end,
    CourseNameOn = function(self) addActor(self) end,
    SortOn = function(self) addActor(self) end,
  },
  overlay = gimmick.ActorScreen(function(self, ctx)
    local text = ctx:BitmapText('_renogare 42px')

    local p = 0

    self:SetDrawFunction(function()
      for i, actor in ipairs(wheelActors) do
        text:xy(scx, i * 24)
        text:zoom(0.6)
        text:settext(actor('Title'):GetText() .. ' ' .. tostring(actor:GetY()))
        text:Draw()
      end
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}