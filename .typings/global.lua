---@meta
---@diagnostic disable

--- The :lua:class:`RageFileManager` singleton
---
--- |since_notitg_v3|
---
--- @export
--- @type RageFileManager
FILEMAN = {}

--- The :lua:class:`GameState` singleton
---
--- |since_itg|
---
--- @export
--- @type GameState
GAMESTATE = {}

--- The :lua:class:`GameSoundManager` singleton
---
--- |since_itg|
---
--- @export
--- @type GameSoundManager
SOUND = {}

--- The :lua:class:`MemoryCardManager` singleton
---
--- Doesn't seem to exist when testing in |notitg_v4|?
---
--- |since_itg|
---
--- @export
--- @type MemoryCardManager
MEMCARDMAN = {}

--- The :lua:class:`MessageManager` singleton
---
--- |since_itg|
---
--- @export
--- @type MessageManager
MESSAGEMAN = {}

--- The :lua:class:`NoteSkinManager` singleton
---
--- |since_itg|
---
--- @export
--- @type NoteSkinManager
NOTESKIN = {}

--- The :lua:class:`PrefsManager` singleton
---
--- |since_itg|
---
--- @export
--- @type PrefsManager
PREFSMAN = {}

--- The :lua:class:`ProfileManager` singleton
---
--- |since_itg|
---
--- @export
--- @type ProfileManager
PROFILEMAN = {}

--- The :lua:class:`RageDisplay` singleton
---
--- |since_notitg_v1|
---
--- @export
--- @type RageDisplay
DISPLAY = {}

--- The :lua:class:`RageInput` singleton
---
--- |since_itg|
---
--- @export
--- @type RageInput
INPUTMAN = {}

--- The :lua:class:`ScreenManager` singleton
---
--- |since_itg|
---
--- @export
--- @type ScreenManager
SCREENMAN = {}

--- The :lua:class:`SongManager` singleton
---
--- |since_itg|
---
--- @export
--- @type SongManager
SONGMAN = {}

--- The :lua:class:`StatsManager` singleton
---
--- |since_itg|
---
--- @export
--- @type StatsManager
STATSMAN = {}

--- The :lua:class:`ThemeManager` singleton
---
--- |since_itg|
---
--- @export
--- @type ThemeManager
THEME = {}

--- The :lua:class:`UnlockManager` singleton
---
--- |since_itg|
---
--- @export
--- @type UnlockManager
UNLOCKMAN = {}

--- The window width, scaled
---
--- This is set by the theme - typically ``640`` with a 4:3 aspect ratio
---
--- If you want the width of the game window, see :lua:meth:`RageDisplay.GetWindowWidth`.
---
--- |since_itg|
---
--- @export
--- @type number
SCREEN_WIDTH = 0

--- The window height, scaled
---
--- This is set by the theme - typically ``480``
---
--- If you want the height of the game window, see :lua:meth:`RageDisplay.GetWindowHeight`.
---
--- |since_itg|
---
--- @export
--- @type number
SCREEN_HEIGHT = 0

--- The leftmost coordinate of the window - always zero
---
--- |since_itg|
---
--- @export
--- @constant
--- @type number
SCREEN_LEFT = 0

--- The rightmost coordinate of the window - equal to :lua:attr:`SCREEN_WIDTH`
---
--- |since_itg|
---
--- @export
--- @type number
SCREEN_RIGHT = 0

--- The topmost coordinate of the window - always zero
---
--- |since_itg|
---
--- @export
--- @constant
--- @type number
SCREEN_TOP = 0

--- The bottommost coordinate of the window - equal to :lua:attr:`SCREEN_HEIGHT`
---
--- |since_itg|
---
--- @export
--- @type number
SCREEN_BOTTOM = 0

--- The middle X coordinate of the window
---
--- Equal to ``SCREEN_WIDTH / 2``
---
--- |since_itg|
---
--- @export
--- @type number
SCREEN_CENTER_X = 0

--- The middle Y coordinate of the window
---
--- Equal to ``SCREEN_HEIGHT / 2``
---
--- |since_itg|
---
--- @export
--- @type number
SCREEN_CENTER_Y = 0

--- The monitor width
---
--- |since_itg|
---
--- @export
--- @type number
DISPLAY_WIDTH = 0

--- The monitor height
---
--- |since_itg|
---
--- @export
--- @type number
DISPLAY_HEIGHT = 0

--- The leftmost coordinate of the monitor - always zero
---
--- |since_itg|
---
--- @export
--- @constant
--- @type number
DISPLAY_LEFT = 0

--- The rightmost coordinate of the monitor - equal to :lua:attr:`DISPLAY_WIDTH`
---
--- |since_itg|
---
--- @export
--- @type number
DISPLAY_RIGHT = 0

--- The topmost coordinate of the monitor - always zero
---
--- |since_itg|
---
--- @export
--- @constant
--- @type number
DISPLAY_TOP = 0

--- The bottommost coordinate of the monitor - equal to :lua:attr:`DISPLAY_HEIGHT`
---
--- |since_itg|
---
--- @export
--- @type number
DISPLAY_BOTTOM = 0

--- The middle X coordinate of the monitor
---
--- Equal to ``DISPLAY_WIDTH / 2``
---
--- |since_itg|
---
--- @export
--- @type number
DISPLAY_CENTER_X = 0

--- The middle Y coordinate of the monitor
---
--- Equal to ``DISPLAY_HEIGHT / 2``
---
--- |since_itg|
---
--- @export
--- @type number
DISPLAY_CENTER_Y = 0

--- Equal to ``0``
---
--- |since_itg|
---
--- @export
--- @type integer
PLAYER_1 = 0

--- Equal to ``1``
---
--- |since_itg|
---
--- @export
--- @type integer
PLAYER_2 = 1

--- Equal to ``2``
---
--- |since_itg|
---
--- @export
--- @type integer
NUM_PLAYERS = 2

--- Equal to ``true``
---
--- |since_itg|
---
--- @export
--- @type boolean
OPENITG = true

--- The current OpenITG version
---
--- |since_itg|
---
--- @export
--- @type integer
OPENITG_VERSION = 0

--- Equal to ``true``
---
--- |since_notitg_v1|
---
--- @export
--- @type boolean
FUCK_EXE = true

--- Equal to ``true``
---
--- |since_notitg_v4_9|
---
--- @export
--- @type boolean
NOTITG = true

--- Equal to ``20161226`` (The release date of |notitg_v1|)
---
--- |since_notitg_v3| (yes really)
---
--- @export
--- @type integer
FUCK_VERSION_1 = 20161226

--- Equal to ``20161226`` (The release date of |notitg_v1|)
---
--- |since_notitg_v4_9| (yes really)
---
--- @export
--- @type integer
NOTITG_VERSION_1 = 20161226

--- Equal to ``20170405`` (The release date of |notitg_v2|)
---
--- |since_notitg_v3| (yes really)
---
--- @export
--- @type integer
FUCK_VERSION_2 = 20170405

--- Equal to ``20170405`` (The release date of |notitg_v2|)
---
--- |since_notitg_v4_9| (yes really)
---
--- @export
--- @type integer
NOTITG_VERSION_2 = 20170405

--- Equal to ``20180609`` (The release date of |notitg_v3|)
---
--- |since_notitg_v4| (yes really)
---
--- @export
--- @type integer
FUCK_VERSION_3 = 20180609

--- Equal to ``20180609`` (The release date of |notitg_v3|)
---
--- |since_notitg_v4_9| (yes really)
---
--- @export
--- @type integer
NOTITG_VERSION_3 = 20180609

--- Equal to ``20180826`` (The release date of |notitg_v3_1|)
---
--- |since_notitg_v4| (yes really)
---
--- @export
--- @type integer
FUCK_VERSION_3_1 = 20180826

--- Equal to ``20180826`` (The release date of |notitg_v3_1|)
---
--- |since_notitg_v4_9| (yes really)
---
--- @export
--- @type integer
NOTITG_VERSION_3_1 = 20180826

--- Equal to ``20240917`` (The release date of |notitg_v4_9|)
---
--- |since_notitg_v4_9|
---
--- @export
--- @type integer
FUCK_VERSION_4_9 = 20240917

--- Equal to ``20240917`` (The release date of |notitg_v4_9|)
---
--- |since_notitg_v4_9|
---
--- @export
--- @type integer
NOTITG_VERSION_4_9 = 20240917

--- Equal to ``20241010`` (The release date of |notitg_v4_9_1|)
---
--- |since_notitg_v4_9_1|
---
--- @export
--- @type integer
FUCK_VERSION_4_9_1 = 20241010

--- Equal to ``20241010`` (The release date of |notitg_v4_9_1|)
---
--- |since_notitg_v4_9_1|
---
--- @export
--- @type integer
NOTITG_VERSION_4_9_1 = 20241010

--- Returns whether all active players failed the current stage
---
--- |since_itg|
---
--- @return boolean
function AllFailed() end

--- Attempts to connect to a server
---
--- Returns a boolean depending on whether connection succeeded or not... apparently... even though trying to connect to
--- a non-existent server returns ``true`` before a system message appears saying connection failed.
---
--- |since_itg|
---
--- @return boolean
function ConnectToServer() end

--- Returns whether the game is connected to a server or not
---
--- |since_itg|
---
--- @return boolean
function IsNetConnected() end

--- Returns whether the game is connected to StepMania Online or not
---
--- |since_itg|
---
--- @return boolean
function IsNetSMOnline() end

--- Returns whether the specified player is logged in to StepMania Online
---
--- |since_itg|
---
--- @param player integer The player number (0 indexed)
---
--- @return boolean
function IsSMOnlineLoggedIn(player) end

--- Sends the current style to the StepMania Online server
---
--- |since_itg|
---
--- @return boolean
function ReportStyle() end

--- Converts a difficulty to a human-readable string
---
--- |since_itg|
---
--- @param difficulty integer The difficulty - see :cpp:enum:`Difficulty`
---
--- @return string
function DifficultyToThemedString(difficulty) end

--- Converts a course difficulty to a human-readable string
---
--- |since_itg|
---
--- @param courseDifficulty integer The course difficulty - see :cpp:enum:`CourseDifficulty`
---
--- @return string
function CourseDifficultyToThemedString(courseDifficulty) end

--- Returns the index of the current song in the course (0 indexed)
---
--- |since_itg|
---
--- @return integer
function CourseSongIndex() end

--- Returns the name of the current style
---
--- Eg: ``versus``
---
--- |since_itg|
---
--- @return string
function CurStyleName() end

--- Returns the current day of the month (1 indexed)
---
--- |since_itg|
---
--- @return integer
function DayOfMonth() end

--- Returns the current month of the year (1 indexed)
---
--- |since_itg|
---
--- @return integer
function MonthOfYear() end

--- Returns the current day of the year (0 indexed)
---
--- |since_itg|
---
--- @return integer
function DayOfYear() end

--- Returns the current weekday (0 - 6)
---
--- This assumes the week starts on a Sunday
---
--- |since_itg|
---
--- @return integer
function Weekday() end

--- Returns the current year
---
--- |since_itg|
---
--- @return integer
function Year() end

--- Returns the current hour
---
--- |since_itg|
---
--- @return integer
function Hour() end

--- Returns the current minute
---
--- |since_itg|
---
--- @return integer
function Minute() end

--- Returns the current second
---
--- |since_itg|
---
--- @return integer
function Second() end

--- Converts a month number to a human-readable string
---
--- Returns an empty string for an invalid month
---
--- Eg: ``1`` -> ``January``
---
--- |since_itg|
---
--- @return string
function MonthToString() end

--- Returns a human-readable string in the format ``MM:SS`` for a given number of seconds
---
--- |since_itg|
---
--- @param seconds integer The number of seconds
---
--- @return string
function SecondsToMMSS(seconds) end

--- Returns a human-readable string in the format ``MM:SS.MsMs`` for a given number of seconds
---
--- |since_itg|
---
--- @param seconds number The number of seconds
---
--- @return string
function SecondsToMMSSMsMs(seconds) end

--- Returns a human-readable string in the format ``MM:SS.MsMsMs`` for a given number of seconds
---
--- |since_itg|
---
--- @param seconds number The number of seconds
---
--- @return string
function SecondsToMMSSMsMsMs(seconds) end

--- Returns a human-readable string in the format ``M:SS.MsMs`` for a given number of seconds
---
--- |since_itg|
---
--- @param seconds number The number of seconds
---
--- @return string
function SecondsToMSSMsMs(seconds) end

--- Logs a message
---
--- Like :lua:func:`Trace`, but shows even if the ``ShowLogOutput`` preference is disabled
---
--- Also returns ``true`` for whatever reason
---
--- |since_itg|
---
--- @param message string The message to log
---
--- @return boolean
function Debug(message) end

--- Logs a message to the console log
---
--- Also returns ``true`` for whatever reason
---
--- |since_itg|
---
--- @param message string The message to log
---
--- @return boolean
function Trace(message) end

--- Formats a dance points score into a human-readable percentage score string
---
--- |since_itg|
---
--- @param score number The dance points score
---
--- @return string
function FormatPercentScore(score) end

--- Returns the best final grade
---
--- |since_itg|
---
--- See :cpp:enum:`Grade`
---
--- @return integer
function GetBestFinalGrade() end

--- Returns the amount of free space available on the partition the game is installed on
---
--- Eg: ``12.51 GB``
---
--- |since_itg|
---
--- @return string
function GetDiskSpaceFree() end

--- Returns the capacity of the partition the game is installed on
---
--- Eg: ``786.44 GB``
---
--- |since_itg|
---
--- @return string
function GetDiskSpaceTotal() end

--- Returns the easiest difficulty chosen from the current song
---
--- See :cpp:enum:`Difficulty`
---
--- |since_itg|
---
--- @return integer
function GetEasiestNotesDifficulty() end

--- Returns the grade for a given percentage score
---
--- See :cpp:enum:`Grade`
---
--- |since_itg|
---
--- @param percent number The percentage score
---
--- @return integer
function GetGradeFromPercent(percent) end

--- Returns the internal IP and netmask of the machine
---
--- Eg: ``192.168.1.10, Netmask: 255.255.255.0`` - as tested on |notitg_v4_0_1| though, this function seems to return ``Not implemented``.
---
--- |since_itg|
---
--- @return string
function GetIP() end

--- Returns the input type
---
--- |since_itg|
---
--- @return string
function GetInputType() end

--- Returns the number of crash logs stored
---
--- |since_itg|
---
--- @return integer
function GetNumCrashLogs() end

--- Returns the number drive IO errors
---
--- |since_itg|
---
--- @return integer
function GetNumIOErrors() end

--- Returns the number of edits registered in the machine
---
--- |since_itg|
---
--- @return integer
function GetNumMachineEdits() end

--- Returns the number of scored saved on the machine
---
--- |since_itg|
---
--- @return integer
function GetNumMachineScores() end

--- Returns the number of players enabled
---
--- This is an alias for :lua:meth:`GameState.GetNumPlayersEnabled`
---
--- |since_itg|
---
--- @return integer
function GetNumPlayersEnabled() end

--- Returns the name (and version if applicable) of the executable
---
--- Eg: ``NotITG v4.0.1``
---
--- |since_itg|
---
--- @return string
function GetProductName() end

--- Returns the version of the executable
---
--- Eg: ``v4.0.1``
---
--- |since_itg|
---
--- @return string
function GetProductVer() end

--- Returns the revision number of the executable
---
--- |since_itg|
---
--- @return integer
function GetRevision() end

--- Returns the serial number of the installation
---
--- |since_itg|
---
--- @return string
function GetSerialNumber() end

--- Returns the text of the current stage
---
--- Eg: ``event``
---
--- |since_itg|
---
--- @return string
function GetStageText() end

--- Returns the length the game has been running for
---
--- Returns a ``HH:MM:SS`` string
---
--- |since_itg|
---
--- @return string
function GetUptime() end

--- Returns a grade's name 
---
--- See :cpp:enum:`Grade`
---
--- Eg: ``A`` -> ``3``, ``Tier04`` -> ``3``
---
--- |since_itg|
---
--- @param name string The grade name
---
--- @return integer
function Grade(name) end

--- Returns a grade name from a grade
---
--- See :cpp:enum:`Grade`
---
--- Unfortunately, it's not a very useful string. For example, ``GradeToString(GRADE_TIER03)`` returns... ``Tier03``.
---
--- |since_itg|
---
--- @param grade integer The grade
---
--- @return string
function GradeToString(grade) end

--- Returns whether the ITG hub is connected
---
--- |since_itg|
---
--- @return boolean
function HubIsConnected() end

--- Returns whether a given player has a memory card connected
---
--- |since_itg|
---
--- @param player integer The player number (0 indexed)
---
--- @return boolean
function IsUsingMemoryCard(player) end

--- Returns whether any player has a memory card connected
---
--- |since_itg|
---
--- @return boolean
function IsAnyPlayerUsingMemoryCard() end

--- Returns the number of stages remaining
---
--- Returns ``999`` if event mode is enabled
---
--- |since_itg|
---
--- @return integer
function NumStagesLeft() end

--- Returns whether the current stage is the extra stage
---
--- |since_itg|
---
--- @return boolean
function IsExtraStage() end

--- Returns whether the current stage is the second extra stage
---
--- |since_itg|
---
--- @return boolean
function IsExtraStage2() end

--- Returns whether the current stage is the final stage
---
--- |since_itg|
---
--- @return boolean
function IsFinalStage() end

--- Returns whether at least one player passed the current song
---
--- |since_itg|
---
--- @return boolean
function OnePassed() end

--- Returns the name of the current play mode
---
--- Eg: ``Regular``
---
--- |since_itg|
---
--- @return string
function PlayModeName() end