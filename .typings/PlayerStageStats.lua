---@meta
---@diagnostic disable
--- @class PlayerStageStats
--- @field public __index table Gives you the ``PlayerStageStats`` table again
PlayerStageStats = {}

--- Returns whether the player obtained a full combo
---
--- Returns an int: ``0`` or ``1``
---
--- |since_itg|
---
--- @return integer
function PlayerStageStats:FullCombo() end

--- Returns the highest combo the player achieved
---
--- |since_itg|
---
--- @return integer
function PlayerStageStats:MaxCombo() end

--- Sets the player's current combo
---
--- |since_notitg_v3|
---
--- @param combo integer The new combo to set
---
--- @return nil
function PlayerStageStats:SetCurrentCombo(combo) end

--- Returns the player's current combo
---
--- |since_itg|
---
--- @return integer
function PlayerStageStats:GetCurrentCombo() end

--- Sets the player's score
---
--- |since_notitg_v1|
---
--- @param score integer The new score to set
---
--- @return nil
function PlayerStageStats:SetScore(score) end

--- Returns the player's score
---
--- |since_itg|
---
--- @return integer
function PlayerStageStats:GetScore() end

--- Sets the player's dance points to ``amount``
---
--- |since_notitg_v1|
---
--- @param amount integer The new dance points value to set
---
--- @return nil
function PlayerStageStats:SetActualDancePoints(amount) end

--- Returns the player's actual dance points
---
--- |since_itg|
---
--- @retrun int
function PlayerStageStats:GetActualDancePoints() end

--- Sets the player's possible dance points to ``amount``
---
--- |since_notitg_v1|
---
--- @param amount integer The new possible dance points value to set
---
--- @return nil
function PlayerStageStats:SetPossibleDancePoints(amount) end

--- Returns the player's possible dance points
---
--- |since_itg|
---
--- @retrun int
function PlayerStageStats:GetPossibleDancePoints() end

--- Get the possible amount of dance points for a specific player on 192nd separated couples charts
---
--- |since_notitg_v4_9|
---
--- @retrun int
function PlayerStageStats:GetPossibleDancePointsCouplesP1() end

--- Get the possible amount of dance points for a specific player on 192nd separated couples charts
---
--- |since_notitg_v4_9|
---
--- @retrun int
function PlayerStageStats:GetPossibleDancePointsCouplesP2() end

--- Returns the player's dance points as a percentage (0 - 1)
---
--- This is the percentage score you see on the evaluation screen after completing a song (In the Simply Love theme).
---
--- |since_itg|
---
--- @return float
function PlayerStageStats:GetPercentDancePoints() end

--- Returns the player's grade
---
--- See :cpp:enum:`Grade`
---
--- @return integer
function PlayerStageStats:GetGrade() end

--- Sets the number of judgments obtained with the given ``tapNoteScore``
---
--- |since_notitg_v3|
---
--- @param tapNoteScore integer The judgment - see :cpp:enum:`TapNoteScore`
--- @param count integer The new number of judgments to set
---
--- @return integer
function PlayerStageStats:SetTapNoteScores(tapNoteScore, count) end

--- Returns the number of judgments obtained with the given ``tapNoteScore``
---
--- Returns ``-1`` for an invalid ``tapNoteScore``
---
--- |since_itg|
---
--- @param tapNoteScore integer The judgment - see :cpp:enum:`TapNoteScore`
---
--- @return integer
function PlayerStageStats:GetTapNoteScores(tapNoteScore) end

--- Sets the number of judgments obtained with the given ``holdNoteScore``
---
--- |since_notitg_v3|
---
--- @param holdNoteScore integer The judgment - see :cpp:enum:`HoldNoteScore`
--- @param count integer The new number of judgments to set
---
--- @return integer
function PlayerStageStats:SetHoldNoteScores(holdNoteScore, count) end

--- Returns the number of judgments obtained with the given ``holdNoteScore``
---
--- Returns ``-1`` for an invalid ``tapNoteScore``
---
--- |since_itg|
---
--- @param holdNoteScore integer The judgment - see :cpp:enum:`HoldNoteScore`
---
--- @return integer
function PlayerStageStats:GetHoldNoteScores(holdNoteScore) end

--- Sets the number of judgments obtained with the given ``holdNoteScore`` for a given player
---
--- |since_notitg_v3|
---
--- @param playerNumber integer The player number (1 indexed)
--- @param tapNoteScore integer The judgment - see :cpp:enum:`HoldNoteScore`
--- @param count integer The new number of judgments to set
---
--- @return nil
function PlayerStageStats:SetTapNoteScoresForPlayer(playerNumber, tapNoteScore, count) end

--- Returns the number of judgments obtained with the given ``tapNoteScore`` for a given player
---
--- |since_itg|
---
--- @param playerNumber integer The player number (1 indexed)
--- @param tapNoteScore integer The judgment - see :cpp:enum:`TapNoteScore`
---
--- @return integer
function PlayerStageStats:GetTapNoteScoresForPlayer(playerNumber, tapNoteScore) end

--- Returns the number of judgments obtained with the given ``holdNoteScore`` for a given player
---
--- |since_itg|
---
--- @param playerNumber integer The player number (1 indexed)
--- @param holdNoteScore integer The judgment - see :cpp:enum:`HoldNoteScore`
---
--- @return integer
function PlayerStageStats:GetHoldNoteScoresForPlayer(playerNumber, holdNoteScore) end

--- Sets the number of judgments obtained with the given ``holdNoteScore`` for a given player
---
--- |since_notitg_v3|
---
--- @param playerNumber integer The player number (1 indexed)
--- @param holdNoteScore integer The judgment - see :cpp:enum:`HoldNoteScore`
--- @param count integer The new number of judgments to set
---
--- @return nil
function PlayerStageStats:SetHoldNoteScoresForPlayer(playerNumber, holdNoteScore, count) end

--- Returns the player's current life as a percentage betwen 0 - 1
---
--- |since_itg|
---
--- @return float
function PlayerStageStats:GetCurrentLife() end

--- Returns the life remaining seconds
---
--- |since_itg|
---
--- @return float
function PlayerStageStats:GetLifeRemainingSeconds() end

--- Returns how long the player survived for, in seconds
---
--- |since_itg|
---
--- @return float
function PlayerStageStats:GetSurvivalSeconds() end

--- Returns a list of steps the player has played
---
--- |since_itg|
---
--- @reutrn Steps[]
function PlayerStageStats:GetPlayedSteps() end

--- Returns a list of possible steps
---
--- |since_itg|
---
--- @reutrn Steps[]
function PlayerStageStats:GetPossibleSteps() end

--- ?
---
--- |since_notitg_v3|
---
--- @return integer[]
function PlayerStageStats:GetNoteRowVector() end

--- ?
---
--- |since_notitg_v3|
---
--- @return integer[]
function PlayerStageStats:GetNoteSongVector() end

--- ?
---
--- Presumably returns a list of hit offsets for all notes, in milliseconds?
---
--- |since_notitg_v3|
---
--- @return float[]
function PlayerStageStats:GetOffsetVector() end

--- ?
---
--- |since_notitg_v3|
---
--- @return table
function PlayerStageStats:GetMineRowVector() end

--- Returns the number of estimated calories burned
---
--- |since_itg|
---
--- @return float
function PlayerStageStats:GetCaloriesBurned() end

--- Returns the current possible dance points
---
--- Useful to calculate subtractive score in lua
---
--- |since_notitg_v4_2_0|
---
--- @return integer
function PlayerStageStats:GetCurPossibleDancePoints() end

--- Tests for equality against another userdata object
---
--- |since_unk|
---
--- @param other userdata The object to test for equality against
---
--- @return boolean
function PlayerStageStats:__eq(other) end

--- Returns a ``PlayerStageStats (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function PlayerStageStats:__tostring() end

return PlayerStageStats
