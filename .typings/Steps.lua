---@meta
---@diagnostic disable
--- @class Steps
--- @field public __index table Gives you the ``Steps`` table again
local Steps = {}

--- Returns the steps description
---
--- |since_itg|
---
--- @return string
function Steps:GetDescription() end

--- Returns the numeric difficulty rating for the steps
---
--- |since_itg|
---
--- @return integer
function Steps:GetMeter() end

--- Returns the steps' difficulty
---
--- See :cpp:enum:`Difficulty`
---
--- |since_itg|
---
--- @return integer
function Steps:GetDifficulty() end

--- Return the steps' radar values
---
--- |since_itg|
---
--- @return RadarValues
function Steps:GetRadarValues() end

--- Returns the steps type
---
--- See :cpp:enum:`StepsType`
---
--- |since_itg|
---
--- @return integer
function Steps:GetStepsType() end

--- Returns the note data from one of the song's steps
---
--- See :ref:`note_data_format`
---
--- |since_notitg_v4_9|
---
--- @return table[]
function Steps:GetNoteData() end

--- Tests for equality against another userdata object
---
--- |since_unk|
---
--- @param other userdata The object to test for equality against
---
--- @return boolean
function Steps:__eq(other) end

--- Returns a ``Steps (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function Steps:__tostring() end

return Steps
