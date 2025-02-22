local _M = {}

local sbox = require 'gimmick.lib.sbox'
local v = require 'gimmick.lib.validation'
local FlexVer = require 'gimmick.lib.flexver'

local THEME_ID = 'femboy_industries.gimmick'
local THEME_VERSION = '0'

local METAFIELDS_VERSION = 0

---@enum Comparison
local Comparison = {
  STRICT = '',

  EQ = '=',
  NEQ = '~=',
  GTE = '>=',
  GT = '>',
  LTE = '<=',
  LT = '<',
}

---@class ThemeIdentifier
---@field theme string
---@field version string?
---@field comp Comparison?
local ThemeIdentifier = {}
ThemeIdentifier.__index = ThemeIdentifier

function ThemeIdentifier:test(theme, version)
  if not string.find(theme, '^' .. replace(escapeLuaPattern(self.theme), '%*', '.+') .. '$') then
    return false
  end

  if not self.version then
    return true
  end

  if self.comp == Comparison.STRICT then
    return string.find(version, '^' .. replace(escapeLuaPattern(self.version), '%*', '.+') .. '$') ~= nil
  end

  local cmp = FlexVer.new(version):compare(FlexVer.new(self.version))

  return
    (self.comp == Comparison.EQ and cmp == 0) or
    (self.comp == Comparison.NEQ and cmp ~= 0) or
    (self.comp == Comparison.GTE and cmp >= 0) or
    (self.comp == Comparison.GT and cmp > 0) or
    (self.comp == Comparison.LTE and cmp <= 0) or
    (self.comp == Comparison.LT and cmp < 0)
end

function ThemeIdentifier.new(str)
  local self = setmetatable({}, ThemeIdentifier)

  self.theme = str

  local at = string.find(str, '@')

  if at then
    self.theme = string.sub(str, 1, at - 1)
    self.version = string.sub(str, at + 1)
  end

  if string.len(self.theme) == 0 then
    error('not well-formed theme indicator - empty', 2)
  end

  if not string.find(self.theme, '^%w') then
    error('not well-formed theme indicator - comparasion signs cannot be used in theme indicators', 2)
  end

  if string.find(self.theme, '%*%*') then
    error('not well-formed theme indicator - duplicated wildcards', 2)
  end

  if self.version then
    if string.find(self.version, '@') then
      error('not well-formed theme identifier - multiple @ signs', 2)
    end

    if string.len(self.version) == 0 then
      error('not well-formed version indicator - empty', 2)
    end
  
    if string.find(self.version, '^[%w*]') then
      self.comp = Comparison.STRICT
    else
      -- trying to avoid matching >= as GT instead of GTE by trying to find
      -- the longest sign that matches. there's probably a smarter way to do
      -- this
      local maxLen = 0
      local maxSign

      for _, sign in pairs(Comparison) do
        if
          string.len(sign) > maxLen and
          string.find(self.version, '^' .. escapeLuaPattern(sign))
        then
          maxSign = sign
        end
      end

      if not maxSign then
        error('not well-formed version indicator - invalid comparison sign', 2)
      end

      self.comp = maxSign
      self.version = string.sub(self.version, string.len(maxSign) + 1)
    end

    if self.comp ~= Comparison.STRICT and string.find(self.version, '%*') then
      error('not well-formed version indicator - wildcards can only be used with strict equivalence', 2)
    elseif self.comp == Comparison.STRICT and string.find(self.version, '%*%*') then
      error('not well-formed version indicator - duplicated wildcards', 2)
    end
  end

  return self
end

local is_difficulty = v.in_list({
  DIFFICULTY_BEGINNER, DIFFICULTY_EASY, DIFFICULTY_MEDIUM, DIFFICULTY_HARD,
  DIFFICULTY_CHALLENGE, DIFFICULTY_EDIT
})
local is_radar_value = v.in_list({
  RADAR_CATEGORY_STREAM, RADAR_CATEGORY_VOLTAGE, RADAR_CATEGORY_AIR,
  RADAR_CATEGORY_FREEZE, RADAR_CATEGORY_CHAOS, RADAR_CATEGORY_TAPS,
  RADAR_CATEGORY_JUMPS, RADAR_CATEGORY_HOLDS, RADAR_CATEGORY_MINES,
  RADAR_CATEGORY_HANDS, RADAR_CATEGORY_ROLLS
})
local is_aspect_ratio = function(value)
  if type(value) ~= 'string' then
    return false, v.error_message(value, 'a string')
  end
  if not string.find(value, '^%d+:%d+$') then
    return false, v.error_message(value, 'a formatted aspect ratio (%d+:%d+)')
  end
  return true
end
local is_theme = function(value)
  if type(value) ~= 'string' then
    return false, v.error_message(value, 'a string')
  end
  local status, res = pcall(ThemeIdentifier.new, value)
  if not status then
    return false, v.error_message(value, 'a theme identifier (' .. res .. ')')
  end
  return true
end
local meta_schema = v.is_table({
  version = v.is_integer(),
  disallow_implementations = v.optional(v.is_array(is_theme)),
})

local segmentSources = {
  metafields_v0 = {
    name = 'Metafields specification (v0, draft)',
    url = 'https://docs.google.com/document/d/1bzg8LIPAHw6486dJ_6rEJ5KTjGTAprLcbruIsLmWm1k/edit',
  },
  gimmick_interal = {
    name = 'gimmick_interal',
    url = 'gimmick.com'
  }
}
_M.segmentSources = segmentSources

local schemas = {
  meta = {
    version = 0,
    source = 'metafields_v0',
    table = v.is_table({
      metafields_version = v.is_integer(),
    }),
  },
  ['base.chart_metadata'] = {
    version = 0,
    source = 'metafields_v0',
    table = v.is_table({
      meta = meta_schema,

      title = v.optional(v.is_string()),
      subtitle = v.optional(v.is_string()),
      artist = v.optional(v.is_string()),
      display_bpm = v.optional(v.is_string()),
      banner = v.optional(v.is_string()), -- TODO implement
      song_length = v.optional(v.is_string()),
      notes = v.optional(v.is_map(v.is_table({
        [1] = is_difficulty,
        [2] = v.optional(v.is_string())
      }), v.is_table({
        name = v.optional(v.is_string()),
        meter = v.optional(v.is_string()),
        radar_values = v.optional(v.is_map(is_radar_value, v.is_number())),
        stats = v.optional(v.is_table({
          taps = v.optional(v.is_string()),
          mines = v.optional(v.is_string()),
          holds = v.optional(v.is_string()),
          rolls = v.optional(v.is_string()),
          jumps = v.optional(v.is_string()),
          hands = v.optional(v.is_string()),
        }))
      })))
    }),
  },
  ['base.engine_compatibility'] = { -- TODO implement
    version = 0,
    source = 'metafields_v0',
    table = v.is_table({
      meta = meta_schema,
      min_version = v.is_number(),
    })
  },
  ['base.resolution'] = { -- TODO implement
    version = 0,
    source = 'metafields_v0',
    table = v.is_table({
      meta = meta_schema,
      recommended_ratios = v.optional(v.is_array(is_aspect_ratio)),
      forbid_ratios = v.optional(v.is_array(is_aspect_ratio)),
      required_ratios = v.optional(v.is_array(is_aspect_ratio)),
      min_width = v.optional(v.is_integer()),
      max_width = v.optional(v.is_integer()),
      min_height = v.optional(v.is_integer()),
      max_height = v.optional(v.is_integer()),
    })
  },
  ['base.warnings'] = {
    version = 0,
    source = 'metafields_v0',
    table = v.is_table({
      meta = meta_schema,
      epilepsy_warning = v.optional(v.is_boolean()),
      loud_warning = v.optional(v.is_boolean()),
      window_movements = v.optional(v.is_boolean()),
      copyright_warning = v.optional(v.is_boolean()),
      is_minigame = v.optional(v.is_boolean()),
      warning_label = v.optional(v.is_string()), -- TODO implement
      warning_label_severity = v.optional(v.in_list({'note', 'acknowledge', 'urgent'})), -- TODO implement
    })
  },

  ['mayf.volatile'] = {
    version = 0,
    source = 'gimmick_interal',
    table = v.is_table({
      is_volatile = v.optional(v.is_string())
    })
  }
}
_M.schemas = schemas

local warningIcons = {
  epilepsy_warning = 'Graphics/icon-loud.png', -- todo
  is_minigame = 'Graphics/icon-loud.png', -- todo
  loud_warning = 'Graphics/icon-loud.png',
  window_movements = 'Graphics/icon-window-movements.png',
  copyright_warning = 'Graphics/icon-copyright.png',
}

---@param song Song
---@param path string
---@param message string
function _M.emitWarning(song, path, message)
  -- TODO, show this someplace better
  gimmick.warn('Error while evaluating Metafields file for ' .. song:GetDisplayFullTitle())
  gimmick.warn('Filepath: ' .. path)
  gimmick.warn(message)
end

---@alias MetafieldsError { msg: string, line: number? }

---@class Metafields
---@field song Song
---@field path string
---@field segments table[]
---@field warnings MetafieldsError[]
local Metafields = {}
Metafields.__index = Metafields

local function unloadErrored(tab, err)
  if type(err) ~= type(tab) then return end
  for k in pairs(err) do
    if type(err[k]) == 'table' then
      unloadErrored(tab[k], err[k])
    else
      tab[k] = nil
    end
  end
end

function Metafields:warn(msg)
  table.insert(self.warnings, { msg = msg })
  _M.emitWarning(self.song, self.path, msg)
end
function Metafields:warnDetailed(msg, line)
  table.insert(self.warnings, { msg = msg, line = line })
  _M.emitWarning(self.song, self.path, msg)
end

function Metafields:loadTable(tab)
  for segmentName, segment in pairs(tab) do
    segment = deepcopy(segment)
    if schemas[segmentName] then
      local schema = schemas[segmentName]
      local valid, err = schema.table(segment)
      if err then
        local errStr = trim(v.print_err(err, '["' .. segmentName .. '"].'))
        for s in string.gfind(errStr, '[^\r\n]+') do
          self:warn(s)
        end
        unloadErrored(segment, err)
      end
      if segment.meta and segment.meta.version ~= schema.version then
        self:warn('segment version: ' .. segment.meta.version .. ', implemented version: ' .. schema.version)
      end
      local canLoad = true
      if segment.meta and segment.meta.disallow_implementations then
        for _, impl in pairs(segment.meta.disallow_implementations) do
          local status, identifier = pcall(ThemeIdentifier.new, impl)
          if status then
            local res = identifier:test(THEME_ID, THEME_VERSION)
            print(impl, ':', res)
            if res then
              canLoad = false
              --break
            end
          end
        end
      end
      if canLoad then
        self.segments[segmentName] = segment
      end
    else
      self:warn('unsupported segment: ' .. segmentName .. ', ignoring')
    end
  end
  if not self.segments['meta'] then
    self:warn('missing meta segment, refusing to evaluate')
    self.segments = {}
  else
    local meta = self:get('meta')
    if meta.metafields_version and meta.metafields_version ~= METAFIELDS_VERSION then
      self:warn('metafields file specifies version ' .. meta.metafields_version .. ', but we only support ' .. METAFIELDS_VERSION)
    end
  end
end

---@param segment string
function Metafields:get(segment)
  return self.segments[segment]
end

---@param steps Steps
function Metafields:getDiffOverride(steps)
  local overrideFields = self:get('base.chart_metadata')
  if overrideFields and overrideFields.notes then
    for key, value in pairs(overrideFields.notes) do
      local diffVal = key[1]
      local desc = key[2]
      if steps:GetDifficulty() == diffVal and (not desc or steps:GetDescription() == desc) then
        return value
      end
    end
  end
end

-- initialize `icons` beforehand with `metafields.createWarningIcons`
function Metafields:getIcons(icons)
  local w = self:get('base.warnings')
  local songIcons = {}
  if w then
    if w.epilepsy_warning then
      table.insert(songIcons, icons.epilepsy_warning)
    end
    if w.loud_warning then
      table.insert(songIcons, icons.loud_warning)
    end
    if w.window_movements then
      table.insert(songIcons, icons.window_movements)
    end
    if w.copyright_warning then
      table.insert(songIcons, icons.copyright_warning)
    end
    if w.is_minigame then
      table.insert(songIcons, icons.is_minigame)
    end
  end
  return songIcons
end

---@param tab table?
---@param song Song
---@param path string
---@return Metafields
function Metafields.from(tab, song, path)
  local self = {}
  self.song = song
  self.path = path
  self.segments = {}
  self.warnings = {}
  setmetatable(self, Metafields)
  if tab then
    self:loadTable(tab)
  end
  return self
end

---@param song Song
---@param path string
function Metafields.empty(song, path)
  return Metafields.from(nil, song, path)
end

---@param song Song
---@param path string
---@param err string
function Metafields.fromErr(song, path, err)
  local metafields = Metafields.empty(song, path)
  metafields:warn(err)
  return metafields
end

---@param song Song
---@param path string
---@param err string
---@param line number
function Metafields.fromErrDetailed(song, path, err, line)
  local metafields = Metafields.empty(song, path)
  metafields:warnDetailed(err, line)
  return metafields
end

---@type table<Song, { metafields: Metafields? }>
local songCache = {}

---@param song Song
---@return Metafields? @ Metafields will ALWAYS be returned if .metafields.lua is present
local function _getSongMetafields(song)
  local songDir = song:GetSongDir()

  local files = { GAMESTATE:GetFileStructure(songDir) }
  if not includes(files, '.metafields.lua') then
    return nil
  end
  local path = songDir .. '.metafields.lua'

  local success, res = xpcall(function() return sbox.dofile(path) end, function(message, level)
    local info = level and debug.getinfo(level, 'S')
    --return { msg = message, line = info.currentline }
    return { msg = message }
  end)

  if not success then
    _M.emitWarning(song, path, res.msg)
    return Metafields.fromErrDetailed(song, path, res.msg, res.line)
  end

  if type(res) ~= 'table' then
    return Metafields.fromErr(song, path, 'expected table, returned ' .. type(res))
  end
  sbox.clear_metatable(res)
  return Metafields.from(res, song, path)
end

---@param song Song
---@return Metafields? @ Metafields will ALWAYS be returned if .metafields.lua is present
function _M.getSongMetafields(song)
  if songCache[song] then
    return songCache[song].metafields
  end
  local meta = _getSongMetafields(song)
  songCache[song] = {
    metafields = meta
  }
  return meta
end

---@param ctx Context
function _M.createWarningIcons(ctx)
  local icons = {}
  for key, filename in pairs(warningIcons) do
    icons[key] = ctx:Sprite(filename)
  end
  return icons
end

return _M