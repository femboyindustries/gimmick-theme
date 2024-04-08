-- overlay screens are funny in that after they're initialized, the lua state is
-- reset at some point, rendering all lua data of the actors completely useless.
-- so we resort to the mirin-esque strat of name lookups!

return {
  overlay = {
    init = function(self)
      self:removecommand('Init')

      local ctx = actorgen.Context.new()

      local bitmapText = ctx:BitmapText('_renogare 42px', '')
      bitmapText:xy(scx, scy)
      bitmapText:SetName('TextInput')

      actorgen.ready(ctx)
    end,
    initEnd = function(self)
      self:removecommand('Init')
      actorgen.finalize()
    end,
    load = function(self)
      print(actorToString(self))

      local t = ''
      local bitmapText = getRecursive(self, 'TextInput') --[[ @as BitmapText ]]

      event.on('keypress', function(device, key)
        if device == InputDevice.Key then
          print(t)
          t = t .. key
        end
      end)

      self:SetDrawFunction(function()
        bitmapText:settext(t)
        bitmapText:Draw()
      end)
    end
  },
  Inputs = {
    On = function(self)
      self:xy(scx, scy)
      self:luaeffect('Update')
      self:hidden(1)
    end,
    ResetButtons = function(self)
      local text = self:GetText()

      --[[
			  CString sTemp;
			  sTemp += di.toString();
        
        GameInput gi;
        if( INPUTMAPPER->DeviceToGame(di,gi) ) {
          CString sName = GAMESTATE->GetCurrentGame()->m_szButtonNames[gi.button];
          sTemp += ssprintf(" - Controller %d %s", gi.controller+1, sName.c_str() );

				  if( !PREFSMAN->m_bOnlyDedicatedMenuButtons ) {
            CString sSecondary = GAMEMAN->GetMenuButtonSecondaryFunction( GAMESTATE->GetCurrentGame(), gi.button );
            if( !sSecondary.empty() )
              sTemp += ssprintf(" - (%s secondary)", sSecondary.c_str() );
          }
        } else {
          sTemp += " - not mapped";
        }

        CString sComment = INPUTFILTER->GetButtonComment( di );
        if( sComment != "" )
          sTemp += " - " + sComment;
      ]]

      --[[
        CString s = InputDeviceToString(device) + "_" + DeviceButtonToString(device,button);
        // -> https://github.com/openitg/openitg/blob/master/src/RageInputDevice.cpp#L113
        // -> https://github.com/openitg/openitg/blob/master/src/RageInputDevice.cpp#L10
      ]]

      inputs.clear()

      --print(text)

      for line in string.gfind(text, '[^\n]+') do
        local parse, _, inputDevice, button, meta = string.find(line, '(%w+)_(.-) %- (.+)')
        if not parse then return end

        local mapParse, _, pn, keyName, keySecondary = string.find(meta, 'Controller (%d+) (.-) %- %((.-) secondary%)')
        if not mapParse then
          -- try without secondary
          mapParse, _, pn, keyName = string.find(meta, 'Controller (%d+) (.-)')
          if mapParse then
            local commentParse, _, newKeyName, comment = string.find(keyName, '(.-) %- (.-)')
            if commentParse then
              keyName = newKeyName
            end
          end
        end

        -- technically this does not cover button comments, but these seem only
        -- useful for pump it up panel sensors. oh well!
        -- it'll just ignore them

        inputs.input(InputDevice[inputDevice] or InputDevice.Unknown, button, tonumber(pn), keyName, keySecondary)
      end

      inputs.update()
    end,
  }
}