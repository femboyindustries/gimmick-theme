local actor235 = require "gimmick.lib.actor235"
-- must be an ODD number such that we can determine the middle easily
local WHEEL_ITEMS = 11

return {
  Init = function(self)
    wheelActors = {}
  end,
  MusicWheel = {
    -- mostly all just testing

    NumWheelItems = function()
      return WHEEL_ITEMS
    end,

    --RouletteOn = function(self) addActor(self) end,
    --SectionOn = function(self) addActor(self) end,
    --SongNameOn = function(self) addActor(self) end,
    --CourseNameOn = function(self) addActor(self) end,
    --SortOn = function(self) addActor(self) end,
  },
  overlay = gimmick.ActorScreen(function(self, ctx)
    local text = ctx:BitmapText(FONTS.sans_serif)
    local rating = ctx:BitmapText(FONTS.sans_serif)
    rating:shadowlength(0)
    text:shadowlength(0)
    text:zoom(0.35)
    local quad = ctx:Quad()

    local difficulties = {
      {
        name = 'Easy',
        color = hex('C1006F'),
        rating = 4,
      },
      --{
      --  name = 'Normal',
      --  color = hex('8200A1'),
      --},
      --{
      --  name = 'Hard',
      --  color = hex('413AD0'),
      --},
      {
        name = 'Harder',
        color = hex('0073FF'),
        rating = 15,
      },
      {
        name = 'Insane',
        color = hex('00ADC0'),
        rating = 18,
      },
      {
        name = 'Demon',
        color = hex('B4B7BA'),
        rating = 22,
      }
    }

    local FOLD_BORDER = 4
    local FOLD_GAP = 6
    local TOTAL_FOLD_WIDTH = 200

    quad:align(0, 0.5)
    text:align(0, 0.5)

    local selected = 3

    local pie = ctx:Shader('Shaders/pie.frag')
    local pieActor = ctx:Sprite('Graphics/white.png')

    pieActor:addcommand('Init', function(a)
      a:SetShader(actor235.Proxy.getRaw(pie))
    end)

    self:SetDrawFunction(function()
      local x = 96
      quad:SetHeight(20)
      quad:skewx(-0.2)
      for i, diff in ipairs(difficulties) do
        quad:diffuse(diff.color:unpack())
        if i ~= selected then
          quad:SetWidth(FOLD_BORDER * 2)
          quad:xy(x, scy)
          quad:Draw()
          x = x + FOLD_BORDER * 2
        else
          local width = TOTAL_FOLD_WIDTH - ((FOLD_BORDER * 2 + FOLD_GAP) * (#difficulties - 1) - FOLD_GAP)
          quad:SetWidth(FOLD_BORDER * 2 + width)
          quad:xy(x, scy)
          quad:Draw()
          text:settext(diff.name)
          text:diffuse(0, 0, 0, 1)
          text:xy(x + FOLD_BORDER, scy)
          text:Draw()
          x = x + width + FOLD_BORDER * 2
        end

        x = x + FOLD_GAP
      end

      local fill = difficulties[selected].rating / 20
      pie:uniform1f('width', 0.25)
      pie:uniform1f('fill', fill)
      pieActor:xywh(48, scy, 64, 64)
      pieActor:diffuse(difficulties[selected].color:unpack())
      pieActor:Draw()

      rating:settext(tostring(difficulties[selected].rating))
      rating:xy(48, scy)
      rating:diffuse(1, 1, 1, 1)
      rating:zoom(0.5)
      rating:Draw()
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}