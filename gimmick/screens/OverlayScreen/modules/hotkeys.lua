return function(ctx, scope)
  scope.event:on('keypress', function(device, key)
    if device == InputDevice.Key and key == 'F5' then
      if inputs.rawInputs[device]['left ctrl'] or inputs.rawInputs[device]['left right'] then
        print('Ctrl+F5 pressed; Clearing everything and reloading')

        local search = gimmick.package.search

        _G.gimmick = nil
        _G.paw = nil

        setfenv(2, _G)

        local filename = 'Scripts/00 gimmick.lua'
        for prefix in string.gfind(search, '[^;]+') do
          -- get the file path
          local filepath = prefix .. filename
          -- check if file exists
          if GAMESTATE:GetFileStructure(filepath) then
            local res, err = pcall(dofile, filepath)
            if not res then
              Debug(err)
            end
          end
        end

        GAMESTATE:ApplyGameCommand('stopmusic')
        SCREENMAN:SetNewScreen(SCREENMAN:GetTopScreen():GetName())
        SCREENMAN:SystemMessageNoAnimate('Ctrl+F5 pressed; Theme reloaded')
      else
        print('F5 pressed; Reloading screens')

        for _, v in ipairs(SCREENMAN:GetTopScreen():GetChildren()) do
          v:playcommand('Off')
        end

        for k in pairs(gimmick.s) do
          rawset(gimmick.s, k, nil)
        end
        for k in pairs(gimmick.package.loaded) do
          if startsWith(k, 'gimmick.screens.') then
            gimmick.package.loaded[k] = nil
          end
        end

        GAMESTATE:ApplyGameCommand('stopmusic')
        SCREENMAN:SetNewScreen(SCREENMAN:GetTopScreen():GetName())
        SCREENMAN:SystemMessageNoAnimate('F5 pressed; Screens reloaded')
      end
    end
  end)

  return {}
end