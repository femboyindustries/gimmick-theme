local function init(self)
  ---@type ActorFrame
  local screen = self('EditMenu')

  for i = 1,2 do
    local arrow = screen:GetChildAt(i - 1)
    arrow:x(SCREEN_CENTER_X + (i == 1 and -150 or 150))
  end

  for _,v in ipairs {'Song', 'Group'} do
    local child = screen(v .. 'Banner')
    -- fuck your FadingBanner
    child:hidden(1)
  end
  
  local stb = screen('SongTextBanner')
  --screen('SongBanner'):y(scy - 90)
  --screen('GroupBanner'):y(scy - 140)
  stb:y(scy - 110)
  -- todo: fix
  for _,v in ipairs(stb.__index) do
    stb:shadowlength(1)
  end

  for k,v in ipairs {'', 'Source'} do
    local child = screen(v .. 'Meter')
    child:xy(scx + 170, scy - 10 + (60*(k-1)))
  end
end

return {
  Init = function(self)
    self:addcommand('Ready', function() init(self) end)
    self:queuecommand('Ready')
  end,
  overlay = gimmick.ActorScreen(function(self, ctx)
    --[[proxyBanner = {}
    for _,v in ipairs {'Song', 'Group'} do
      proxyBanner[v] = ctx:Sprite(nil)
    end
    local groupName = '']]

    proxyBanner = ctx:Sprite(nil)
    local songName = ''
    self:SetDrawFunction(function()
      -- SONGMAN:FindSong(songName) is absurdly cursed
      -- Sometimes it cannot find songs that have a folder name of 'Song [Author]' or something unless songName matches exactly that
      -- Sometimes it can find songs that have 'Song [Author]' even if songName is just 'Song'
      -- Sometimes it can find songs that have 'Song [Author]' and 'Song [SomeoneElse]' even if songName is just 'Song' and selects a random one.
      -- Sometimes it straight up doesn't find a song even if it clearly exists.

      -- genuinely fuck this, I hope there is a way to just forcibly run and cancel a MenuAction every time the song switches
      -- or hope for a way to extract or deal with FadingBanner AT ALL -rya

      -- code below is held for nuclear destruction

      --[[if groupName ~= self:GetParent():GetChild('EditMenu'):GetChildAt(3):GetText() then
        groupName = self:GetParent():GetChild('EditMenu'):GetChildAt(3):GetText()
        proxyBanner['Group']:Load(GAMESTATE:GetCurrentSong():GetBannerPath())
        -- GAMESTATE:GetFileStructure() ?
        -- Song:GetGroupName() ??
      end]]
      local newSongName = self:GetParent():GetChild('EditMenu'):GetChild('SongTextBanner'):GetChild('Title'):GetText()
      if songName ~= newSongName then
        songName = newSongName
        local song = SONGMAN:FindSong(songName)
        print(self:GetParent():GetChild('EditMenu'):GetChildAt(3):GetText() .. '/' .. songName)
        local success = pcall(proxyBanner.Load, proxyBanner, song and song:GetBannerPath() or nil)
        if not success then proxyBanner:hidden(1) else proxyBanner:hidden(0) end
      end

      proxyBanner:xy(scx, scy)
      proxyBanner:SetWidth(418)
      proxyBanner:SetHeight(164)
      proxyBanner:Draw()
    end)
  end),
  underlay = gimmick.common.background(function(ctx) return function() end end),
  Description = function(self)
    self:x(scx)
  end,
  Label = function(self)
    self:x(50) -- SCREEN_LEFT is 0. lmao
  end,
}