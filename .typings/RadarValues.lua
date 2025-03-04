---@meta
---@diagnostic disable
--- @class RadarValues
--- @field public __index table Gives you the ``RadarValues`` table again
RadarValues = {}

--- Returns the value of ``category``
---
--- |since_itg|
---
--- @param category integer The radar category to get a value for - see :cpp:enum:`RadarCategory`
function RadarValues:GetValue(category) end

--- Tests for equality against another userdata object
---
--- |since_unk|
---
--- @param other userdata The object to test for equality against
---
--- @return boolean
function RadarValues:__eq(other) end

--- Returns a ``RadarValues (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function RadarValues:__tostring() end

return RadarValues
