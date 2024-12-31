# gimmick

A minimal NotITG v4.3.0 theme focused on developer simplicity and modern
solutions.

Gimmick is meant to be partly a playground, and partly an example for other
developers aiming to make a theme with no idea where to begin.

## Why is it called "gimmick"?

Because I really don't know if any of what I'm doing is going to stick. The
stuff presented here is highly experimental and prone to breaking under
pressure!

## Compatibility

Gimmick will **only** run on **NotITG v4.3.0** or higher, due to many features
making it possible having been introduced in NotITG. v4.3.0 was chosen because
it was the latest version at the time of creation, but the minimum version may
be bumped in the future.

That being said, don't expect all features to work with an outdated NotITG
version; legacy version support only goes as far as to guarantee no crashes or
errors within the theme.

Full support for Wine and native Windows installations is guaranteed, though
there may be special features that are only possible on one or the other.

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
gimmick.ActorScreen('CoolScreen', function(self, ctx, scope)
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
shader:addcommand('Init', function(a)
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

### Scopes

Alongside contexts, you'll be passed along a `Scope` during initialization. A
scope is a generalization of everything specific to a screen. Inside it is:
- A `tick` instance, letting you use Mirin-like scheduling within the screen
  - `tick:func`, `tick:perframe` etc will behave similarly to their Mirin
  equivalents
  - `tick:aux()` will create the equivalent of a `definemod`
  - `tick:easable()` will create an `easable` instance that is updated and
  cleant up automatically
- An `event` instance, letting you register event handlers
  - Any events called globally will be passed along; see:
  [Global events](#global-events)
  - Any events _called_ will only propogate within the screen
  - Additionally, you have access to `on` and `off` events, called when the
  screen's OnCommand and OffCommand are triggered

### Global events

Global events can be listened to and created with the `event` global listener,
or listened to with any `event` instances in a [scope](#scopes) (preferable to
use when possible).

#### `keypress(device: InputDevice, key: string)`

A raw keypress. `device` corresponds to an `InputDevice`. For instance to detect
keyboard presses, do:

```lua
event:on('keypress', function(device, key)
  if device == InputDevice.Key then
    -- ...
  end
end)
```

For keyboards, reference [RageKeySymToString](https://github.com/openitg/openitg/blob/master/src/RageInputDevice.cpp#L10)
for possible values of `key`. You can likely find the other possible values of
`key` for other device types within the same file.

#### `keyrelease(device: InputDevice, key: string)`

Same as `keypress`, except triggered when the key is no longer held.

#### `press(pn: number, button: string)`

A processed button press, corresponding to the actions you can bind in the game.
See [m_szButtonNames](https://github.com/openitg/openitg/blob/master/src/GameManager.cpp#L110)
for possible values.

#### `release(pn: number, button: string)`

Same as `release`, except triggered when the key is no longer held.

#### `resize(dw: number, dh: number)`

Triggered whenever the window resizes. Uses the **display resolution** instead
of the usual screen resolution. Common usecase is to recreate AFTs with fresh
sizes.

#### `warn(msg: string)`

A warning; not necessarily a user-facing one. Calls to the `warn` global will
send this event. Currently only displayed in the console, but could potentially
be shown to the user later on.

### Notable functions

- `print(...)` works the same way as in regular Lua, except that every value is
passed through `pretty`. It also calls `Debug` with the results, which means
it'll show up in stdout without `ShowLogOutput=1`; useful for decluttering the
NotITG logs during debugging.
  - On Wine, this will use ANSI escape codes to color the output.
- `warn(msg: string)` displays a message in the console.
- `pretty(a: any, config: PrettyConfig)` is our in-house Lua pretty-printer.
Also handles actors.
- `actorToString(a: Actor, hideChildren: boolean?)` tries to give a fairly'
accurate XML representation of an actor tree.
- `introduceEntropyIntoUniverse()` introduces entropy into the universe. Feel
free to call this at any point if you wish for that to happen.

Make sure to look through [util.lua](gimmick/lib/util.lua) for the rest; there's
plenty of handy things to be found there.

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