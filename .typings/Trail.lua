---@meta
---@diagnostic disable
--- @class Trail
--- @field public __index table Gives you the ``Trail`` table again
Trail = {}

--- Returns the total length of the trail in seconds
---
--- |since_itg|
---
--- @return float
function Trail:GetLengthSeconds() end

--- Returns the difficulty
---
--- See :cpp:enum:`Difficulty`
---
--- |since_itg|
---
--- @return integer
function Trail:GetDifficulty() end

--- Returns the radar values for the trail
---
--- |since_itg|
---
--- @return RadarValues
function Trail:GetRadarValues() end

--- Returns the steps type for a trail
---
--- See :cpp:enum:`StepsType`
---
--- |since_notitg_v4_2_0|
---
--- @return integer
function Trail:GetStepsType() end

--- Tests for equality against another userdata object
---
--- |since_unk|
---
--- @param other userdata The object to test for equality against
---
--- @return boolean
function Trail:__eq(other) end

--- Returns a ``Trail (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function Trail:__tostring() end

return Trail
