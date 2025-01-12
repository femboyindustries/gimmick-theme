---@meta
---@diagnostic disable
--- @class FadingBanner: ActorFrame
--- @field public __index table Gives you the ``FadingBanner`` table again
FadingBanner = {}

--- Loads the banner for a given song
---
--- |since_itg|
---
--- @param song Song The song to load the banner from
---
--- @return nil
function FadingBanner:LoadFromSong(song) end

--- Scales the banner to the specified dimmensions
---
--- This is identical to :lua:meth:`Sprite.scaletoclipped`
---
--- |since_itg|
---
--- @param width number The desired width
--- @param height number The desired height
---
--- @return nil
function FadingBanner:ScaleToClipped(width, height) end

--- Returns a ``FadingBanner (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function FadingBanner:__tostring() end

return FadingBanner
