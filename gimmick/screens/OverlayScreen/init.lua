-- overlay screens are funny in that after they're initialized, the lua state is
-- reset at some point, rendering all lua data of the actors completely useless.
-- luckily i found a way to force evaluate actor235 a second time, but
-- pretend-running through to get all the actors from the already-generated
-- actorframe. yippee!

local consoleModule = require 'gimmick.screens.OverlayScreen.console'
local saveModule = require 'gimmick.screens.OverlayScreen.save'
local imapModule = require 'gimmick.screens.OverlayScreen.imap'

-- !!!!: actors built by `init` MUST remain deterministic.
-- in other words, make sure the actors initialized never change conditionally

---@param self ActorFrame
---@param ctx Context
local function init(self, ctx)
  local drawConsole = consoleModule.init(self, ctx)
  local drawSave = saveModule.init(self, ctx)
  local drawImap = imapModule.init(self, ctx)

  local lastdw, lastdh = dw, dh

  self:SetUpdateFunction(function()
    if save.data.settings.prevent_stretching then
      local aspectRatio = PREFSMAN:GetPreference('DisplayAspectRatio')
      local screenWidth = sh * aspectRatio
      local actualScreenWidth = sh * (dw / dh)

      _G.SCREEN_WIDTH = screenWidth
      _G.SCREEN_CENTER_X = screenWidth / 2
      _G.SCREEN_RIGHT = screenWidth
      sw = screenWidth
      scx = sw / 2
      SCREEN_WIDTH = screenWidth
      SCREEN_CENTER_X = screenWidth / 2
      SCREEN_RIGHT = screenWidth

      local topScreen = SCREENMAN:GetTopScreen()
      if topScreen then
        topScreen:basezoomx(screenWidth / actualScreenWidth)
      end
    end

    dw, dh = DISPLAY:GetWindowWidth(), DISPLAY:GetWindowHeight()

    if lastdw ~= dw or lastdh ~= dh then
      event.call('resize', dw, dh)
      lastdw, lastdh = dw, dh
    end
  end)

  setDrawFunctionWithDT(self, function(dt)
    drawConsole(dt)
    drawSave(dt)
    drawImap(dt)
  end)
end

return {
  overlay = {
    init = function(self)
      self:removecommand('Init')

      local ctx = actorgen.Context.new()

      init(self, ctx)

      actorgen.ready(ctx)
    end,
    initEnd = function(self)
      self:removecommand('Init')
      actorgen.finalize()
    end,
    ---@param self ActorFrame
    load = function(self)
      --print(actorToString(self))

      local ctx = actorgen.Context.new()

      init(self, ctx)

      actorgen.ready(ctx)
      -- force-evaluate the actors.xml
      actorgen.forceEvaluate(self:GetChildAt(0))
      actorgen.finalize()
    end
  },
  Inputs = {
    On = function(self)
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
          mapParse, _, pn, keyName = string.find(meta, 'Controller (%d+) (.+)')
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