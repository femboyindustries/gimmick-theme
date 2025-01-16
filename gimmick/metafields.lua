local _M = {}

local sbox = require 'gimmick.lib.sbox'
local v = require 'gimmick.lib.validation'

local THEME_ID = 'femboy_industries.gimmick'
local THEME_VERSION = '0'

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

local segmentSources = {
  metafields_v0 = {
    name = 'Metafields specification (v0, draft)',
    url = 'https://docs.google.com/document/d/1bzg8LIPAHw6486dJ_6rEJ5KTjGTAprLcbruIsLmWm1k/edit',
  },
}

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
      -- TODO: move this outside of here. it's ugly in here
      segment_version = v.is_integer(),

      title = v.optional(v.is_string()),
      subtitle = v.optional(v.is_string()),
      artist = v.optional(v.is_string()),
      display_bpm = v.optional(v.is_string()),
      banner = v.optional(v.is_string()),
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
  }
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

---@param song Song
---@param path string
function _M.errorCallHandler(song, path)
  return function(message, level)
    local trace = debug.traceback(message, level)
    _M.emitWarning(song, path, trace)
  end
end

---@class Metafields
---@field song Song
---@field path string
local Metafields = {}
Metafields.__index = Metafields

function Metafields:loadTable(tab)
  for segmentName, segment in pairs(tab) do
    if schemas[segmentName] then
      local schema = schemas[segmentName]
      local valid, err = schema.table(segment)
      if err then
        _M.emitWarning(self.song, self.path, fullDump(err))
      end
    else
      _M.emitWarning(self.song, self.path, 'unsupported segment: ' .. segmentName .. ', ignoring')
    end
  end
end

---@param tab table
---@param song Song
---@param path string
---@return Metafields
function Metafields.from(tab, song, path)
  local self = {}
  self.song = song
  self.path = path
  setmetatable(self, Metafields)
  self:loadTable(tab)
  return self
end

---@param song Song
function _M.getSongMetafields(song)
  local songDir = song:GetSongDir()
  local files = { GAMESTATE:GetFileStructure(songDir) }
  if not includes(files, '.metafields.lua') then
    return
  end
  local path = songDir .. '.metafields.lua'
  local success, res = xpcall(function() return sbox.dofile(path) end, _M.errorCallHandler(song, path))
  if success then
    if type(res) ~= 'table' then
      _M.emitWarning(song, path, 'expected table, returned ' .. type(res))
      return
    end
    sbox.clear_metatable(res)
    return Metafields.from(res, song, path)
  else
    _M.emitWarning(song, path, res)
  end
end

return _M