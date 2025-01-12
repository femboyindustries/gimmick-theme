require 'gimmick.colors'

-- convinience shortcuts employed by most templates

scx = SCREEN_CENTER_X
scy = SCREEN_CENTER_Y
sw = SCREEN_WIDTH
sh = SCREEN_HEIGHT

if not LITE then
  dw = DISPLAY:GetDisplayWidth()
  dh = DISPLAY:GetDisplayHeight()
else
  dw = sw
  dh = sh
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
  monospace = '_recursive 42px',
}

if LITE then
  USING_WINE = false ---😢
else
  USING_WINE = includes(INPUTMAN:GetDescriptions(), 'Wine Keyboard')
end

if USING_WINE then
  Trace('mason Alert') --hi mason
end

IS_JAILBROKEN = pcall(os.execute, '')

if IS_JAILBROKEN then
  Trace('Based alert')
end

MASCOT_FOLDER = 'Mascots/'
MASCOT_SUBFOLDERS = {backgrounds = 'backgrounds/', characters = 'characters/'}

FANTASTIC = TNS_MARVELOUS
EXCELLENT = TNS_PERFECT
GREAT = TNS_GREAT
DECENT = TNS_GOOD
WAYOFF = TNS_BOO
MISS = TNS_MISS

JUDGMENTS = {
  {
    code = 'Marvelous',
    score = TNS_MARVELOUS, -- TNS_MARVELOUS
    name = 'Fantastic',
    color = hex('27D0FE'),
  },
  {
    code = 'Perfect',
    score = TNS_PERFECT, -- TNS_PERFECT
    name = 'Excellent',
    color = hex('F6E213'),
  },
  {
    code = 'Great',
    score = TNS_GREAT, -- TNS_GREAT
    name = 'Great',
    color = hex('46E308'),
  },
  {
    code = 'Good',
    score = TNS_GOOD, -- TNS_GOOD
    name = 'Decent',
    color = hex('9C0AEB'),
  },
  {
    code = 'Boo',
    score = TNS_BOO, -- TNS_BOO
    name = 'Way Off',
    color = hex('FA7A04'),
  },
  {
    code = 'Miss',
    score = TNS_MISS, -- TNS_MISS
    name = 'Miss',
    color = hex('B50F00')
  },
}