---@meta
---@diagnostic disable
-- Note for future me: You can't simply just type `ActorFrame` into a Lua console to get info about methods in
-- `ActorFrame` - instead, you can do something like `SCREENMAN("Footer").__index`

--- @class ActorFrame: Actor
--- @field public __index table Gives you the ``ActorFrame`` table again
ActorFrame = {}

--- Set the ActorFrame's field-of-view (used when rendering children)
---
--- |since_itg|
---
--- @param fov number The new field-of-view to use, in degrees
---
--- @return nil
function ActorFrame:fov(fov) end

--- Set the ActorFrame's field-of-view (used when rendering children)
---
--- This is just an alias for :lua:meth:`ActorFrame.fov`
---
--- |since_itg|
---
--- @param fov number The new field-of-view to use, in degrees
---
--- @return nil
function ActorFrame:SetFOV(fov) end

--- Sets the ActorFrame's update command
---
--- |since_itg|
---
--- @param name string The command name to call on updates
---
--- @return nil
function ActorFrame:SetUpdateCommand(name) end

--- Sets the ActorFrame's update function
---
--- Since |notitg_v4_2_0|, on error, a dialog is shown and the update function is unset.
---
--- |since_itg|
---
--- @param updateFunc function The function to call on updates
---
--- @return nil
function ActorFrame:SetUpdateFunction(updateFunc) end

--- Sets how frequently the ActorFrame should fire it's update command/function
---
--- |since_itg|
---
--- @param rate number The new update rate to use
---
--- @return nil
function ActorFrame:SetUpdateRate(rate) end

--- Returns the number of children the ActorFrame has
---
--- |since_itg|
---
--- @return integer
function ActorFrame:GetNumChildren() end

--- Returns all children of the ActorFrame in a table
---
--- |since_notitg_v4|
---
--- @return Actor[]
function ActorFrame:GetChildren() end

--- Returns a child with a given name
---
--- Will return ``nil`` if no child exists at with the specified name
---
--- |since_itg|
---
--- @param name string The name of the child to get
---
--- @return Actor|nil
function ActorFrame:GetChild(name) end

--- Returns a child at an index
---
--- Will return ``nil`` if no child exists at the given index
---
--- |since_notitg_v1|
---
--- @param index integer The index of the child to get
---
--- @return Actor|nil
function ActorFrame:GetChildAt(index) end

--- Sets the ActorFrame's draw distance
---
--- The default is ``1000``
---
--- |since_notitg_v3|
---
--- @param farDist number The new draw distance t oset
---
--- @return nil
function ActorFrame:SetFarDist(farDist) end

-- TODO: Link screen center consts

--- Sets the X coordinate for the ActorFrame's vanishing point
---
--- The default is ``SCREEN_CENTER_X``
---
--- |since_notitg_v1|
---
--- @param x number The X coordinate to set
---
--- @return nil
function ActorFrame:SetVanishX(x) end

--- Sets the Y coordinate for the ActorFrame's vanishing point
---
--- The default is ``SCREEN_CENTER_Y``
---
--- |since_notitg_v1|
---
--- @param y number The Y coordinate to set
---
--- @return nil
function ActorFrame:SetVanishY(y) end

--- Sets the vanishing point for the ActorFrame
---
--- The default is ``SCREEN_CENTER_X, SCREEN_CENTER_Y``
---
--- |since_notitg_v1|
---
--- @param x number The X coordinate to set
--- @param y number The Y coordinate to set
---
--- @return nil
function ActorFrame:SetVanishPoint(x, y) end

--- Set whether commands should be propagated to children
---
--- This is disabled by default
---
--- |since_itg|
---
--- @param enable integer ``1`` to enable, ``0`` to disable
---
--- @return nil
function ActorFrame:propagate(enable) end

--- Set whether shaders should be propagated to children
---
--- This is disabled by default
---
--- |since_notitg_v3|
---
--- @param enable integer ``1`` to enable, ``0`` to disable
---
--- @return nil
function ActorFrame:propagateshaders(enable) end

--- Sets the ActorFrame's draw function
---
--- |since_notitg_v1|
---
--- @param drawFunc function The function to call at every draw attempt
---
--- @return nil
function ActorFrame:SetDrawFunction(drawFunc) end

--- Sets whether the "draw by Z positon" behaviour should be enabled
---
--- This is disabled by default
---
--- |since_itg|
---
--- @param enable boolean Whether the "draw by Z positon" behavious should be enabled
---
--- @return nil
function ActorFrame:SetDrawByZPosition(enable) end

--- Returns a child of the actor frame
---
--- Will return ``nil`` if the child doesn't exist
---
--- |since_notitg_v4|
---
--- @param child string|int The name or index of the child to get
---
--- @return Actor|nil
function ActorFrame:__call(child) end

--- Return the number of children the ActorFrame has
---
--- |since_notitg_v4|
---
--- @return integer
function ActorFrame:__len() end

--- Retruns an ``ActorFrame (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function ActorFrame:__tostring() end

return ActorFrame
