-- overlay screens are funny in that after they're initialized, the lua state is
-- reset at some point, rendering all lua data of the actors completely useless.
-- luckily i found a way to force evaluate actor235 a second time, by
-- pretend-running through to get all the actors from the already-generated
-- actorframe. yippee!

local tick       = require 'gimmick.lib.tick'
local Scope      = require 'gimmick.scope'
local inputs     = require 'gimmick.lib.inputs'

---@alias OverlayModule fun(ctx: Context, scope: Scope): ({ draw:(fun(dt: number)), z: number? })

---@type OverlayModule[]
local moduleSources = {
  hotkeys = require 'gimmick.screens.OverlayScreen.modules.hotkeys',
  pause = require 'gimmick.screens.OverlayScreen.modules.pause',
  devtools = require 'gimmick.screens.OverlayScreen.modules.devtools',
  console = require 'gimmick.screens.OverlayScreen.modules.console',
  save = require 'gimmick.screens.OverlayScreen.modules.save',
  imap = require 'gimmick.screens.OverlayScreen.modules.imap',
}

local modules = {}

---@param self ActorFrame
---@param ctx Context
---@param scope Scope
local function init(self, ctx, scope)
  local lastdw, lastdh = dw, dh

  for key, module in pairs(moduleSources) do
    modules[key] = module(ctx, scope)
  end

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

    for _, module in pairs(modules) do
      if module.draw then module.draw(dt) end
    end
  end)
end

return {
  modules = modules,
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