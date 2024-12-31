---@meta
---@diagnostic disable
--- @class DifficultyMeter: ActorFrame
--- @field public __index table Gives you the ``DifficultyMeter`` table again
local DifficultyMeter = {}

--- Sets the difficulty meter's data from steps
---
--- |since_itg|
---
--- @param steps Steps The steps to use
---
--- @return nil
function DifficultyMeter:SetFromSteps(steps) end

--- Sets the difficulty meter's data from a trail
---
--- |since_itg|
---
--- @param trail Trail The trail to use
---
--- @return nil
function DifficultyMeter:SetFromTrail(trail) end

--- Sets the difficulty meter's data from a meter and difficulty value
---
--- |since_itg|
---
--- @param meter integer The rated numerical difficulty to use
--- @param difficulty integer The difficulty to use - See :cpp:enum:`Difficulty`
---
--- @return nil
function DifficultyMeter:SetFromMeterAndDifficulty(meter, difficulty) end

--- Loads specified graphics into the difficulty meter
---
--- |since_itg|
---
--- @param path string The path to load
---
--- @return nil
function DifficultyMeter:Load(path) end

--- Returns a ``DifficultyMeter (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function DifficultyMeter:__tostring() end

return DifficultyMeter
