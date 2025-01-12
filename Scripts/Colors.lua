--
-- This is a file borrowed from the fallback theme.
-- Ideally, we'd make sure none of the functions in this are used in the theme
-- or in the game, then entirely remove the contents of the files, replacing
-- them with an empty script such that the fallback scripts aren't loaded.
-- There's a slight chance this might break a modfile or two, but we'll consider
-- this a quirk, as modfiles shouldn't be relying on theme internal functions
-- that just happen to be out in the open.
--
-- For functions that are required here, like those used by the game, ideally
-- we'd reimplement them from scratch, such that this isn't a mixed license
-- repo.
--

function PlayerColor( pn )
	if pn == PLAYER_1 then return "0.4,1.0,0.8,1" end	-- sea green
	if pn == PLAYER_2 then return "1.0,0.5,0.2,1" end	-- orange
	return "1,1,1,1"
end

function DifficultyColor( dc )
	if dc == DIFFICULTY_BEGINNER	then return "0.0,0.9,1.0,1" end	-- light blue
	if dc == DIFFICULTY_EASY		then return "0.9,0.9,0.0,1" end	-- yellow
	if dc == DIFFICULTY_MEDIUM		then return "1.0,0.1,0.1,1" end	-- light red
	if dc == DIFFICULTY_HARD		then return "0.2,1.0,0.2,1" end	-- light green
	if dc == DIFFICULTY_CHALLENGE	then return "0.2,0.6,1.0,1" end	-- blue
	if dc == DIFFICULTY_EDIT		then return "0.8,0.8,0.8,1" end	-- gray
	return "1,1,1,1"
end


-- (c) 2005 Chris Danford
-- All rights reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, and/or sell copies of the Software, and to permit persons to
-- whom the Software is furnished to do so, provided that the above
-- copyright notice(s) and this permission notice appear in all copies of
-- the Software and that both the above copyright notice(s) and this
-- permission notice appear in supporting documentation.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
-- THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
-- INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
-- OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
-- OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.

