---@meta
---@diagnostic disable
--- @class Polygon: Actor
--- @field public __index table Gives you the ``Polygon`` table again
Polygon = {}

--- Sets the number of vertices for the polygon actor
---
--- Do this before manipulating other vertices
---
--- |since_notitg_unk|
---
--- @param count integer The number of vertices
---
--- @return nil
function Polygon:SetNumVertices(count) end

--- Returns the number of vertices the polygon actor has
---
--- |since_notitg_unk|
---
--- @return integer
function Polygon:GetNumVertices() end

--- Sets a vertex's position
---
--- |since_notitg_unk|
---
--- @param index integer The vertex index (0 indexed)
--- @param x float The vertex's X position
--- @param y float The vertex's Y position
--- @param z float The vertex's Z position
---
--- @return nil
function Polygon:SetVertexPosition(index, x, y, z) end

--- Returns a vertex's position
---
--- This function returns multiple values - use it as such:
---
--- ``local x, y, z = polygon:GetVertexPosition(0)``
---
--- |since_notitg_unk|
---
--- @param index integer The vertex index (0 indexed)
---
--- @return multiple
function Polygon:GetVertexPosition(index) end

--- Sets a vertex's normal
---
--- |since_notitg_unk|
---
--- @param index integer The vertex index (0 indexed)
--- @param x float The X component of the vertex's normal
--- @param y float The Y component of the vertex's normal
--- @param z float The Z component of the vertex's normal
---
--- @return nil
function Polygon:SetVertexNormal(index, x, y, z) end

--- Returns a vertex's normal
---
--- This function returns multiple values - use it as such:
---
--- ``local x, y, z = polygon:GetVertexNormal(0)``
---
--- |since_notitg_unk|
---
--- @param index integer The vertex index (0 indexed)
---
--- @return multiple
function Polygon:GetVertexNormal(index) end

--- Sets a vertex's color
---
--- |since_notitg_unk|
---
--- @param index integer The vertex index (0 indexed)
--- @param r float The red value
--- @param g float The green value
--- @param b float The blue value
--- @param a float The alpha value
---
--- @return nil
function Polygon:SetVertexColor(index, r, g, b, a) end

--- Returns a vertex's color
---
--- This function returns multiple values - use it as such:
---
--- ``local r, g, b, a = polygon:GetVertexColor(0)``
---
--- |since_notitg_unk|
---
--- @param index integer The vertex index (0 indexed)
---
--- @return multiple
function Polygon:GetVertexColor(index) end

--- Sets a vertex's alpha
---
--- |since_notitg_unk|
---
--- @param index integer The vertex index (0 indexed)
--- @param a float The alpha value
---
--- @return nil
function Polygon:SetVertexAlpha(index, a) end

--- Sets a vertex's texture coordinate
---
--- |since_notitg_unk|
---
--- @param index integer The vertex index (0 indexed)
--- @param u float The U value (X position)
--- @param v float The V value (Y position)
--- @param w float|nil The W value (Z position - irrelevant for 2D textures)
---
--- @return nil
function Polygon:SetVertexTexCoord(index, u, v, w) end

--- Returns a vertex's texture coordinate
---
--- This function returns multiple values - use it as such:
---
--- ``local u, v, w = polygon:GetVertexTexCoord(0)``
---
--- |since_notitg_unk|
---
--- @param index integer The vertex index (0 indexed)
---
--- @return multiple
function Polygon:GetVertexTexCoord(index) end

--- Sets the polygon drawing mode (Lines or filled)
---
--- |since_notitg_unk|
---
--- @param mode integer The new mode to set - see :cpp:enum:`PolygonMode`
---
--- @return nil
function Polygon:SetPolygonMode(mode) end

--- Sets the polygon actor's draw mode
---
--- |since_notitg_unk|
---
--- @param mode string The draw mode (``triangles`` or ``quads`` or ``quadstrip`` or ``fan`` or ``strip`` or ``linestrip``)
---
--- @return nil
function Polygon:SetDrawMode(mode) end

--- ???
---
--- |since_notitg_unk|
---
--- @param index integer The vertex index (0 indexed)
---
--- @return nil
function Polygon:AddDrawSplit(index) end

--- Sets the width for drawing lines (if the actor is in line polygon mode)
---
--- |since_notitg_unk|
---
--- @param width float The line width
---
--- @return nil
function Polygon:SetLineWidth(width) end

--- Sets the polygon actor's texture
---
--- |since_notitg_unk|
---
--- @param texture RageTexture the texture to set
---
--- @return nil
function Polygon:SetTexture(texture) end

--- Returns the polygon actor's texture
---
--- |since_notitg_unk|
---
--- @return RageTexture
function Polygon:GetTexture() end

return Polygon
