-- overlay screens are funny in that after they're initialized, the lua state is
-- reset at some point, rendering all lua data of the actors completely useless.
-- luckily i found a way to force evaluate actor235 a second time, but
-- pretend-running through to get all the actors from the already-generated
-- actorframe. yippee!

local TextInput = require 'gimmick.lib.textinput'

local consoleOpen = false

-- !!!!: actors built by `init` MUST remain deterministic.
-- in other words, make sure the actors initialized never change conditionally

---@param ctx Context
local function init(self, ctx)
  local ZOOM = 0.4
  local PADDING = 8
  local LEFT_PADDING = 16
  local HISTORY_HEIGHT = 250

  local REPEAT_DELAY = 0.35
  local REPEAT_INTERVAL = 0.03

  local blink = os.clock()

  local repeatT = {}

  local bitmapText = ctx:BitmapText(FONTS.monospace, '')
  bitmapText:xy(PADDING, PADDING)
  bitmapText:zoom(ZOOM)
  bitmapText:shadowlength(0)
  bitmapText:align(0, 0)
  bitmapText:diffuse(1, 1, 1, 1)

  local quad = ctx:Quad()

  local t = TextInput.new()

  event.on('keypress', function(device, key)
    if device ~= InputDevice.Key then return end

    blink = os.clock()

    if key == '9' and inputs.rawInputs[device]['left ctrl'] or inputs.rawInputs[device]['right ctrl'] then
      consoleOpen = not consoleOpen
      SCREENMAN:SetInputMode(consoleOpen and 1 or 0)
      return
    end

    if consoleOpen then
      if key == 'enter' and not (inputs.rawInputs[device]['left shift'] or inputs.rawInputs[device]['right shift']) then
        loadstring(t:toString(), 'console')()
        t.cursor = 0
        t.text = {}
        return
      end

      repeatT[key] = REPEAT_DELAY

      t:onKey(key, inputs.rawInputs[device])
    end
  end)
  event.on('keyrelease', function(device, key)
    if device ~= InputDevice.Key then return end

    repeatT[key] = nil
  end)

  local textWidth, textHeight = 0, 0

  local blur = gimmick.common.blurMask(ctx, function()
    return function()
      quad:diffuse(1, 0.4, 0.55, 1)
      quad:xywh(scx, HISTORY_HEIGHT/2, sw, HISTORY_HEIGHT)
      quad:Draw()

      quad:diffuse(1, 0.3, 0.5, 1)
      local backHeight = textHeight + PADDING*2
      quad:xywh(scx, HISTORY_HEIGHT + backHeight/2, sw, backHeight)
      quad:Draw()
    end
  end, 30)

  local time = 0

  self:SetDrawFunction(function()
    local newTime = os.clock()
    local dt = newTime - time
    time = newTime

    for key, clock in pairs(repeatT) do
      repeatT[key] = clock - dt
      if repeatT[key] <= 0 then
        repeatT[key] = repeatT[key] + REPEAT_INTERVAL
        t:onKey(key, inputs.rawInputs[InputDevice.Key])
      end
    end

    if consoleOpen then
      blur()

      --quad:diffuse(0, 0, 0, 0.4)
      --quad:xywh(scx, HISTORY_HEIGHT/2, sw, HISTORY_HEIGHT)
      --quad:Draw()

      bitmapText:diffuse(1, 1, 1, 0.2)
      bitmapText:align(1, 0)
      bitmapText:xy(sw - PADDING, PADDING)
      bitmapText:zoom(0.3)
      bitmapText:settext('GIMMICK v' .. gimmick._VERSION)
      bitmapText:Draw()
      bitmapText:zoom(ZOOM)

      local maxWidth = sw - PADDING * 2 - LEFT_PADDING

      local positions, width, height = TextInput.wrapText(t.text, bitmapText, maxWidth)
      textWidth, textHeight = width, height

      quad:diffuse(0, 0, 0, 0.2)
      local backHeight = height + PADDING*2
      quad:xywh(scx, HISTORY_HEIGHT + backHeight/2, sw, backHeight)
      quad:Draw()

      bitmapText:diffuse(1, 1, 1, 1)
      bitmapText:align(1, 0)

      for _, char in ipairs(positions) do
        bitmapText:xy(PADDING + LEFT_PADDING + char.x, HISTORY_HEIGHT + PADDING + char.y)
        bitmapText:settext(char.char)
        bitmapText:Draw()
      end

      -- hardcoded. Who gives a care
      local cursorOffset = -10
      if t.insert then
        cursorOffset = 0
      end

      local cursorPos = positions[t.cursor] or { x = 0, y = 0 }

      bitmapText:align(0, 0)
      bitmapText:xy(PADDING + LEFT_PADDING + cursorPos.x + cursorOffset * ZOOM, HISTORY_HEIGHT + PADDING + cursorPos.y)
      bitmapText:settext(t.insert and '_' or '|')
      local fade = (os.clock() - blink) % 1
      bitmapText:diffuse(1, 1, 1, fade < 0.5 and 0.5 or 0)
      bitmapText:Draw()

      bitmapText:xy(PADDING, HISTORY_HEIGHT + PADDING)
      bitmapText:settext('$')
      bitmapText:diffuse(0.6, 1, 0.4, 1)
      bitmapText:Draw()

      --bitmapText:xy(12, 92)
      --bitmapText:settext(tostring(t.cursor) .. ', ' .. tostring(#t.text) .. ', ' .. fullDump(t.text, nil, true))
      --bitmapText:Draw()

      if TextInput.capsLock then
        bitmapText:settext('!')
        bitmapText:xy(sw - PADDING - 20 * ZOOM, HISTORY_HEIGHT + backHeight - PADDING - 38 * ZOOM)
        bitmapText:diffuse(0, 0, 0, 1)
        drawBorders(bitmapText, 1)
        bitmapText:diffuse(1, 0.2, 0.2, 1)
        bitmapText:Draw()
      end
    end
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