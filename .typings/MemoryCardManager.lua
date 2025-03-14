---@meta
---@diagnostic disable
--- @class MemoryCardManager
--- @field public __index table Gives you the ``MemoryCardManager`` table again
MemoryCardManager = {}

--- Returns the state of the specified player's memory card
---
--- See :cpp:enum:`MemoryCardState`
---
--- |since_itg|
---
--- @param playerNumber integer The player number (0 indexed)
---
--- @return integer
function MemoryCardManager:GetCardState(playerNumber) end

--- Check equality with another userdata object
---
--- |since_unk|
---
--- @param other userdata The object to test for equality against
---
--- @return boolean
function MemoryCardManager:__eq(other) end

--- Returns a ``MemoryCardManager (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function MemoryCardManager:__tostring() end

return MemoryCardManager
