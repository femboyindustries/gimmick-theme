This place stores screen Lua files, named by their Stepmania screen names **and
only that**. No alterations should be made to the screen name, as this is
primarily a lower-level interface to the game.

Screens are automatically imported by `init.lua`, and a fallback screen that
does nothing is used incase a screen is not found. These are pointed to by XMLs
located in `Graphics/` and `BGAnimations/`. _You can generate these XMLs and
Lua files with the `man` utility located at the root of this repo._

Note that there's not a reason for an imported screen to be a file rather than
a folder; see `OverlayScreen` for an example of when a screen is split into
mulitple files that act as different parts of that screen.

Screens are simply tables. The tables' key names are only standard by the screen
they're in or elements the screen contains; eg. `ScreenWithMenuElements` uses
the keys `underlay`, `overlay`, `header`, etc. and has its own conventions on
what does are and do, `ChoiceNames` and choices are provided by the key
`choices`. If a screen table does not define a key, the fallback screen's
definition of that key is used instead.

The "common" folder stores common theme elements used across different screens;
the location of this folder is currently a WIP until the screens system is
refined into something more generic and abstracted.

Common screen parents or elements are not currently documented, but you can
(hopefully) roughly figure out how they're used by usage in other files.