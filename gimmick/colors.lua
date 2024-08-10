require 'gimmick.lib.color'


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

--[[
TNS_NONE = 0
TNS_HITMINE = 1
TNS_AVOIDMINE = 2
TNS_MISS = 3
TNS_BOO = 4
TNS_GOOD = 5
TNS_GREAT = 6
TNS_PERFECT = 7
]]
JUDGEMENTS = {
  [TNS_MARVELOUS] = hex('27D0FE'),
  [TNS_PERFECT] = hex('F6E213'),
  [TNS_GREAT] = hex('46E308'),
  [TNS_GOOD] = hex('9C0AEB'),
  [TNS_BOO] = hex('FA7A04'),
  [TNS_MISS] = hex('FA7A04')
}
