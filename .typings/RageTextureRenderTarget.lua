---@meta
---@diagnostic disable
--- @class RageTextureRenderTarget: RageTexture
--- @field public __index table Gives you the ``RageTextureRenderTarget`` table again
local RageTextureRenderTarget = {}

--- Begins rendering to the texture
---
--- |since_notitg_v1|
---
--- @param preserveTexture boolean Whether the currently stored texture should be preserved (not cleared) before rendering
---
--- @return nil
function RageTextureRenderTarget:BeginRenderingTo(preserveTexture) end

--- Stops rendering to the texture
---
--- |since_notitg_v1|
---
--- @return nil
function RageTextureRenderTarget:FinishRenderingTo() end

--- Returns a ``RageTextureRenderTarget (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function RageTextureRenderTarget:__tostring() end

return RageTextureRenderTarget
