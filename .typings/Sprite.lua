---@meta
---@diagnostic disable
--- @class Sprite: Actor
--- @field public __index table Gives you the ``Sprite`` table again
Sprite = {}

--- Sets the sprite's texture
---
--- |since_notitg_v1|
---
--- @param texture RageTexture The new texture to set
---
--- @return nil
function Sprite:SetTexture(texture) end

--- Returns the sprite's texture
---
--- |since_notitg_v1|
---
--- @return RageTexture
function Sprite:GetTexture() end

--- Sets the texture to the one at ``path``, or unsets if ``path`` is ``nil``
---
--- |since_itg|
---
--- @param path string|nil The texture path to load, or ``nil`` to unload
---
--- @return nil
function Sprite:Load(path) end

--- Like :lua:meth:`Sprite.Load`, but for song banners
---
--- |since_itg|
---
--- @param path string The texture path to load
---
--- @return nil
function Sprite:LoadBanner(path) end

--[[

--- Load a song banner texture
---
--- **Added by Simply Love theme**
---
--- @param song Song The song to load the banner from
---
--- @return nil
function Sprite:LoadFromSongBanner() end

--- Load a song background texture
---
--- **Added by Simply Love theme**
---
--- @param song Song The song to load the background from
---
--- @return nil
function Sprite:LoadFromSongBackground() end

]]

--- Like :lua:meth:`Sprite.Load`, but for song backgrounds
---
--- |since_itg|
---
--- @param path string The texture path to load
---
--- @return nil
function Sprite:LoadBackground(path) end

--- Sets whether an animated texture should loop
---
--- This is an alias for :lua:meth:`RageTexture.loop`
---
--- |since_itg|
---
--- @param enable boolean ``true`` to loop the animation, ``false`` to have a play-once animation
---
--- @return nil
function Sprite:loop(enable) end

--- Sets the animated texture's loop point
---
--- This can be used to make multiple-state animations using a single spritesheet - such as having a run cycle set the loop point when starting/stopping a run.
---
--- |since_notitg_v4|
---
--- @param point integer The new loop point to set
---
--- @return nil
function Sprite:looppoint(point) end

--- Returns the current frame of an animated texture
---
--- |since_notitg_v4|
---
--- @return integer
function Sprite:getstate() end

--- Sets the playback rate of an animated texture
---
--- This is an alias for :lua:meth:`RageTexture.rate`
---
--- |since_itg|
---
--- @param rate float The new playback rate to set (0 - 1)
---
--- @return nil
function Sprite:rate(rate) end

--- Scales the image to fit a rectangle
---
--- |since_itg|
---
--- @param left float The left coordinate of the rectangle
--- @param top float The left coordinate of the rectangle
--- @param right float The right coordinate of the rectangle
--- @param bottom float The bottom coordinate of the rectangle
---
--- @return nil
function Sprite:customtexturerect(left, top, right, bottom) end

--- Scales the sprite to the specified dimensions
---
--- |since_itg|
---
--- @param width float The target width
--- @param height float The height width
---
--- @return nil
function Sprite:scaletoclipped(width, height) end

--- Sets custom coordinates to the frames of the texture
---
--- |since_itg|
---
--- @param x float The X translation to apply
--- @param y float The Y translation to apply
---
--- @return nil
function Sprite:stretchtexcoords(x, y) end

--- Sets the texture scroll speed
---
--- A velocity of ``1`` means the texture will scroll entirely once per second - ``2`` makes it scroll twice per second, etc.
---
--- |since_itg|
---
--- @param x float The X scroll speed to apply
--- @param y float The Y scroll speed to apply
---
--- @return nil
function Sprite:texcoordvelocity(x, y) end

--- Returns the number of states the sprite has
---
--- |since_notitg_v4_2_0|
---
--- @return integer
function Sprite:GetNumStates() end

--- Returns an ``Sprite (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function Sprite:__tostring() end

return Sprite
