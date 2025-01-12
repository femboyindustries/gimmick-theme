---@meta
---@diagnostic disable
--- @class StatsManager
--- @field public __index table Gives you the ``StatsManager`` table again
StatsManager = {}

--- Returns a :lua:class:`StageStats` instance including every game played
---
--- |since_itg|
---
--- @return StageStats
function StatsManager:GetAccumStageStats() end

--- Returns a :lua:class:`StageStats` instance containing the last ``rounds`` rounds played
---
--- |since_itg|
---
--- @param rounds integer The number of rounds to fetch
---
--- @return StageStats|nil
function StatsManager:GetPlayedStageStats(rounds) end

--- Returns the current stage stats
---
--- |since_itg|
---
--- @return StageStats
function StatsManager:GetCurStageStats() end

--- Returns the number of stages played
---
--- |since_itg|
---
--- @return integer
function StatsManager:GetStagesPlayed() end

--- Returns the final grade for the specified player
---
--- See :cpp:enum:`Grade`
---
--- |since_itg|
---
--- @param playerNumber integer The player number (0 indexed)
---
--- @return integer
function StatsManager:GetFinalGrade(playerNumber) end

--- Returns the worst grade
---
--- See :cpp:enum:`Grade`
---
--- |since_itg|
---
--- @return integer
function StatsManager:GetWorstGrade() end

--- Returns the best grade
---
--- See :cpp:enum:`Grade`
---
--- |since_itg|
---
--- @return integer
function StatsManager:GetBestGrade() end

--- Resets stored stats
---
--- |since_itg|
---
--- @return nil
function StatsManager:Reset() end

--- Tests for equality against another userdata object
---
--- |since_unk|
---
--- @param other userdata The object to test for equality against
---
--- @return boolean
function StatsManager:__eq(other) end

--- Returns a ``StatsManager (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function StatsManager:__tostring() end

return StatsManager
