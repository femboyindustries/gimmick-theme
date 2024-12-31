---@meta
---@diagnostic disable
--- @class Player: ActorFrame
--- @field public __index table Gives you the ``Player`` table again
local Player = {}

--- Activate/deactivate a playfield
---
--- Useful for activating players 3 through 8
---
--- Returns the same boolean that you passed to the function
---
--- |since_notitg_v3|
---
--- @param enable boolean Whether the playfield should be awkake or not
---
--- @return boolean
function Player:SetAwake(enable) end

--- Returns whether a playfield is active
---
--- |since_notitg_v3|
---
--- @return boolean
function Player:IsAwake() end

--- Returns whether the player is using CMod (constant scroll speed)
---
--- |since_notitg_v3|
---
--- @return boolean
function Player:IsUsingCMod() end

--- Returns the player's CMod speed
---
--- Will return a value even if the player isn't using CMod
---
--- |since_notitg_v3|
---
--- @return integer
function Player:GetCMod() end

--- Returns the player's XMod speed
---
--- Will return a value even if the player isn't using XMod
---
--- |since_notitg_v3|
---
--- @return float
function Player:GetXMod() end

--- Returns the player's scroll speed
---
--- |since_notitg_v3|
---
--- @return float
function Player:GetSpeedMod() end

--- Sets the player's combo
---
--- |since_notitg_v3|
---
--- @param combo integer The new combo to set
---
--- @return nil
function Player:SetCombo(combo) end

--- Returns the player's combo
---
--- |since_notitg_v3|
---
--- @return integer
function Player:GetCombo() end

--- Sets the player's miss combo
---
--- |since_notitg_v3|
---
--- @param combo integer The new miss combo to set
---
--- @return nil
function Player:SetMissCombo(combo) end

--- Returns the player's miss combo
---
--- |since_notitg_v3|
---
--- @return integer
function Player:GetMissCombo() end


--- Replaces a player's steps
---
--- |since_notitg_v3|
---
--- @param chart integer Chart index? (0 indexed)
---
--- @return nil
function Player:SetNoteData(chart) end

--- Replaces a player's steps
---
--- |since_notitg_v3|
---
--- @param noteData table[table] See :ref:`note_data_format`
---
--- @return nil
function Player:SetNoteDataFromLua(noteData) end

--- Returns the chart's note data
---
--- See :ref:`note_data_format`
---
--- |since_notitg_v3_1|
---
--- @param startBeat float|nil The start beat number (can be ``nil`` if you want to fetch *all* note data)
--- @param endBeat float|nil The end beat number (can be ``nil`` if you want to fetch *all* note data)
---
--- @return table[]
function Player:GetNoteData(startBeat, endBeat) end

--- When enabled, models use a fixed version of RageDisplay::SetMaterial that properly applies alpha, making the 0-1 diffuse range line up with other actor types
---
--- |since_notitg_v4_9|
---
--- @param enable boolean
---
--- @return nil
function Player:SetUseFullAlphaRange(enable) end

--- Takes note data and stores it in a global variable
---
--- Prefer :lua:meth:`Player.GetNoteData` over this
---
--- See :ref:`note_data_format`
---
--- |since_notitg_v3|
---
--- @param varName string The global variable to store note data in
--- @param startBeat float|nil The start beat number (can be ``nil`` if you want to fetch *all* note data)
--- @param endBeat float|nil The end beat number (can be ``nil`` if you want to fetch *all* note data)
---
--- @return nil
function Player:PushNoteData(varName, startBeat, endBeat) end

--- Takes note data and stores it in a global variable
---
--- Like :lua:meth:`Player.PushNoteData`, but uses seconds instead of beats to measure time
---
--- |since_notitg_v3|
---
--- @param varName string The global variable to store note data in
--- @param startBeat float|nil The start beat number (can be ``nil`` if you want to fetch *all* note data)
--- @param endBeat float|nil The end beat number (can be ``nil`` if you want to fetch *all* note data)
---
--- @return nil
function Player:PushNoteDataTime(varName, startBeat, endBeat) end

--- Like :lua:meth:`Player.GetNoteData`, but the note data uses seconds instead of beat numbers
---
--- |since_notitg_v3|
---
--- @return table[]
function Player:GetNoteDataTime() end

--- Sets an X position spline
---
--- |since_notitg_v3|
---
--- @param index integer The spline index (0 - 39)
--- @param column integer Which column to apply the spline to (0 indexed, pass -1 to apply the spline to all columns)
--- @param value float What value the spline point should have
--- @param offset float How far away arrows will be when hitting the spline point (calculate a spline offset as ``beat_offset * 100 * xmod_speed``)
--- @param activationSpeed float How quickly spline changes should take effect (-1 for instant)
---
--- @return nil
function Player:SetXSpline(index, column, value, offset, activationSpeed) end

--- Reset all X position spline points for a column
---
--- |since_notitg_v4|
---
--- @param column integer The column to reset (0 indexed)
---
--- @return nil
function Player:ResetXSplines(column) end

--- Sets a Y position spline
---
--- |since_notitg_v3|
---
--- @param index integer The spline index (0 - 39)
--- @param column integer Which column to apply the spline to (0 indexed, pass -1 to apply the spline to all columns)
--- @param value float What value the spline point should have
--- @param offset float How far away arrows will be when hitting the spline point (calculate a spline offset as ``beat_offset * 100 * xmod_speed``)
--- @param activationSpeed float How quickly spline changes should take effect (-1 for instant)
---
--- @return nil
function Player:SetYSpline(index, column, value, offset, activationSpeed) end

--- Reset all Y position spline points for a column
---
--- |since_notitg_v4|
---
--- @param column integer The column to reset (0 indexed)
---
--- @return nil
function Player:ResetYSplines(column) end

--- Sets a Z position spline
---
--- |since_notitg_v3|
---
--- @param index integer The spline index (0 - 39)
--- @param column integer Which column to apply the spline to (0 indexed, pass -1 to apply the spline to all columns)
--- @param value float What value the spline point should have
--- @param offset float How far away arrows will be when hitting the spline point (calculate a spline offset as ``beat_offset * 100 * xmod_speed``)
--- @param activationSpeed float How quickly spline changes should take effect (-1 for instant)
---
--- @return nil
function Player:SetZSpline(index, column, value, offset, activationSpeed) end

--- Reset all Z position spline points for a column
---
--- |since_notitg_v4|
---
--- @param column integer The column to reset (0 indexed)
---
--- @return nil
function Player:ResetZSplines(column) end

--- Sets an X rotation spline
---
--- |since_notitg_v3|
---
--- @param index integer The spline index (0 - 39)
--- @param column integer Which column to apply the spline to (0 indexed, pass -1 to apply the spline to all columns)
--- @param value float What value the spline point should have
--- @param offset float How far away arrows will be when hitting the spline point (calculate a spline offset as ``beat_offset * 100 * xmod_speed``)
--- @param activationSpeed float How quickly spline changes should take effect (-1 for instant)
---
--- @return nil
function Player:SetRotXSpline(index, column, value, offset, activationSpeed) end

--- Reset all X rotation spline points for a column
---
--- |since_notitg_v4|
---
--- @param column integer The column to reset (0 indexed)
---
--- @return nil
function Player:ResetRotXSplines(column) end

--- Sets a Y rotation spline
---
--- |since_notitg_v3|
---
--- @param index integer The spline index (0 - 39)
--- @param column integer Which column to apply the spline to (0 indexed, pass -1 to apply the spline to all columns)
--- @param value float What value the spline point should have
--- @param offset float How far away arrows will be when hitting the spline point (calculate a spline offset as ``beat_offset * 100 * xmod_speed``)
--- @param activationSpeed float How quickly spline changes should take effect (-1 for instant)
---
--- @return nil
function Player:SetRotYSpline(index, column, value, offset, activationSpeed) end

--- Reset all Y rotation spline points for a column
---
--- |since_notitg_v4|
---
--- @param column integer The column to reset (0 indexed)
---
--- @return nil
function Player:ResetRotYSplines(column) end

--- Sets a Z rotation spline
---
--- |since_notitg_v3|
---
--- @param index integer The spline index (0 - 39)
--- @param column integer Which column to apply the spline to (0 indexed, pass -1 to apply the spline to all columns)
--- @param value float What value the spline point should have
--- @param offset float How far away arrows will be when hitting the spline point (calculate a spline offset as ``beat_offset * 100 * xmod_speed``)
--- @param activationSpeed float How quickly spline changes should take effect (-1 for instant)
---
--- @return nil
function Player:SetRotZSpline(index, column, value, offset, activationSpeed) end

--- Reset all Z rotation spline points for a column
---
--- |since_notitg_v4|
---
--- @param column integer The column to reset (0 indexed)
---
--- @return nil
function Player:ResetRotZSplines(column) end

--- Sets a size spline
---
--- Size spline points work like the ``Mini`` modifier (A value of 100 makes the arrows half size, 200 makes then have zero size, negative values makes arrows bigger)
---
--- |since_notitg_v3|
---
--- @param index integer The spline index (0 - 39)
--- @param column integer Which column to apply the spline to (0 indexed, pass -1 to apply the spline to all columns)
--- @param value float What value the spline point should have
--- @param offset float How far away arrows will be when hitting the spline point (calculate a spline offset as ``beat_offset * 100 * xmod_speed``)
--- @param activationSpeed float How quickly spline changes should take effect (-1 for instant)
---
--- @return nil
function Player:SetSizeSpline(index, column, value, offset, activationSpeed) end

--- Reset all size spline points for a column
---
--- |since_notitg_v4|
---
--- @param column integer The column to reset (0 indexed)
---
--- @return nil
function Player:ResetSizeSplines(column) end

--- Sets a skew spline
---
--- |since_notitg_v3|
---
--- @param index integer The spline index (0 - 39)
--- @param column integer Which column to apply the spline to (0 indexed, pass -1 to apply the spline to all columns)
--- @param value float What value the spline point should have
--- @param offset float How far away arrows will be when hitting the spline point (calculate a spline offset as ``beat_offset * 100 * xmod_speed``)
--- @param activationSpeed float How quickly spline changes should take effect (-1 for instant)
---
--- @return nil
function Player:SetSkewSpline(index, column, value, offset, activationSpeed) end

--- Reset all skew spline points for a column
---
--- |since_notitg_v4|
---
--- @param column integer The column to reset (0 indexed)
---
--- @return nil
function Player:ResetSkewSplines(column) end


--- Sets a stealth spline
---
--- Size spline points work like the ``Stealth`` modifier
---
--- |since_notitg_v3|
---
--- @param index integer The spline index (0 - 39)
--- @param column integer Which column to apply the spline to (0 indexed, pass -1 to apply the spline to all columns)
--- @param value float What value the spline point should have
--- @param offset float How far away arrows will be when hitting the spline point (calculate a spline offset as ``beat_offset * 100 * xmod_speed``)
--- @param activationSpeed float How quickly spline changes should take effect (-1 for instant)
---
--- @return nil
function Player:SetStealthSpline(index, column, value, offset, activationSpeed) end

--- Reset all stealth spline points for a column
---
--- |since_notitg_v4|
---
--- @param column integer The column to reset (0 indexed)
---
--- @return nil
function Player:ResetStealthSplines(column) end
--- Set whether the ``mod,clearall`` command should reset splines
---
--- |since_notitg_v3|
---
--- @param enable boolean ``true`` to prevent spline clearing when mods are cleared, ``false`` to let mod clearing also reset splines
---
--- @return nil
function Player:NoClearSplines(enable) end

--- Sets a custom shader to use for drawing arrows
---
--- |since_notitg_v3|
---
--- @param shader RageShaderProgram The custom shader to set
---
--- @return nil
function Player:SetArrowShader(shader) end

--- Returns the custom shader used for drawing arrows
---
--- Will return ``nil`` if no custom shader has been set
---
--- |since_notitg_v3|
---
--- @return RageShaderProgram|nil
function Player:GetArrowShader() end

--- Removes any custom shader for drawing arrows
---
--- |since_notitg_v3|
---
--- @return nil
function Player:ClearArrowShader() end

--- Sets a custom shader to use for drawing holds
---
--- |since_notitg_v3|
---
--- @param shader RageShaderProgram The custom shader to set
---
--- @return nil
function Player:SetHoldShader(shader) end

--- Returns the custom shader used for drawing holds
---
--- Will return ``nil`` if no custom shader has been set
---
--- |since_notitg_v3|
---
--- @return RageShaderProgram|nil
function Player:GetHoldShader() end

--- Removes any custom shader for drawing holds
---
--- |since_notitg_v3|
---
--- @return nil
function Player:ClearHoldShader() end

--- Sets a custom shader to use for drawing receptors
---
--- |since_notitg_v3|
---
--- @param shader RageShaderProgram The custom shader to set
---
--- @return nil
function Player:SetReceptorShader(shader) end

--- Returns the custom shader used for drawing receptors
---
--- Will return ``nil`` if no custom shader has been set
---
--- |since_notitg_v3|
---
--- @return RageShaderProgram|nil
function Player:GetReceptorShader() end

--- Removes any custom shader for drawing receptors
---
--- |since_notitg_v3|
---
--- @return nil
function Player:ClearReceptorShader() end

--- Sets a custom shader to use for drawing arrow paths
---
--- |since_notitg_v3|
---
--- @param shader RageShaderProgram The custom shader to set
---
--- @return nil
function Player:SetArrowPathShader(shader) end

--- Returns the custom shader used for drawing arrow paths
---
--- Will return ``nil`` if no custom shader has been set
---
--- |since_notitg_v3|
---
--- @return RageShaderProgram|nil
function Player:GetArrowPathShader() end

--- Removes any custom shader for drawing arrow paths
---
--- |since_notitg_v3|
---
--- @return nil
function Player:ClearArrowPathShader() end

--- Sets the number of points the arrow gradient will have
---
--- |since_notitg_v3|
---
--- @param column integer The column to apply it to (0 indexed)
--- @param amount integer The number of points
---
--- @return nil
function Player:SetNumArrowGradientPoints(column, amount) end

--- Sets the position of an arrow gradient point along a column
---
--- |since_notitg_v3|
---
--- @param point integer The point index (0 indexed)
--- @param column integer The column (0 indexed)
--- @param offset float How far away from the receptors the point should be (where ``1`` = the size of an arrow = ``64`` pixels)
---
--- @return nil
function Player:SetArrowGradientPoint(point, column, offset) end

--- Sets the color of an arrow gradient point
---
--- |since_notitg_v3|
---
--- @param point integer The point index (0 indexed)
--- @param column integer The column (0 indexed)
--- @param r float The red value (0 - 1)
--- @param g float The green value (0 - 1)
--- @param b float The blue value (0 - 1)
--- @param a float The alpha value (0 - 1)
---
--- @return nil
function Player:SetArrowGradientColor(point, column, r, g, b, a) end

--- Sets the number of points the stealth gradient will have
---
--- |since_notitg_v3|
---
--- @param column integer The column to apply it to (0 indexed)
--- @param amount integer The number of points
---
--- @return nil
function Player:SetNumStealthGradientPoints(column, amount) end

--- Sets the position of a stealth gradient point along a column
---
--- |since_notitg_v3|
---
--- @param point integer The point index (0 indexed)
--- @param column integer The column (0 indexed)
--- @param offset float How far away from the receptors the point should be (where ``1`` = the size of an arrow = ``64`` pixels)
---
--- @return nil
function Player:SetStealthGradientPoint(point, column, offset) end

--- Sets the color of a stealth gradient point
---
--- |since_notitg_v3|
---
--- @param point integer The point index (0 indexed)
--- @param column integer The column (0 indexed)
--- @param r float The red value (0 - 1)
--- @param g float The green value (0 - 1)
--- @param b float The blue value (0 - 1)
--- @param a float The alpha value (0 - 1)
---
--- @return nil
function Player:SetStealthGradientColor(point, column, r, g, b, a) end

--- Sets the number of points the path gradient will have
---
--- |since_notitg_v3|
---
--- @param column integer The column to apply it to (0 indexed)
--- @param amount integer The number of points
---
--- @return nil
function Player:SetNumPathGradientPoints(column, amount) end

--- Sets the position of a path gradient point along a column
---
--- |since_notitg_v3|
---
--- @param point integer The point index (0 indexed)
--- @param column integer The column (0 indexed)
--- @param offset float How far away from the receptors the point should be (where ``1`` = the size of an arrow = ``64`` pixels)
---
--- @return nil
function Player:SetPathGradientPoint(point, column, offset) end

--- Sets the color of a path gradient point
---
--- |since_notitg_v3|
---
--- @param point integer The point index (0 indexed)
--- @param column integer The column (0 indexed)
--- @param r float The red value (0 - 1)
--- @param g float The green value (0 - 1)
--- @param b float The blue value (0 - 1)
--- @param a float The alpha value (0 - 1)
---
--- @return nil
function Player:SetPathGradientColor(point, column, r, g, b, a) end

--- Sets the arrow path's blend mode
---
--- Default value is ``normal``
---
--- |since_notitg_v3_1|
---
--- @param mode string The new blend mode to set (``normal``, ``add``, ``subtract``, ``modulate``, ``copysrc``, ``alphamask``, ``alphaknockout``, ``alphamultiply``, ``weightedmultiply``, ``invertdest``, ``noeffect``)
---
--- @return nil
function Player:SetArrowPathBlendMode(mode) end

--- Sets regions of arrows that should be hidden
---
--- A hidden regions looks like ``{ startBeat, endBeat, column }``. If column is omitted, then the hidden region applies to all columns.
---
--- |since_notitg_v4|
---
--- @param regions table[] A list of regions to hide
---
--- @return nil
function Player:SetHiddenRegions(regions) end

--- Removes all hidden regions
---
--- |since_notitg_v4|
---
--- @return nil
function Player:ClearHiddenRegions() end

--- Swaps a noteskin directly from Lua without attacks
---
--- |since_notitg_v4_9|
---
--- @param noteSkin string Name of the noteskin
--- @param startBeat float
--- @param endBeat float
---
--- @return nil
function Player:SetNoteSkinForBeatRange(noteSkin, startBeat, endBeat) end

--- Caches a noteskin, to prevent stutters during gameplay
---
--- |since_notitg_v4_9|
---
--- @param noteSkin string Name of the noteskin
---
--- @return nil
function Player:CacheNoteSkin(noteSkin) end

--- Changes the draw mode of arrowpaths
---
--- |since_notitg_v4_9|
---
--- @param drawMode string The draw mode (``triangles`` or ``fan`` or ``strip`` or ``linestrip``)
---
--- @return nil
function Player:SetArrowPathDrawMode(drawMode) end

--- Multiplies the note type (timing color) of notes
---
--- A note time multiplier looks like ``{ startBeat, multiplier }``. All notes after ``startBeat`` will be multiplied by ``multiplier``.
---
--- |since_notitg_v4|
---
--- @param multipliers table[] A list of multiplier tables
---
--- @return nil
function Player:SetNoteTypeMults(multipliers) end

--- Removes all note type multipliers
---
--- |since_notitg_v4|
---
--- @return nil
function Player:ClearNoteTypeMults() end

--- Simulates a step (without triggering any note hits)
---
--- This makes the receptor play its pressed animation
---
--- |since_notitg_v3|
---
--- @param column integer The column to press
---
--- @return nil
function Player:FakeStep(column) end

--- ?
---
--- |since_notitg_v3|
---
--- @param column integer The column
---
--- @return nil
function Player:FakeSetPressed(column) end

--- Simulates a step (triggering any note hits)
---
--- This also makes the receptor play its pressed animation
---
--- |since_notitg_v3|
---
--- @param column integer The column to press
---
--- @return nil
function Player:RealStep(column) end

--- Simulates a note being hit
---
--- This generates a receptor flash
---
--- Judgment values
---
--- ``1``: Fantastic
---
--- ``2``: Excellent
---
--- ``3``: Great
---
--- ``4``: Decent
---
--- ``5``: Way off
---
--- ``8``: Mine hit
---
--- |since_notitg_v3|
---
--- @param column integer The column to flash (0 indexed)
--- @param judgment integer The judgment
--- @param unk boolean|nil unknown
---
--- @return nil
function Player:DidTapNote(column, judgment, unk) end

--- Simulates a hold note being held to completion
---
--- This generates a receptor flash
---
--- |since_notitg_v3|
---
--- @param column integer The column to flash (0 indexed)
--- @param unk boolean|nil unknown
---
--- @return nil
function Player:DidHoldNote(column, unk) end

--- Returns the number of taps in a range
---
--- |since_notitg_v3|
---
--- @param startBeat float The start beat
--- @param endBeat float The end beat
---
--- @return integer
function Player:GetNumTapsInRange(startBeat, endBeat) end

--- Sets the player's controller (whether it should be controlled by a human or by the game)
---
--- |since_notitg_v3|
---
--- @param controller integer The new controller to set (See :cpp:enum:`PlayerController`)
---
--- @return nil
function Player:SetPlayerController(controller) end

--- Sets which player's inputs should control the player
---
--- |since_notitg_v3|
---
--- @param player integer ``0`` for player 1, ``1`` for player 2, ``>1`` for AutoPlay
---
--- @return nil
function Player:SetInputPlayer(player) end

--- Sets the mine sound
---
--- |since_notitg_v3|
---
--- @param path string The file path to mine sound file
---
--- @return nil
function Player:SetMineSound(path) end

--- Sends a judgment
---
--- Judgment numbers:
---
--- ``1``: Fantastic
---
--- ``2``: Excellent
---
--- ``3``: Great
---
--- ``4``: Decent
---
--- ``5``: Way off
---
--- ``6``: Miss
---
--- |since_notitg_v3|
---
--- @param judgment integer The judgment to send
--- @param early boolean ``true`` for an early judgment, ``false`` for a late judgment
--- @param offset float|nil Optional judgment offset, in milliseconds
--- @param beat float|nil Optional beat number
---
--- @return nil
function Player:SendJudgment(judgment, early, offset, beat) end

--- Checks if a player is using ``Reverse`` or not
---
--- This just checks the reverse state of column 0
---
--- |since_notitg_v4_2_0|
---
--- @return boolean
function Player:IsUsingReverse() end

--- Set the turn mod used with the "Randomize" mod
---
--- The default is ``SuperShuffle``
---
--- |since_notitg_v4_2_0|
---
--- @param mod string The turn mod to use
---
--- @return nil
function Player:SetRandomVanishTransform(mod) end

--- Returns a ``Player (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function Player:__tostring() end

return Player
