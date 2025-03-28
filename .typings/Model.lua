---@meta
---@diagnostic disable
--- @class Model: Actor
--- @field public __index table Gives you the ``Model`` table again
Model = {}

--- Plays a specified animation
---
--- |since_notitg_v2|
---
--- @param name string The animation name
--- @param rate float The playback speed
---
--- @return nil
function Model:playanimation(name, rate) end

--- ?
---
--- |since_notitg_v2|
---
--- @param name string The animation name
--- @param rate float The playback speed
--- @param frame number Frame?
---
--- @return nil
function Model:playanimationframe(name, rate, frame) end

--- Returns the number of animation frames the model has
---
--- |since_notitg_v2|
---
--- @return integer
function Model:GetTotalFrames() end

--- Returns the current animation frame (as a floating point number)
---
--- |since_notitg_v2|
---
--- @return integer
function Model:GetCurrentFrame() end

--- Returns the animation rate
---
--- |since_notitg_v2|
---
--- @param rate float The new rate to set
---
--- @return integer
function Model:SetAnimationRate(rate) end

--- Sets the current frame for all animated textures
---
--- Overridden from :lua:meth:`Actor.setstate`
---
--- |since_itg|
---
--- @param state integer The frame to show (0 indexed)
---
--- @return nil
function Model:setstate(state) end

--- When enabled, models use a fixed version of RageDisplay::SetMaterial that properly applies alpha, making the 0-1 diffuse range line up with other actor types
---
--- |since_notitg_v4_9|
---
--- @param enable boolean
---
--- @return nil
function Model:SetUseFullAlphaRange(enable) end

--- Sets the current frame for one animated texture
---
--- |since_notitg_v1|
---
--- @param state integer The frame to show (0 indexed)
--- @param index integer The texture index (0 indexed)
---
--- @return nil
function Model:setstateone(state, index) end

--- Enables/disables animation for one animated texture
---
--- |since_notitg_v1|
---
--- @param enable boolean Whether animation should be enabled
--- @param index integer The texture index (0 indexed)
---
--- @return nil
function Model:animateone(enable, index) end

--- Sets whether the model should use the depth/Z buffer
---
--- This defaults to ``true`` in an ``FGCHANGES`` and ``BETTERBGCHANGES`` layer, and ``false`` in a ``BGCHANGES`` layer.
---
--- |since_notitg_v1|
---
--- @param enable boolean Whether the depth buffer should be used
---
--- @return nil
function Model:SetUseZBuffer(enable) end

--- Sets a texture on the model
---
--- |since_notitg_v1|
---
--- @param index integer The texture slot index (0 indexed)
--- @param texture RageTexture The texture to set in the slot
---
--- @return nil
function Model:SetTexture(index, texture) end

--- Removes a texture from the model
---
--- |since_notitg_v1|
---
--- @param index integer The texture slot to clear (0 indexed)
---
--- @return nil
function Model:ResetTexture(index) end

--- Sets an alpha texture on the model
---
--- |since_notitg_v1|
---
--- @param index integer The texture slot index (0 indexed)
--- @param texture RageTexture The texture to set in the slot
---
--- @return nil
function Model:SetAlphaTexture(index, texture) end

--- Removes an alpha texture from the model
---
--- |since_notitg_v1|
---
--- @param index integer The texture slot to clear (0 indexed)
---
--- @return nil
function Model:ResetAlphaTexture(index) end

--- Sets the X translation for a texture
---
--- |since_notitg_v1|
---
--- @param index integer The texture slot (0 indexed)
--- @param x float The X translation to apply, in pixels
---
--- @return nil
function Model:SetTextureTranslateX(index, x) end

--- Sets the Y translation for a texture
---
--- |since_notitg_v1|
---
--- @param index integer The texture slot (0 indexed)
--- @param y float The Y translation to apply, in pixels
---
--- @return nil
function Model:SetTextureTranslateY(index, y) end

--- Sets the rotation for a texture
---
--- |since_notitg_v1|
---
--- @param index integer The texture slot (0 indexed)
--- @param rotation float The rotation to apply, in degrees
---
--- @return nil
function Model:SetTextureRotate(index, rotation) end

--- Sets the X scale for a texture
---
--- |since_notitg_v1|
---
--- @param index integer The texture slot (0 indexed)
--- @param x float The X scale to apply
---
--- @return nil
function Model:SetTextureScaleX(index, x) end

--- Sets the Y scale for a texture
---
--- |since_notitg_v1|
---
--- @param index integer The texture slot (0 indexed)
--- @param y float The Y scale to apply
---
--- @return nil
function Model:SetTextureScaleY(index, y) end

--- Sets the X and Y scale for a texture
---
--- |since_notitg_v1|
---
--- @param index integer The texture slot (0 indexed)
--- @param scale float The scale to apply
---
--- @return nil
function Model:SetTextureScale(index, scale) end

--- Sets this model's mesh
---
--- Eg: ``world.earth:LoadMilkshapeAscii(GAMESTATE:GetCurrentSong():GetSongDir() .. 'fg/model/circle_outline.obj.txt')``
---
--- |since_notitg_v2|
---
--- @param path string The path to the model to load
---
--- @return nil
function Model:LoadMilkshapeAscii(path) end

--- Load a skeleton for a 3D model
---
--- |since_notitg_v2|
---
--- @param aniName string The animation name
--- @param path string The path to the skeleton file to load
---
--- @return nil
function Model:LoadMilkshapeAsciiBones(aniName, path) end

--- Load materials for a 3D model
---
--- |since_notitg_v2|
---
--- @param path string The path to the materials file to load
---
--- @return nil
function Model:LoadMilkshapeAsciiMaterials(path) end

--- Sets the polygon drawing mode
---
--- |since_notitg_v1|
---
--- @param mode integer The new mode to set - see :cpp:enum:`PolygonMode`
---
--- @return nil
function Model:SetPolygonMode(mode) end

--- Sets the outline width
---
--- |since_notitg_v1|
---
--- @param width float The new width to set
---
--- @return nil
function Model:SetLineWidth(width) end

--- Sets the outline color
---
--- |since_notitg_v1|
---
--- @param r float The red value (0 - 1)
--- @param g float The green value (0 - 1)
--- @param b float The blue value (0 - 1)
--- @param a float The alpha value (0 - 1)
---
--- @return nil
function Model:SetLineColor(r, g, b, a) end

--- Sets whether outlines should be drawn on top
---
--- |since_notitg_v2|
---
--- @param enable boolean Whether outlines should be drawn on top
---
--- @return nil
function Model:SetOutlinesOnTop(enable) end

--- Sets whether the model should use cel shading
---
--- |since_notitg_v1|
---
--- @param enable boolean Whether cel shading should be enabled
---
--- @return nil
function Model:SetCelShaded(enable) end

--- Sets whether the cel shading should be inverted
---
--- |since_notitg_v2|
---
--- @param enable boolean Whether cel shading should be inverted
---
--- @return nil
function Model:SetInvertCelPass(enable) end

--- Returns an ``Model (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function Model:__tostring() end

return Model
