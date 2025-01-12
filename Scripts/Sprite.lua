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

function Sprite:LoadFromSongBanner(song)
	local Path = song:GetBannerPath()
	if not Path then
		Path = THEME:GetPath(ELEMENT_CATEGORY_GRAPHICS,"Common","fallback banner")
	end

	self:LoadBanner( Path )
end

function Sprite:LoadFromSongBackground(song)
	local Path = song:GetBackgroundPath()
	if not Path then
		Path = THEME:GetPath(ELEMENT_CATEGORY_GRAPHICS,"Common","fallback background")
	end

	self:LoadBackground( Path )
end



-- (c) 2005 Glenn Maynard
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
