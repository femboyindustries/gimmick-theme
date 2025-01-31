---@meta
---@diagnostic disable
--- @class GameSoundManager
--- @field public __index table Gives you the ``GameSoundManager`` table again
GameSoundManager = {}

--- Plays a sound immediately
---
--- Note that if the ``MuteActions`` preference is enabled, the sound won't be played
---
--- |since_itg|
---
--- @param path string The path to the audio file to play
---
--- @return nil
function GameSoundManager:PlayOnce(path) end

--- Sets the music volume for a specified duration
---
--- |since_itg|
---
--- @param volume number The target volume (between ``0`` and ``1``)
--- @param duration number How long to keep the music at the specified volume, in seconds
---
--- @return nil
function GameSoundManager:DimMusic(volume, duration) end

--- Tests for equality against another userdata object
---
--- |since_unk|
---
--- @param other userdata The object to test for equality against
---
--- @return boolean
function GameSoundManager:__eq(other) end

--- Returns an ``GameSoundManager (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function GameSoundManager:__tostring() end

return GameSoundManager
