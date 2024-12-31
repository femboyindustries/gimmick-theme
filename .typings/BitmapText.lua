---@meta
---@diagnostic disable
--- @class BitmapText: Actor
--- @field public __index table Gives you the ``BitmapText`` table again
local BitmapText = {}

--- Sets the text to be displayed
---
--- |since_itg|
---
--- @param text string The new text to display
---
--- @return nil
function BitmapText:settext(text) end

--- Returns the currently displayed text
---
--- |since_itg|
---
--- @return string
function BitmapText:GetText() end

--- Sets/clears the maximum width allowed for rendering text
---
--- This is independent of the actor's zoom
---
--- |since_itg|
---
--- @param width number The new maximum width to set, or 0 to disable the width limit
---
--- @return nil
function BitmapText:maxwidth(width) end

--- Sets/clears the maximum height allowed for rendering text
---
--- This is independent of the actor's zoom
---
--- |since_itg|
---
--- @param height number The new maximum height to set, or 0 to disable the height limit
---
--- @return nil
function BitmapText:maxheight(height) end

--- Sets the text wrapping point
---
--- |since_itg|
---
--- @param width integer Where to start wrapping text (in pixels)
---
--- @return nil
function BitmapText:wrapwidthpixels(width) end

--- Returns a ``BitmapText (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function BitmapText:__tostring() end

return BitmapText
