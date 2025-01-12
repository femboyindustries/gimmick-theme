---@meta
---@diagnostic disable
--- @class UnlockManager
--- @field public __index table Gives you the ``UnlockManager`` table again
UnlockManager = {}

--- Unlocks an entry with a code
---
--- |since_itg|
---
--- @param unlockCode integer The unlock code
---
--- @return nil
function UnlockManager:UnlockCode(unlockCode) end

--- Sets the preferred song/course to the specified code
---
--- |since_itg|
---
--- @param unlockCode integer The unlock code
---
--- @return nil
function UnlockManager:PreferUnlockCode(unlockCode) end

--- Returns a table of steps unlocked by ``unlockCode``
---
--- Returns an empty table on an invalid code
---
--- |since_itg|
---
--- @param unlockCode integer The unlock code
---
--- @return table
function UnlockManager:GetSongsUnlockedByCode(unlockCode) end

--- Returns a table of songs unlocked by ``unlockCode``
---
--- Returns an empty table on an invalid code
---
--- |since_itg|
---
--- @param unlockCode integer The unlock code
---
--- @return table
function UnlockManager:GetStepsUnlockedByCode(unlockCode) end

--- Finds the code associated with ``name``
---
--- |since_itg|
---
--- @param name string The name
---
--- @return integer|nil
function UnlockManager:FindCode(name) end

--- Returns if a song is locked and inaccessible
---
--- |since_notitg_v4_9|
---
--- @param song Song
---
--- @return nil
function UnlockManager:SongIsLocked(song) end

--- Returns if a chart of a song is locked and inaccessible
---
--- |since_notitg_v4_9|
---
--- @param song Song
--- @param steps Steps
---
--- @return nil
function UnlockManager:StepsIsLocked(song, steps) end

--- Tests for equality against another userdata object
---
--- |since_unk|
---
--- @param other userdata The object to test for equality against
---
--- @return boolean
function UnlockManager:__eq(other) end

--- Returns a ``UnlockManager (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function UnlockManager:__tostring() end

return UnlockManager
