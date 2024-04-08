-- indexing things on _G is slower than
-- having access to them in a local `oat` table
-- that already acts as _G, so we move commonly
-- use values over

local function copy(src)
  local dest = {}
  for k, v in pairs(src) do
    dest[k] = v
  end
  return dest
end

gimmick = _G.gimmick
type = _G.type
pairs = _G.pairs
ipairs = _G.ipairs
unpack = _G.unpack
tonumber = _G.tonumber
tostring = _G.tostring
math = copy(_G.math)
table = copy(_G.table)
string = copy(_G.string)

-- convinience shortcuts employed by most templates

scx = SCREEN_CENTER_X
scy = SCREEN_CENTER_Y
sw = SCREEN_WIDTH
sh = SCREEN_HEIGHT

if not LITE then
  dw = DISPLAY:GetDisplayWidth()
  dh = DISPLAY:GetDisplayHeight()
end

-- https://github.com/openitg/openitg/blob/master/src/Actor.h#L17

DRAW_ORDER_BEFORE_EVERYTHING = -200
DRAW_ORDER_UNDERLAY				   = -100
-- normal screen elements go here
DRAW_ORDER_OVERLAY          = 100
DRAW_ORDER_TRANSITIONS      = 110
DRAW_ORDER_AFTER_EVERYTHING = 200

FONTS = {
  sans_serif = '_renogare 42px',
  monospace = '_renogare 42px',
}