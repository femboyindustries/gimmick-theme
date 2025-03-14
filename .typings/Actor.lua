---@meta
---@diagnostic disable
--- @class Actor
--- @field public __index table Gives you the ``Actor`` table again
Actor = {}
--- @alias Quad Actor

--- Sets the actor's X position
---
--- |tweenable|
---
--- |since_itg|
---
--- @param xPos number The new X position to set
---
--- @return nil
function Actor:x(xPos) end

--- Returns the actor's X position
---
--- |since_itg|
---
--- @return number
function Actor:GetX() end

--- Returns the actor's X position, taking ino account active effects
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetEffectX() end

--- Sets the actor's Y position
---
--- Note that a greater Y value moves an actor *down*, not up.
---
--- |tweenable|
---
--- |since_itg|
---
--- @param yPos number The new Y position to set
---
--- @return nil
function Actor:y(yPos) end

--- Returns the actor's Y position
---
--- |since_itg|
---
--- @return number
function Actor:GetY() end

--- Returns the actor's Y position, taking ino account active effects
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetEffectY() end

--- Sets the actor's Z position
---
--- |tweenable|
---
--- |since_itg|
---
--- @param zPos number The new Z position to set
---
--- @return nil
function Actor:z(zPos) end

--- Returns the actor's Z position
---
--- |since_itg|
---
--- @return number
function Actor:GetZ() end

--- Returns the actor's Z position, taking ino account active effects
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetEffectZ() end

--- Sets the actor's X and Y positions
---
--- Note that a greater Y value moves an actor *down*, not up.
---
--- |tweenable|
---
--- |since_notitg_v1|
---
--- @param xPos number The new X position to set
--- @param yPos number The new Y position to set
---
--- @return nil
function Actor:xy(xPos, yPos) end

--- Sets the actor's X, Y, and Z positions
---
--- Note that a greater Y value moves an actor *down*, not up.
---
--- |tweenable|
---
--- |since_notitg_v3|
---
--- @param xPos number The new X position to set
--- @param yPos number The new Y position to set
--- @param zPos number The new Z position to set
---
--- @return nil
function Actor:xyz(xPos, yPos, zPos) end

--- Sets the actor's X, Y, and Z positions, as well as it's aux value
---
--- Note that a greater Y value moves an actor *down*, not up.
---
--- |tweenable|
---
--- |since_notitg_v3|
---
--- @param xPos number The new X position to set
--- @param yPos number The new Y position to set
--- @param zPos number The new Z position to set
--- @param aux number The new aux value to set
---
--- @return nil
function Actor:xyza(xPos, yPos, zPos, aux) end

--- Adds ``x`` to the actor's current X position
---
--- |tweenable|
---
--- |since_itg|
---
--- @param x number How much to translate the actor on the X axis
---
--- @return nil
function Actor:addx(x) end

--- Adds ``y`` to the actor's current Y position
---
--- Note that a greater Y value moves an actor *down*, not up.
---
--- |tweenable|
---
--- |since_itg|
---
--- @param y number How much to translate the actor on the Y axis
---
--- @return nil
function Actor:addy(y) end

--- Adds ``z`` to the actor's current Z position
---
--- |tweenable|
---
--- |since_itg|
---
--- @param z number How much to translate the actor on the Z axis
---
--- @return nil
function Actor:addz(z) end

--- Sets the actor's X rotation (Pitch)
---
--- Note that the default rotation order for actors is ZYX. This can be changed using ``Actor.SetRotationOrder()``.
---
--- |tweenable|
---
--- |since_itg|
---
--- @param rotX number The new X rotation to set, in degrees
---
--- @return nil
function Actor:rotationx(rotX) end

--- Returns the actor's X rotation (Pitch)
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetRotationX() end

--- Returns the actor's current X rotation
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetCurrentRotationX() end

--- Returns the actor's current X rotation, taking into account active effects
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetEffectRotationX() end

--- Sets the actor's Y rotation (Yaw/Heading)
---
--- Note that the default rotation order for actors is ZYX. This can be changed using ``Actor.SetRotationOrder()``.
---
--- |tweenable|
---
--- |since_itg|
---
--- @param rotY number The new Y rotation to set, in degrees
---
--- @return nil
function Actor:rotationy(rotY) end

--- Returns the actor's Y rotation (Yaw/Heading)
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetRotationY() end

--- Returns the actor's current Y rotation
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetCurrentRotationY() end

--- Returns the actor's current Y rotation, taking into account active effects
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetEffectRotationY() end

--- Sets the actor's Z rotation (Roll)
---
--- Note that the default rotation order for actors is ZYX. This can be changed using ``Actor.SetRotationOrder()``.
---
--- |tweenable|
---
--- |since_itg|
---
--- @param rotZ number The new Z rotation to set, in degrees
---
--- @return nil
function Actor:rotationz(rotZ) end

--- Returns the actor's Z rotation (Yaw/Heading)
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetRotationZ() end

--- Returns the actor's current Z rotation
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetCurrentRotationZ() end

--- Returns the actor's current Z rotation, taking ino account active effects
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetEffectRotationZ() end

--- Sets the actor's X, Y and Z rotation
---
--- Note that the default rotation order for actors is ZYX. This can be changed using ``Actor.SetRotationOrder()``.
---
--- |tweenable|
---
--- |since_notitg_v4_9|
---
--- @param rotX number The new X rotation to set, in degrees
--- @param rotY number The new Y rotation to set, in degrees
--- @param rotZ number The new Z rotation to set, in degrees
---
--- @return nil
function Actor:rotationxyz(rotX, rotY, rotZ) end

--- Adds to the actor's current X, Y and Z rotation
---
--- Note that the default rotation order for actors is ZYX. This can be changed using ``Actor.SetRotationOrder()``.
---
--- |tweenable|
---
--- |since_notitg_v4_9|
---
--- @param rotX number The new X rotation to set, in degrees
--- @param rotY number The new Y rotation to set, in degrees
--- @param rotZ number The new Z rotation to set, in degrees
---
--- @return nil
function Actor:addrotationxyz(rotX, rotY, rotZ) end

--- Returns the actor's rotation
---
--- This function returns three values - use it as such:
---
--- .. code-block:: lua
---
---    local x_rot, y_rot, z_rot = actor:getrotation()
---
--- |since_itg|
---
--- @return multiple
function Actor:getrotation() end

--- Returns the actor's current rotation
---
--- This function returns three values - use it as such:
---
--- .. code-block:: lua
---
---    local x_rot, y_rot, z_rot = actor:getcurrentrotation()
---
--- |since_notitg_v4|
---
--- @return multiple
function Actor:getcurrentrotation() end

--- Adds ``rotX`` to the actor's X rotation
---
--- Always rotates around the top-left corner of the screen
---
--- Note that the default rotation order for actors is ZYX. This can be changed using ``Actor.SetRotationOrder()``.
---
--- |tweenable|
---
--- |since_itg|
---
--- @param rotX number The value to add, in degrees
---
--- @return nil
function Actor:pitch(rotX) end

--- Adds ``rotX`` to the actor's X rotation
---
--- Note that the default rotation order for actors is ZYX. This can be changed using ``Actor.SetRotationOrder()``.
---
--- |tweenable|
---
--- |since_notitg_v3|
---
--- @param rotX number The value to add, in degrees
---
--- @return nil
function Actor:addrotationx(rotX) end

--- Adds ``rotY`` to the actor's Y rotation
---
--- Always rotates around the top-left corner of the screen
---
--- Note that the default rotation order for actors is ZYX. This can be changed using ``Actor.SetRotationOrder()``.
---
--- |tweenable|
---
--- |since_itg|
---
--- @param rotY number The value to add, in degrees
---
--- @return nil
function Actor:heading(rotY) end

--- Adds ``rotY`` to the actor's Y rotation
---
--- Note that the default rotation order for actors is ZYX. This can be changed using ``Actor.SetRotationOrder()``.
---
--- |tweenable|
---
--- |since_notitg_v3|
---
--- @param rotY number The value to add, in degrees
---
--- @return nil
function Actor:addrotationy(rotY) end

--- Adds ``rotZ`` to the actor's Z rotation
---
--- Always rotates around the top-left corner of the screen
---
--- Note that the default rotation order for actors is ZYX. This can be changed using ``Actor.SetRotationOrder()``.
---
--- |tweenable|
---
--- |since_itg|
---
--- @param rotZ number The value to add, in degrees
---
--- @return nil
function Actor:roll(rotZ) end

--- Adds ``rotZ`` to the actor's Z rotation
---
--- Note that the default rotation order for actors is ZYX. This can be changed using ``Actor.SetRotationOrder()``.
---
--- |tweenable|
---
--- |since_notitg_v3|
---
--- @param rotZ number The value to add, in degrees
---
--- @return nil
function Actor:addrotationz(rotZ) end

--- Sets the order of rotation when rotating with Euler angles
---
--- The default rotation order is ``zyx``.
---
--- |since_notitg_v4|
---
--- @param order string A 3 character string dictating the rotation order (Eg: ``xyz`` or ``zyx`` or ``yzx``)
---
--- @return nil
function Actor:SetRotationOrder(order) end

--- Returns a 3 character string dictating the current order of rotation when rotating with Euler angles
---
--- The default rotation order is ``zyx``.
---
--- Example return values include ``xyz`` or ``zyx`` or ``yzx``.
---
--- |since_notitg_v4|
---
--- @return string
function Actor:GetRotationOrder() end

--- Sets the actor's X scale
---
--- |tweenable|
---
--- |since_itg|
---
--- @param scale number The new X scale to set
---
--- @return nil
function Actor:zoomx(scale) end

--- Returns the actor's X scale
---
--- |since_itg|
---
--- @return number
function Actor:GetZoomX() end

--- Returns the actor's current X scale
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetCurrentZoomX() end

--- Sets the actor's Y scale
---
--- |tweenable|
---
--- |since_itg|
---
--- @param scale number The new Y scale to set
---
--- @return nil
function Actor:zoomy(scale) end

--- Returns the actor's Y scale
---
--- |since_itg|
---
--- @return number
function Actor:GetZoomY() end

--- Returns the actor's current Y scale
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetCurrentZoomY() end

--- Sets the actor's Z scale
---
--- |tweenable|
---
--- |since_itg|
---
--- @param scale number The new Z scale to set
---
--- @return nil
function Actor:zoomz(scale) end

--- Returns the actor's Z scale
---
--- |since_itg|
---
--- @return number
function Actor:GetZoomZ() end

--- Returns the actor's current Z scale
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetCurrentZoomZ() end

--- Sets the actor's X and Y scale (not Z!)
---
--- |tweenable|
---
--- |since_itg|
---
--- @param scale number The new X/Y scale to set
---
--- @return nil
function Actor:zoom(scale) end

--- Returns the actor's X scale
---
--- |since_itg|
---
--- @return number
function Actor:GetZoom() end

--- Sets the actor's width
---
--- |since_notitg_v1|
---
--- @param width number The new width to set, in pixels
---
--- @return nil
function Actor:SetWidth(width) end

--- Returns the actor's width
---
--- |since_itg|
---
--- @return number
function Actor:GetWidth() end

--- Sets the actor's height
---
--- Not tweenable!
---
--- |since_itg|
---
--- @param height number The new height to set, in pixels
---
--- @return nil
function Actor:SetHeight(height) end

--- Sets the actor's width
---
--- Not tweenable!
---
--- |since_itg|
---
--- @return number
function Actor:GetHeight() end

--- Sets the actor's X scale to fit a width
---
--- |tweenable|
---
--- |since_itg|
---
--- @param width number The desired width
---
--- @return nil
---
--- @see Actor#zoomtoheight
--- @see Actor#zoomto
function Actor:zoomtowidth(width) end

--- Sets the actor's Y scale to fit a height
---
--- |tweenable|
---
--- |since_itg|
---
--- @param height number The desired height
---
--- @return nil
---
--- @see Actor#zoomtowidth
--- @see Actor#zoomto
function Actor:zoomtoheight(height) end

--- Sets the actor's X and Y scale to fit a width and height
---
--- This does the same thing as calling both :lua:meth:`Actor.zoomtowidth` and :lua:meth:`Actor.zoomtoheight`.
---
--- |tweenable|
---
--- |since_itg|
---
--- @param width number The desired width
--- @param height number The desired height
---
--- @return nil
---
--- @see Actor#zoomtowidth
--- @see Actor#zoomtoheight
function Actor:zoomto(width, height) end

--- Scales an actor to cover a rectangle
---
--- This does not preserve aspect ratio - see :lua:meth:`Actor.scaletofit` instead if you want that
---
--- |tweenable|
---
--- |since_itg|
---
--- @param left number The left coordinate of the rectangle
--- @param top number The top coordinate of the rectangle
--- @param right number The right coordinate of the rectangle
--- @param bottom number The bottom coordinate of the rectangle
---
--- @return nil
function Actor:scaletocover(left, top, right, bottom) end

--- Scales an actor to cover a rectangle, preserving aspect ratio
---
--- See :lua:meth:`Actor.scaletocover` if you don't care about preserving aspect ratio
---
--- |tweenable|
---
--- |since_itg|
---
--- @param left number The left coordinate of the rectangle
--- @param top number The top coordinate of the rectangle
--- @param right number The right coordinate of the rectangle
--- @param bottom number The bottom coordinate of the rectangle
---
--- @return nil
function Actor:scaletofit(left, top, right, bottom) end

--- Scales an actor to cover a rectangle defined by a top left and bottom right point
---
--- |since_itg|
---
--- @param x1 number The X coordinate of the top left corner
--- @param y1 number The Y coordinate of the top left corner
--- @param x2 number The X coordinate of the bottom right corner
--- @param y2 number The Y coordinate of the bottom right corner
---
--- @return nil
function Actor:stretchto(x1, y1, x2, y2) end

--- Sets the actor's X and Y position, as well as its width and height
---
--- Note that a greater Y value moves an actor *down*, not up.
---
--- |tweenable|
---
--- |since_notitg_v3|
---
--- @param x number The new X position
--- @param y number The new Y position
--- @param w number The new width
--- @param h number The new height
---
--- @return nil
function Actor:xywh(x, y, w, h) end

--- Sets the actor's base X scale
---
--- Not tweenable!
---
--- |since_itg|
---
--- @param scale number The new base X scale to set
---
--- @return nil
function Actor:basezoomx(scale) end

--- Returns the actor's base X scale
---
--- |since_itg|
---
--- @return number
function Actor:GetBaseZoomX() end

--- Sets the actor's base Y scale
---
--- Not tweenable!
---
--- |since_itg|
---
--- @param scale number The new base Y scale to set
---
--- @return nil
function Actor:basezoomy(scale) end

--- Returns the actor's base Y scale
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetBaseZoomY() end

--- Sets the actor's base Z scale
---
--- Not tweenable!
---
--- |since_notitg_v4|
---
--- @param scale number The new base Z scale to set
---
--- @return nil
function Actor:basezoomz(scale) end

--- Returns the actor's base Z scale
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetBaseZoomZ() end

--- Sets the actor's horizontal skew
---
--- |tweenable|
---
--- |since_itg|
---
--- @param amount number How far the actor should be skewed
---
--- @return nil
function Actor:skewx(amount) end

--- Returns the actor's horizontal skew
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetSkewX() end

--- Sets the actor's vertical skew
---
--- |tweenable|
---
--- |since_notitg_v4|
---
--- @param amount number How far the actor should be skewed
---
--- @return nil
function Actor:skewy(amount) end

--- Returns the actor's vertical skew
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetSkewY() end

--- Skews the actor horizontally, based on the original width of the actor
---
--- This is effectively the same as ``Actor.skewx()`` with ``amount`` divided by the original (unzoomed) width of the actor.
---
--- |tweenable|
---
--- |since_notitg_v1|
---
--- @param amount number How far the actor should be skewed
---
--- @return nil
function Actor:skewto(amount) end

--- Sets the actor's horizontal skew before applying rotation
---
--- Not tweenable!
---
--- |since_notitg_v4|
---
--- @param amount number How far the actor should be skewed
---
--- @return nil
function Actor:skewx_before_rotation(amount) end

--- Sets the actor's vertical skew before applying rotation
---
--- Not tweenable!
---
--- |since_notitg_v4|
---
--- @param amount number How far the actor should be skewed
---
--- @return nil
function Actor:skewy_before_rotation(amount) end

--- Sets the actor's second layer X position
---
--- This cannot be tweened and must be set on an update loop.
---
--- |since_notitg_v4|
---
--- @param xPos number The new X position to set
---
--- @return nil
function Actor:x2(xPos) end

--- Sets the actor's second layer Y position
---
--- This cannot be tweened and must be set on an update loop.
---
--- |since_notitg_v4|
---
--- @param yPos number The new Y position to set
---
--- @return nil
function Actor:y2(yPos) end

--- Sets the actor's second layer Z position
---
--- This cannot be tweened and must be set on an update loop.
---
--- |since_notitg_v4|
---
--- @param zPos number The new Z position to set
---
--- @return nil
function Actor:z2(zPos) end

--- Sets the actor's second layer X and Y positions
---
--- These cannot be tweened and must be set on an update loop.
---
--- |since_notitg_v4|
---
--- @param xPos number The new X position to set
--- @param yPos number The new Y position to set
---
--- @return nil
function Actor:xy2(xPos, yPos) end

--- Sets the actor's second layer X, Y, and Z positions
---
--- These cannot be tweened and must be set on an update loop.
---
--- |since_notitg_v4|
---
--- @param xPos number The new X position to set
--- @param yPos number The new Y position to set
--- @param zPos number The new Z position to set
---
--- @return nil
function Actor:xyz2(xPos, yPos, zPos) end

--- Sets the actor's second layer X rotation (Pitch)
---
--- This cannot be tweened and must be set on an update loop.
---
--- |since_notitg_v4|
---
--- @param rotX number The new X rotation to set
---
--- @return nil
function Actor:rotationx2(rotX) end

--- Sets the actor's second layer Y rotation (Yaw/Heading)
---
--- This cannot be tweened and must be set on an update loop.
---
--- |since_notitg_v4|
---
--- @param rotY number The new Y rotation to set
---
--- @return nil
function Actor:rotationy2(rotY) end

--- Sets the actor's second layer Z rotation (Roll)
---
--- This cannot be tweened and must be set on an update loop.
---
--- |since_notitg_v4|
---
--- @param rotZ number The new Z rotation to set
---
--- @return nil
function Actor:rotationz2(rotZ) end

--- Sets the actor's second layer X, Y, and Z rotations
---
--- These cannot be tweened and must be set on an update loop.
---
--- |since_notitg_v4|
---
--- @param rotX number The new X rotation to set
--- @param rotY number The new Y rotation to set
--- @param rotZ number The new Z rotation to set
---
--- @return nil
function Actor:rotationxyz2(rotX, rotY, rotZ) end

--- Sets the actor's second layer X scale
---
--- |since_notitg_v4|
---
--- @param scale number The new X scale to set
---
--- @return nil
function Actor:zoomx2(scale) end

--- Sets the actor's second layer Y scale
---
--- |since_notitg_v4|
---
--- @param scale number The new Y scale to set
---
--- @return nil
function Actor:zoomy2(scale) end

--- Sets the actor's second layer Z scale
---
--- |since_notitg_v4|
---
--- @param scale number The new Z scale to set
---
--- @return nil
function Actor:zoomz2(scale) end

--- Sets the actor's second layer X and Y scale (not Z!)
---
--- |since_notitg_v4|
---
--- @param scale number The new X/Y scale to set
---
--- @return nil
function Actor:zoom2(scale) end

--- Sets the actor's second layer X, Y, and Z scale
---
--- |since_notitg_v4|
---
--- @param scaleX number The new X scale to set
--- @param scaleY number The new Y scale to set
--- @param scaleZ number The new Z scale to set
---
--- @return nil
function Actor:zoomxyz2(scaleX, scaleY, scaleZ) end

--- Sets the actor's second layer horizontal skew
---
--- |since_notitg_v4|
---
--- @param amount number How far the actor should be skewed
---
--- @return nil
function Actor:skewx2(amount) end

--- Sets the actor's second layer vertical skew
---
--- |since_notitg_v4|
---
--- @param amount number How far the actor should be skewed
---
--- @return nil
function Actor:skewy2(amount) end

--- Sets the actor's aux value
---
--- An aux value is simply a tweenable property on an actor that has no visual effect on its own
---
--- |tweenable|
---
--- |since_itg|
---
--- @param value number The new aux value to set
---
--- @return nil
function Actor:aux(value) end

--- Returns the actor's aux value
---
--- |since_itg|
---
--- @return number
function Actor:getaux() end

--- Adds ``deltaAux`` to the actor's aux value
---
--- |tweenable|
---
--- |since_notitg_v4|
---
--- @param deltaAux number How much to add to the aux value
---
--- @return nil
function Actor:addaux(deltaAux) end

--- Sets the actor's horizontal alignment
---
--- This effectively changes the origin point of the actor
---
--- A horizontal alignment of ``0`` will left-align the actor, ``0.5`` will center align, and ``1`` will right align.
--- You can also specify values outside of the range of 0 - 1.
---
--- Note that this does not work for aligning :lua:class:`BitmapText` actors, use :lua:meth:`Actor.horizalogn` instead.
---
--- Not tweenable!
---
--- |since_notitg_v1|
---
--- @param hPos number The new horizontal alignment to set
---
--- @return nil
function Actor:halign(hPos) end

--- Sets the actor's vertical alignment
---
--- This effectively changes the origin point of the actor
---
--- A vertical alignment of ``0`` will top-align the actor, ``0.5`` will center align, and ``1`` will bottom align.
--- You can also specify values outside of the range of 0 - 1.
---
--- Not tweenable!
---
--- |since_notitg_v1|
---
--- @param vPos number The new vertical alignment to set
---
--- @return nil
function Actor:valign(vPos) end

--- Sets the actor's horizontal and vertical alignment
---
--- This effectively changes the origin point of the actor
---
--- A horizontal alignment of ``0`` will top-align the actor, ``0.5`` will center align, and ``1`` will bottom align.
--- A horizontal alignment of ``0`` will left-align the actor, ``0.5`` will center align, and ``1`` will right align.
--- You can also specify values outside of the range of 0 - 1.
---
--- Not tweenable!
---
--- |since_notitg_v1|
---
--- @param hPos number The new horizontal alignment to set
--- @param vPos number The new vertical alignment to set
---
--- @return nil
function Actor:align(hPos, vPos) end

--- Sets the actor's horizontal alignment
---
--- This effectively changes the origin point of the actor
---
--- See :lua:meth:`Actor.halign` for a more precise alignment
---
--- Not tweenable!
---
--- |since_itg|
---
--- @param hAlign string The new horizontal alignment to set (``left``, ``center``, or ``right``)
---
--- @return nil
function Actor:horizalign(hAlign) end

--- Sets the actor's vertical alignment
---
--- This effectively changes the origin point of the actor
---
--- See :lua:meth:`Actor.valign` for a more precise alignment
---
--- Not tweenable!
---
--- |since_itg|
---
--- @param vAlign string The new vertical alignment to set (``top``, ``middle``, ``bottom``)
---
--- @return nil
function Actor:vertalign(vAlign) end

--- Sets the actor's Z bias
---
--- This value defaults to ``0``.
---
--- Useful to anil Z-fighting
---
--- |since_itg|
---
--- @param bias number The bias to apply
---
--- @return nil
function Actor:zbias(bias) end

--- Set whether the actor should write to the depth/Z buffer
---
--- This is disabled by default
---
--- |since_itg|
---
--- @param enable integer ``1`` to enable, ``0`` to disable
---
--- @return nil
function Actor:zwrite(enable) end

--- Set whether the actor uses the depth/Z buffer
---
--- |since_itg|
---
--- @param enable integer ``1`` to enable, ``0`` to disable
---
--- @return nil
function Actor:zbuffer(enable) end

--- Set the depth/Z buffer test mode
---
--- This is a shortcut for :lua:meth:`Actor.ztestmode`
---
--- |since_itg|
---
--- @param enable integer ``1`` to write fragments when the Z test passes and discard fragments otherwise, ``0`` to disable Z testing
---
--- @return nil
function Actor:ztest(enable) end

--- Set the depth/Z buffer test mode
---
--- Z testing is often used when rendering 3D objects to ensure that objects closer to the camera are drawn on top of
--- objects further away. When an object is drawn, it'll write the depth of each fragment into a depth buffer (if
--- :lua:meth:`zwrite` is enabled). When drawing another object, the depth of each fragment of the new object will be
--- tested against the depth of each fragment in the depth buffer. When typically rendering a 3D scene, only fragments
--- that have a lower depth (fragments that are closer to the camera) will be drawn, with fragments further away than
--- what's stored in the depth buffer (and thus behind the first object) discarded.
---
--- Note that if you're rendering translucent objects, enabling depth testing can cause issues with objects disappearing
--- behind other objects if they're not draw in in a back-to-front order. The order of actors in an XML file determines
--- the order in which they are drawn.
---
--- Z test mode is ``off`` by default.
---
--- Available Z test modes include...
---
--- - ``off``: Disable Z testing
--- - ``writeonpass``: Write fragments when the Z test passes (usual 3D behaviour)
--- - ``writeonfail``: Write fragments when the Z test fails
---
--- |since_itg|
---
--- @param mode string ``off``, ``writeonpass``, or ``writeonfail``
---
--- @return nil
---
--- @see Actor#zwrite
--- @see Actor#ztest
--- @see Actor#clearzbuffer
function Actor:ztestmode(mode) end

--- Sets whether to clear RGBA or just the alpha channel, useful in combination with transparent AFTs
---
--- Default value is ``1`` (RGBA)
---
--- |since_notitg_v4_9|
---
--- @param mode integer ``1`` = clear RGBA, ``2`` = clear only A
---
--- @return nil
function Actor:clearbuffer(mode) end

--- Sets whether the depth/Z buffer should be cleared when drawing the actor
---
--- Default value is ``0`` (don't clear)
---
--- |since_itg|
---
--- @param enable integer ``1`` to clear, ``0`` to not clear
---
--- @return nil
function Actor:clearzbuffer(enable) end

--- Sets whether the actor should be hidden
---
--- |since_itg|
---
--- @param enable integer ``1`` to hide the actor, ``0`` to show the actor
---
--- @return nil
function Actor:hidden(enable) end

--- Returns whether an actor is hidden or not
---
--- |since_notitg_v3_1|
---
--- @return boolean
function Actor:GetHidden() end

--- Sets whether the actor should be visible
---
--- This is simply :lua:meth:`Actor.hidden` but inverted
---
--- |since_itg|
---
--- @param enable integer ``0`` to hide the actor, ``1`` to show the actor
---
--- @return nil
function Actor:visible(enable) end

--- Hides the actor for ``time`` seconds
---
--- |since_itg|
---
--- @param time number How long to hide the actor for, in seconds
---
--- @return nil
function Actor:hibernate(time) end

--- Returns the parent :lua:class:`ActorFrame` of this actor
---
--- Can return ``nil`` if there is no parent (such as the case when trying to get the parent of the top screen).
---
--- |since_notitg_v4|
---
--- @return ActorFrame|nil
function Actor:GetParent() end

--- Sets the actor's name
---
--- You can also set an actor's initial name using the ``Name`` XML attribute.
---
--- |since_notitg_v1|
---
--- @param name string The new name to set
---
--- @return nil
function Actor:SetName(name) end

--- Returns the actor's name
---
--- The default actor name is an empty string - this does not return nil if a name hasn't been set.
---
--- |since_notitg_v1|
---
--- @return string
function Actor:GetName() end

--- Sets the actor's color/tint
---
--- Default value is ``1, 1, 1, 1`` (white)
---
--- |since_itg|
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1)
---
--- @return nil
function Actor:diffuse(r, g, b, a) end

--- Returns the actor's color/tint
---
--- This function returns three values - use it as such:
---
--- .. code-block:: lua
---
---    local r, g, b, a = actor:getdiffuse()
---
--- |since_notitg_v3|
---
--- @return number, number, number, number
function Actor:getdiffuse() end

--- Sets the actor's color/tint - ignores alpha
---
--- Default value is ``1, 1, 1, 1`` (white)
---
--- |since_itg|
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1) **This is ignored but still needs to be present**
---
--- @return nil
function Actor:diffusecolor(r, g, b, a) end

--- Sets the actor's alpha, without modifying the R/G/B diffuse values
---
--- Default value is ``1`` (fully opaque)
---
--- |since_itg|
---
--- @param alpha number The new alpha value to set (0 - 1)
---
--- @return nil
function Actor:diffusealpha(alpha) end

--- Tints the bottom edge of the actor
---
--- |since_itg|
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1)
---
--- @return nil
function Actor:diffusebottomedge(r, g, b, a) end

--- Tints the left edge of the actor
---
--- |since_itg|
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1)
---
--- @return nil
function Actor:diffuseleftedge(r, g, b, a) end

--- Tints the right edge of the actor
---
--- |since_itg|
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1)
---
--- @return nil
function Actor:diffuserightedge(r, g, b, a) end

--- Tints the top edge of the actor
---
--- |since_itg|
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1)
---
--- @return nil
function Actor:diffusetopedge(r, g, b, a) end

--- Tints the top left corner of the actor
---
--- |since_itg|
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1)
---
--- @return nil
function Actor:diffuseupperleft(r, g, b, a) end

--- Tints the top right corner of the actor
---
--- |since_itg|
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1)
---
--- @return nil
function Actor:diffuseupperright(r, g, b, a) end

--- Tints the bottom left corner of the actor
---
--- |since_itg|
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1)
---
--- @return nil
function Actor:diffuselowerleft(r, g, b, a) end

--- Tints the bottom right corner of the actor
---
--- |since_itg|
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1)
---
--- @return nil
function Actor:diffuselowerright(r, g, b, a) end

--- Makes the actor bounce
---
--- |effect|
---
--- |since_itg|
---
--- @return nil
function Actor:bounce() end

--- Makes the actor smoothly move between two points (like on a sine wave)
---
--- |effect|
---
--- |since_itg|
---
--- @return nil
function Actor:bob() end

--- Makes the actor blink between 2 colors
---
--- |effect|
---
--- |since_itg|
---
--- @return nil
function Actor:diffuseblink() end

--- Makes the actor's color animate linearly from one to another, before instantly switching to the first one again
---
--- |effect|
---
--- |since_itg|
---
--- @return nil
function Actor:diffuseramp() end

--- Like :lua:meth:`Actor.diffuseramp`, but uses a sine curve
---
--- |effect|
---
--- |since_itg|
---
--- @return nil
function Actor:diffuseshift() end

--- Makes the actor glow, with the glow blinking on and off
---
--- |effect|
---
--- |since_itg|
---
--- @return nil
function Actor:glowblink() end

--- Makes the actor glow, with the glow fading off before instantly turning back on
---
--- |effect|
---
--- |since_notitg_v3|
---
--- @return nil
function Actor:glowramp() end

--- Makes the actor glow, with the glow fading on and off
---
--- |effect|
---
--- |since_itg|
---
--- @return nil
function Actor:glowshift() end

--- Makes the actor grow and shrink smoothly
---
--- |effect|
---
--- |since_itg|
---
--- @return nil
function Actor:pulse() end

--- Makes the actor grow and shrink on a sawtooth wave
---
--- |effect|
---
--- |since_notitg_v3|
---
--- @return nil
function Actor:pulseramp() end

--- Makes the actor rotate back and forth
---
--- |effect|
---
--- |since_itg|
---
--- @return nil
function Actor:wag() end

--- Like :lua:meth:`Actor.wag`, but instead of interpolating, it just blinks between its start/end rotations
---
--- |effect|
---
--- |since_notitg_v3|
---
--- @return nil
function Actor:floorwag() end

--- Makes the actor change color between the colors of the rainbow, smoothly
---
--- |effect|
---
--- |since_itg|
---
--- @return nil
function Actor:rainbow() end

--- Makes the actor spin continually
---
--- |effect|
---
--- |since_itg|
---
--- @return nil
function Actor:spin() end

--- Makes the actor vibrate
---
--- |effect|
---
--- |since_itg|
---
--- @return nil
function Actor:vibrate() end

--- Returns how long an actor has been running an effect for, in seconds
---
--- |since_itg|
---
--- @return number
function Actor:GetSecsIntoEffect() end

--- Stops any running effects on the actor
---
--- |since_itg|
---
--- @return nil
function Actor:stopeffect() end

--- Sets the effect period (this multiplies the speed of the effect)
---
--- |since_itg|
---
--- @param period number The new effect period to set
---
--- @return nil
function Actor:effectperiod(period) end

--- Sets which clock effects are synced up to
---
--- Default value is ``timer``
---
--- |since_itg|
---
--- @param clock sync The clock to sync with (Should be ``timer``, ``beat``, ``music``, or ``bgm``)
function Actor:effectclock(clock) end

--- Sets the delay between effects repeating
---
--- |since_itg|
---
--- @param delay number The delay to apply, in seconds
---
--- @return nil
function Actor:effectdelay(delay) end

--- Sets the offset of effects applied to the actor
---
--- |since_itg|
---
--- @param delay number The offset to apply, in seconds
---
--- @return nil
function Actor:effectoffset(delay) end

--- Returns the current effect delta of the actor
---
--- |since_itg|
---
--- @return number
function Actor:GetEffectDelta() end

--- Sets the actor's effect magnitude
---
--- Magnitudes are set per-axis, hence the X, Y, and Z parameters
---
--- @param x number The new X magnitude to set
--- @param y number The new Y magnitude to set
--- @param z number The new Z magnitude to set
---
--- @return nil
function Actor:effectmagnitude(x, y, z) end

--- Returns the actor's effect magnidude
---
--- This function returns three values - use it as such:
---
--- .. code-block:: lua
---
---    local x_mag, y_mag, z_mag = actor:geteffectmagnitude()
---
--- |since_itg|
---
--- @return multiple
function Actor:geteffectmagnitude() end

--- Disableds effects and instead uses an actor command/hook to draw the actor
---
--- This causes ``<name>Command`` to be fired on the actor every frame
---
--- |since_itg|
---
--- @param name string The name of the command to fire each frame
---
--- @return nil
function Actor:luaeffect(name) end

--- Sets the first color for effects
---
--- Used with :lua:meth:`Actor.diffuseblink`, :lua:meth:`Actor.diffuseramp`, and :lua:meth:`Actor.diffuseshift`.
---
--- Default value is ``1, 1, 1, 1`` (white)
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1)
---
--- @return nil
function Actor:effectcolor1(r, g, b, a) end

--- Sets the second color for effects
---
--- Used with :lua:meth:`Actor.diffuseblink`, :lua:meth:`Actor.diffuseramp`, and :lua:meth:`Actor.diffuseshift`.
---
--- Default value is ``1, 1, 1, 1`` (white)
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1)
---
--- @return nil
function Actor:effectcolor2(r, g, b, a) end


--- Makes the actor glow - used for glow effects
---
--- |tweenable|
---
--- |since_itg|
---
--- @param r number The red value (0 - 1)
--- @param g number The green value (0 - 1)
--- @param b number The blue value (0 - 1)
--- @param a number The alpha value (0 - 1)
---
--- @return nil
function Actor:glow(r, g, b, a) end

--- Starts a linear tween
---
--- Tweenable methods called after this will be linearly interpolated
---
--- |tween|
---
--- |since_itg|
---
--- @param duration number How long the tween should last, in seconds
---
--- @return nil
function Actor:linear(duration) end

--- Starts a accelerate tween
---
--- Tweenable methods called after this will accelerate as they approace the tween's end (``time_percent ^ 2``)
---
--- |tween|
---
--- |since_itg|
---
--- @param duration number How long the tween should last, in seconds
---
--- @return nil
function Actor:accelerate(duration) end

--- Starts a decelerate tween
---
--- Tweenable methods called after this will decelerate as they approace the tween's end (``1 - (1 - time_percent) * (1 - time_percent)``)
---
--- |tween|
---
--- |since_itg|
---
--- @param duration number How long the tween should last, in seconds
---
--- @return nil
function Actor:decelerate(duration) end

--- Starts a spring tween
---
--- Tweenable methods called after this will accelerate and go beyond their end point, before springing back
---
--- |tween|
---
--- |since_itg|
---
--- @param duration number How long the tween should last, in seconds
---
--- @return nil
function Actor:spring(duration) end

--- Starts a bounce begin tween
---
--- Tweenable methods called after this will bounce at the beginning before interpolating towards their end point
---
--- |tween|
---
--- |since_itg|
---
--- @param duration number How long the tween should last, in seconds
---
--- @return nil
function Actor:bouncebegin(duration) end

--- Starts a bounce end tween
---
--- Tweenable methods called after this will interpolate towards their end point before bouncing at the end
---
--- |tween|
---
--- |since_itg|
---
--- @param duration number How long the tween should last
---
--- @return nil
function Actor:bounceend(duration) end

--- Starts a sleep tween
---
--- Tweenable methods called after do nothing for the duration of the sleep tween, before instantly teleporting at the end
---
--- |tween|
---
--- |since_itg|
---
--- @param duration number How long the tween should last, in seconds
---
--- @return nil
function Actor:sleep(duration) end

--- Starts a custom expression tween
---
--- A custom Lua expression can be passed to ``expression``. For example, an expression of ``%f * %f * %f`` makes a cubic accelerate tween.
---
--- Since |notitg_v4_2_0|, a function can also be passed to ``expression``.
---
--- |tween|
---
--- |since_notitg_v3|
---
--- @param duration number How long the tween should last, in seconds
--- @param expression string|function Either a Lua expression mapping time to interpolation percent, or a Lua function taking a time argument and returning a number
---
--- @return nil
function Actor:tween(duration, expression) end

--- Multiply the speed of current and queued tweens
---
--- |since_itg|
---
--- @param factor number The scale factor to apply
---
--- @return nil
function Actor:hurrytweening(factor) end

--- Immediately stop any running tweens
---
--- If you would rather have tweens teleport to their end points, use :lua:meth:`Actor.finishtweening` instead.
---
--- |since_itg|
---
--- @return nil
function Actor:stoptweening() end

--- Immediately finishes current and queued tweens
---
--- |since_itg|
---
--- @return nil
function Actor:finishtweening() end

--- Resumes tweening on the actor if it was paused
---
--- |since_itg|
---
--- @return nil
function Actor:play() end

--- Pauses tweening on the actor
---
--- |since_itg|
---
--- @return nil
function Actor:pause() end

--- Returns the amount of time remaining for the current tween, in seconds
---
--- Returns ``0`` is no tween is currently running.
---
--- |since_notitg_v4|
---
--- @return number
function Actor:GetTweenTimeLeft() end -- nitg v4

--- Execute a command string on the actor
---
--- Command notation is just shorthand to call methods on ``self``. For example, the command string ``hidden,1;diffuse,1,0,1,1`` is shorthand for ``self:hidden(1)`` and ``self:diffuse(1, 0, 1, 1)``
---
--- |since_notitg_v1|
---
--- @param cmd string The command string to execute
---
--- @return nil
function Actor:cmd(cmd) end

--- Set whether textures should cubic interpolation when scaled
---
--- Defaults to ``true``
---
--- |since_notitg_v1|
---
--- @param enable boolean Whether texture filtering should be enabled
---
--- @return nil
function Actor:SetTextureFiltering(enable) end

--- An alias for :lua:meth:`Actor.SetTextureFiltering`
---
--- |since_notitg_v4|
---
--- @param enable boolean Whether texture filtering should be enabled
---
--- @return nil
function Actor:texturefiltering(enable) end

--- Set whether textures should wrap
---
--- Default value is ``0`` (disabled)
---
--- |since_itg|
---
--- @param enable integer ``1`` to enable, ``0`` to disable
---
--- @return nil
function Actor:texturewrapping(enable) end

--- An alias for :lua:meth:`Actor.texturewrapping`
---
--- |since_notitg_v4|
---
--- @param enable integer ``1`` to enable, ``0`` to disable
---
--- @return nil
function Actor:SetTextureWrapping(enable) end

--- (Re-)Draws an actor manually
---
--- Useful in combination with :lua:meth:`ActorFrame.SetDrawFunction`
---
--- |since_notitg_v1|
---
--- @return nil
function Actor:Draw() end

--- Sets the shader program the actor should use for rendering
---
--- |since_notitg_v3|
---
--- @param shader RageShaderProgram The shader program to use
---
--- @return nil
function Actor:SetShader(shader) end

--- Returns the shader program in use by the actor, or ``nil`` if no custom shader has been set
---
--- |since_notitg_v3|
---
--- @return RageShaderProgram|nil
function Actor:GetShader() end

--- Removes the actor's shader program
---
--- This makes the actor use the default shader
---
--- |since_notitg_v3|
---
--- @return nil
function Actor:ClearShader() end

--- Changes the render order of actors
---
--- Larger values are displayed first
---
--- |since_itg|
---
--- @param order integer Where this actor should be in the draw order
---
--- @return nil
function Actor:draworder(order) end

--- Sets whether back faces should be culled (hidden) or not
---
--- Default value is ``0`` (cull none)
---
--- Also see :lua:meth:`Actor.backfacecull`
---
--- |since_itg|
---
--- @param enable integer ``1`` to cull back faces, ``0`` to cull nothing
---
--- @return nil
function Actor:backfacecull(enable) end

--- Sets what faces of the actor should be culled (hidden)
---
--- Default value is ``none``
---
--- |since_itg|
---
--- @param mode string The new face culling method to use (``back``, ``front``, or ``none``)
---
--- @return nil
function Actor:cullmode(mode) end

--- Sets the actor's shadow length
---
--- Not tweenable!
---
--- |since_itg|
---
--- @param length number The new shadow length to set
---
--- @return nil
function Actor:shadowlength(length) end

--- Fades the actor out on the left
---
--- |tweenable|
---
--- |since_itg|
---
--- @param percent number The percentage of the actor that should be faded (generally between 0 - 1, but can be larger)
---
--- @return nil
function Actor:fadeleft(percent) end

--- Fades the actor out on the top
---
--- |tweenable|
---
--- |since_itg|
---
--- @param percent number The percentage of the actor that should be faded (generally between 0 - 1, but can be larger)
---
--- @return nil
function Actor:fadetop(percent) end

--- Fades the actor out on the right
---
--- |tweenable|
---
--- |since_itg|
---
--- @param percent number The percentage of the actor that should be faded (generally between 0 - 1, but can be larger)
---
--- @return nil
function Actor:faderight(percent) end

--- Fades the actor out on the bottom
---
--- |tweenable|
---
--- |since_itg|
---
--- @param percent number The percentage of the actor that should be faded (generally between 0 - 1, but can be larger)
---
--- @return nil
function Actor:fadebottom(percent) end

--- Fades the actor out on the left and right
---
--- |tweenable|
---
--- |since_notitg_v3|
---
--- @param percentLeft number The percentage of the actor that should be faded from the left (generally between 0 - 1, but can be larger)
--- @param percentRight number The percentage of the actor that should be faded from the right (generally between 0 - 1, but can be larger)
---
--- @return nil
function Actor:fadeh(percentLeft, percentRight) end

--- Fades the actor out on the top and bottom
---
--- |tweenable|
---
--- |since_notitg_v3|
---
--- @param percentTop number The percentage of the actor that should be faded from the top (generally between 0 - 1, but can be larger)
--- @param percentBottom number The percentage of the actor that should be faded from the bottom (generally between 0 - 1, but can be larger)
---
--- @return nil
function Actor:fadev(percentTop, percentBottom) end

--- Fades the actor out on all edges
---
--- |tweenable|
---
--- |since_notitg_v3|
---
--- @param percentLeft number The percentage of the actor that should be faded from the left (generally between 0 - 1, but can be larger)
--- @param percentTop number The percentage of the actor that should be faded from the top (generally between 0 - 1, but can be larger)
--- @param percentRight number The percentage of the actor that should be faded from the right (generally between 0 - 1, but can be larger)
--- @param percentBottom number The percentage of the actor that should be faded from the bottom (generally between 0 - 1, but can be larger)
---
--- @return nil
function Actor:fade(percentLeft, percentTop, percentRight, percentBottom) end

-- TODO: CHECK IF FADING/CROPPING IS TWEENABLE!

--- Crops the actor on the left
---
--- |tweenable|
---
--- |since_itg|
---
--- @param percent number The percentage of the actor that should be cropped (0 - 1)
---
--- @return nil
function Actor:cropleft(percent) end

--- Crops the actor on the top
---
--- |tweenable|
---
--- |since_itg|
---
--- @param percent number The percentage of the actor that should be cropped (0 - 1)
---
--- @return nil
function Actor:croptop(percent) end

--- Crops the actor on the right
---
--- |tweenable|
---
--- |since_itg|
---
--- @param percent number The percentage of the actor that should be cropped (0 - 1)
---
--- @return nil
function Actor:cropright(percent) end

--- Crops the actor on the bottom
---
--- |tweenable|
---
--- |since_itg|
---
--- @param percent number The percentage of the actor that should be cropped (0 - 1)
---
--- @return nil
function Actor:cropbottom(percent) end

--- Crops the actor on the left and right
---
--- |tweenable|
---
--- |since_notitg_v3|
---
--- @param percentLeft number The percentage of the actor that should be cropped from the left (0 - 1)
--- @param percentRight number The percentage of the actor that should be cropped from the right (0 - 1)
---
--- @return nil
function Actor:croph(percentLeft, percentRight) end

--- Crops the actor on the top and bottom
---
--- |tweenable|
---
--- |since_notitg_v3|
---
--- @param percentTop number The percentage of the actor that should be cropped from the top (0 - 1)
--- @param percentBottom number The percentage of the actor that should be cropped from the bottom (0 - 1)
---
--- @return nil
function Actor:cropv(percentTop, percentBottom) end

--- Crops the actor on all edges
---
--- |tweenable|
---
--- |since_notitg_v3|
---
--- @param percentLeft number The percentage of the actor that should be cropped from the left (0 - 1)
--- @param percentTop number The percentage of the actor that should be cropped from the top (0 - 1)
--- @param percentRight number The percentage of the actor that should be cropped from the right (0 - 1)
--- @param percentBottom number The percentage of the actor that should be cropped from the bottom (0 - 1)
---
--- @return nil
function Actor:crop(percentLeft, percentTop, percentRight, percentBottom) end

--- Returns the directory containing the XML file where the actor was defined
---
--- This can retrun an empty string if an actor was not defined in XML (Eg: by trying to call ``GetXMLDir()`` on ``SCREENMAN:GetTopScreen()``)
---
--- Eg: ``shader_earth:GetXMLDir()`` (Where ``shader_earth`` is an actor in a mod chart)
---
--- Returns ``/Songs/CraftedCart/Camellia_ExitThisEarthsAtomosphere/fg/``
---
--- |since_notitg_v3|
---
--- @return string
function Actor:GetXMLDir() end

--- Immediately executes a command/hook on the actor
---
--- |since_itg|
---
--- @param commandName string The command to execute, without the ``Command`` suffix
---
--- @return nil
function Actor:playcommand(commandName) end

--- Executes a command/hook on the actor when next possible
---
--- This is "tweenable" in the sense that the command will be executed after tweens complete. This is useful in
--- conjunction with the :lua:meth:`Actor.sleep` tween.
---
--- |tweenable|
---
--- |since_itg|
---
--- @param commandName string The command to execute, without the ``Command`` suffix
---
--- @return nil
function Actor:queuecommand(commandName) end -- tweenable

--- Adds a new command/hook to the actor
---
--- |since_itg|
---
--- @param commandName string The command name to register, without the ``Command`` suffix
--- @param func function The function to call when the command is fired
---
--- @return nil
function Actor:addcommand(commandName, func) end

--- Removed a command/hook from the actor
---
--- |since_notitg_v4|
---
--- @param commandName string The command to remove, without the ``Command`` suffix
---
--- @return nil
function Actor:removecommand(commandName) end

--- Returns whether an actor has registered a command/hook
---
--- |since_notitg_v4|
---
--- @param commandName string The command name to check, without the ``Command`` suffix
---
--- @return boolean
function Actor:hascommand(commandName) end

--- Queues a message command
---
--- Rarely used - you may want to consider :lua:meth:`MessageManager.Broadcast` instead.
---
--- |since_itg|
---
--- @param messageName string The message to broadcast
---
--- @return nil
function Actor:queuemessage(messageName) end

--- Sets the current frame of an animated texture
---
--- |since_itg|
---
--- @param state integer The frame to show (0 indexed)
---
--- @return nil
function Actor:setstate(state) end

--- Sets whether an animated texture should be played
---
--- |since_itg|
---
--- @param enable integer Whether the animated texture should play (``1`` to play, ``0`` to pause)
---
--- @return nil
function Actor:animate(enable) end

--- Sets the animation position
---
--- |since_itg|
---
--- @param position number The new position to set
---
--- @return nil
function Actor:position(position) end

--- Sets the actor's blend mode
---
--- Default value is ``normal``
---
--- |since_itg|
---
--- @param mode string The new blend mode to set (``normal``, ``add``, ``subtract``, ``modulate``, ``copysrc``, ``alphamask``, ``alphaknockout``, ``alphamultiply``, ``weightedmultiply``, ``invertdest``, ``noeffect``)
---
--- @return nil
function Actor:blend(mode) end

--- Sets the actor's blend mode to additive or normal
--
--- Default value is ``0`` (normal)
---
--- Also see :lua:meth:`Actor.blend`
---
--- |since_itg|
---
--- @param enable integer ``1`` to use additive blend, ``0`` to use normal blend
---
--- @return nil
function Actor:additiveblend(enable) end

--- Tests for equality against another userdata object
---
--- |since_unk|
---
--- @param other userdata The object to test for equality against
---
--- @return boolean
function Actor:__eq(other) end

--- Returns an ``Actor (MemoryAddress)`` string
---
--- |since_unk|
---
--- @return string
function Actor:__tostring() end

return Actor
