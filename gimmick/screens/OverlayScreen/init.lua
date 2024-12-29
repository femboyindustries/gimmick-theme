-- overlay screens are funny in that after they're initialized, the lua state is
-- reset at some point, rendering all lua data of the actors completely useless.
-- luckily i found a way to force evaluate actor235 a second time, but
-- pretend-running through to get all the actors from the already-generated
-- actorframe. yippee!

-- todo import order matters for event ordering. FOR NOW. i want to change this.
local pauseModule = require 'gimmick.screens.OverlayScreen.pause'
local devToolsModule = require 'gimmick.screens.OverlayScreen.devtools'
local consoleModule = require 'gimmick.screens.OverlayScreen.console'
local saveModule = require 'gimmick.screens.OverlayScreen.save'
local imapModule = require 'gimmick.screens.OverlayScreen.imap'
local tick       = require 'gimmick.lib.tick'
local Scope      = require 'gimmick.scope'
local inputs     = require 'gimmick.lib.inputs'

-- !!!!: actors built by `init` MUST remain deterministic.
-- in other words, make sure the actors initialized never change conditionally

---@param self ActorFrame
---@param ctx Context
---@param scope Scope
local function init(self, ctx, scope)
  local drawConsole = consoleModule.init(self, ctx, scope)
  local drawSave = saveModule.init(self, ctx)
  local drawImap = imapModule.init(self, ctx)
  local drawPause = pauseModule.init(self, ctx, scope)
  local drawDevTools = devToolsModule.init(self, ctx, scope)

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
      event:call('resize', dw, dh)
      lastdw, lastdh = dw, dh
    end
  end)

  setDrawFunctionWithDT(self, function(dt)
    tick:update(dt)

    drawPause(dt)
    drawConsole(dt)
    drawDevTools(dt)
    drawSave(dt)
    drawImap(dt)
  end)
end

return {
  modules = {
    pause = pauseModule
  },
  overlay = {
    init = function(self)
      self:removecommand('Init')

      local ctx = actorgen.Context.new()

      init(self, ctx, Scope.new('Dummy OverlayScreen'))

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

      local scope = Scope.new('OverlayScreen')

      local lastT
      self:addcommand('Update', function()
        if not lastT then lastT = os.clock() end
        local t = os.clock()
        local dt = t - lastT
        lastT = t
        scope.tick:update(dt)
      end)

      self:luaeffect('Update')

      self:removecommand('On')
      self:addcommand('On', function()
        scope:onCommand()
      end)
      self:addcommand('Off', function()
        scope:offCommand()
      end)

      init(self, ctx, scope)

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