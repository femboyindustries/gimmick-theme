# gimmick

A minimal NotITG v4.3.0 theme focused on developer simplicity and modern
solutions.

Gimmick is meant to be partly a playground, and partly an example for other
developers aiming to make a theme with no idea where to begin.

## Why is it called "gimmick"?

Because I really don't know if any of what I'm doing is going to stick. The
stuff presented here is highly experimental and prone to breaking under
pressure!

## Developer documentation

Working with gimmick can be a doozy because of how far away it is from typical
theming or even typical Stepmania code. This is why this section exists: to note
specific quirks you may encounter.

### Actors

For actor initialization, gimmick uses [actor235](https://github.com/femboyindustries/gimmick-theme/blob/main/gimmick/lib/actor235.lua),
a work-in-progress (mostly complete) port of [Uranium Template](https://git.oat.zone/oat/uranium-template)'s
actor system. For the most part, you can refer to [its documentation](https://git.oat.zone/oat/uranium-template/src/branch/main/MANUAL.md#user-content-defining-actors),
but it won't always align since actor235 has been greatly modified and rewritten
to fit working within a theme.

This section will note the differences between actor235 and Uranium Template's
actor initialization, aswell as quirks to look out for that are relevant within
gimmick.

#### Contexts

actor235 introduces the concept of **contexts**. A context, abstractly speaking,
is some context in which actors can be initialized. _Actors cannot be
initialized outside of a context_, as there's no way for you to load an actor
during runtime, so you will need a `Context` in order to initialize actors.

In gimmick, `Context`s are created during screen initialization, and are only
usable in said screen initialization. Usually this means that you'll be given
a `Context` whenever you define a screen:

```lua
gimmick.ActorScreen(function(self, ctx)
  -- `ctx` here is your Context
  local quad = ctx:Quad()  
end)
```

You can only define actors through a `Context`:

```lua
local quad = ctx:Quad()
local sprite = ctx:Sprite(...)
local shader = ctx:Shader(...)
-- and so on, and so forth
```

ActorFrame associations are also always handled through a `Context`:

```lua
local frame = ctx:ActorFrame()
local child = ctx:Quad()
ctx:addChild(frame, child)
```

**Do not** try and store the `Context`, as after the function you're given it in
passes and initialization completes, it is _locked_ and accessing it will error.

```lua
-- DON'T DO THIS
local quad = ctx:Quad()
quad:addcommand('Init', function()
  local otherQuad = ctx:Quad()
end)
```
```lua
-- NO NO
local storedContext

return function(ctx)
  storedContext = ctx
end
```

#### Working with proxied actors

Unlike Uranium Template, actor235 does not expose any functions to work with
actors to account for their proxied nature (such as `setShader` and similar).
Instead, you are (for the time being) entrusted with taking care of proxied
actors yourself.

To access the raw actor of a proxied actor, import `actor235` and use the
`Proxy` module:

```lua
local actor235 = require 'gimmick.lib.actor235'

local shader = ctx:Shader('Shaders/penis.frag')

actor235.Proxy.getRaw(shader) --> RageShaderProgram or nil
-- nil is returned when it is not yet initialized

-- You could use this, for instance, like this:
sprite:SetShader(actor235.Proxy.getRaw(shader))

-- However, keep in mind InitCommands will also return the raw actor for a
-- simpler way to achieve the same:
shader:addcommad('Init', function(a)
  sprite:SetShader(a)
end)
-- !! BE WARY OF LOAD ORDER !!, because `shader`'s InitCommand here could be ran
-- before `sprite`'s, depending on the order in which they're defined.
```

#### Other notes

ActorFrame transforms only apply to children when the children are drawn within
the ActorFrame's drawfunction. Drawing the ActorFrame's children outside of
its drawfunction, or drawing other ActorFrames' children in another drawfunction
should be considered undefined behavior to avoid discovering weird issues down
the line.

```lua
local quad = ctx:Quad()
quad:xywh(0, 0, 32, 32)

local frame = ctx:ActorFrame()
frame:xy(100, 100)
ctx:addChild(frame, quad)

local parentlessQuad = ctx:Quad()
parentlessQuad:xywh(0, 0, 32, 32)

self:SetDrawFunction(function()
  -- **Undefined behavior**, but should render at x0 y0
  quad:Draw()
  -- OK, renders at x0 y0
  parentlessQuad:Draw()
end)

frame:SetDrawFunction(function()
  -- OK, renders at x100 y100
  quad:Draw()
  -- **Undefined behavior**, but should render at x100 y100
  parentlessQuad:Draw()
end)
```

### File structure

Folders will sometimes have `readme.md` files in them documenting how they're
meant to be used. Be sure to read those for full details on where things should
go.

- Code should always go in `gimmick/`. `Scripts/` should be treated as
exclusively an interface to the game, and as such code written there should
ideally just refer to code in `gimmick/` whenever possible for the highest
degree of control.
- Graphics should go in `Graphics/`, _usually_. Whenever assets have special
structure, such as being costumizable by the user, consider putting them in
a new folder at the root.
- Shaders should go in `Shaders/`. This is a made-up folder that's unusued by
the actual game, but should be where you store shaders.
- XML files required for the game go in `BGAnimations/` and `Graphics/`. _Use
the `man` utility at the root of this repository to automatically generate
them._
- `Sounds/` and `Fonts/` should be used as they would be in a regular theme.
- `Mascots/` is a more user-facing folder, storing mascot data and assets.

Folders at the root should be minimized. Folders that are at the root at the
folder not required by Stepmania's theme structure (and aren't `gimmick` or
relate to repository structure) are currently considered to be moved to a better
spot later on.

Be sure to try and deduplicate files whenever possible with `.redir`s.

### Mayflower wrote these and I want to turn them into proper docs later

POSSIBLE BUTTONS event.on CAN SEND:
https://github.com/openitg/openitg/blob/master/src/GameManager.cpp#L110

clippy says my balls itch 1/1000 chance