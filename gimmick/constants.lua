require 'gimmick.lib.color'

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

-- todo: move color/font-based stuff elsewhere?
DIFFICULTIES = {
  [DIFFICULTY_BEGINNER] = {
    name = 'Easy',
    color = hex('#3FFFE4'),
    text = rgb(0, 0, 0),
  },
  [DIFFICULTY_EASY] = {
    name = 'Normal',
    color = hex('#54FFAB'),
    text = rgb(0, 0, 0),
  },
  [DIFFICULTY_MEDIUM] = {
    name = 'Hard',
    color = hex('#FFEC75'),
    text = rgb(0, 0, 0),
  },
  [DIFFICULTY_HARD] = {
    name = 'Harder',
    color = hex('#FF6651'),
    text = rgb(0, 0, 0),
  },
  [DIFFICULTY_CHALLENGE] = {
    name = 'Insane',
    color = hex('#6A54FF'),
    text = rgb(0, 0, 0),
  },
  [DIFFICULTY_EDIT] = {
    name = 'Demon',
    color = hex('B4B7BA'),
    text = rgb(0, 0, 0),
  }
}
