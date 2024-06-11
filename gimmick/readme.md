**This is the core of gimmick.** This folder stores nearly all functionality
of the theme, and you should aim to try and move as much as possible into here.
With the exception of the loader (`Scripts/00 gimmick.lua`), all Lua files
should go here, ideally.

## Handling functionality

The codebase has a few pre-defined places for code to go:

- Any modules _specific to_ theme substantial enough to be _present across the
whole theme_ should go in the root of this folder. For instance, this can be
save handling, mascots, constants defined for general use, and similar.
- Any _generic_ modules that could be reused across different codebases or
themes should go in `lib/`. This could be a module handling inputs, a library of
common drawing functions, or a vector class.
- Any _technically generic_ but not ready for use outside this codebase modules
should go in the root of this folder _for now_ until a better spot is worked
out.
- Anything that acts as an interface between the game and this codebase should
go in special folders allocated specifically for their kind:
  - Everything generic related to initialization and one-time operations on load
  should go in `init.lua`, or modules loaded by it.
    - Defining variables based on the environment goes in `constants.lua`.
    - If more substantial uses are necessary, more files should be created,
    but this depends on how commonly across the codebase it'll be used.
    - _Initialization related to modules should only ever go in those modules._
    Modules are only ever loaded once, so you're free to put whatever is
    necessary to make them work in the root scope of the module. For instance,
    `save.lua` calls `load()` in the global scope, loading the user's savedata.
  - Code handling screens, metrics of those screens and metrics of the elements
  in those screens should go in `screens/`.
