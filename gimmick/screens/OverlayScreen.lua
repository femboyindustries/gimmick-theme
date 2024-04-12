-- overlay screens are funny in that after they're initialized, the lua state is
-- reset at some point, rendering all lua data of the actors completely useless.
-- luckily i found a way to force evaluate actor235 a second time, but
-- pretend-running through to get all the actors from the already-generated
-- actorframe. yippee!

local TextInput = require 'gimmick.lib.textinput'

local names = {
  'GOCK (Gimmick Official Console Kontext)',
  'GIC (Gimmick Interactive Console)',
  'GREAT- (Gimmick\'s Read-Evaluate-Achieve Tool)',
  'Powershell (Mayflower suggested this one)',
  'GNU (Gimmick NotITG Utility)',
  'FISH (Fanciest Interactive SHell)',
  'RACISM (Really awesome console i started making)',
  'ITG (I hate Theming _G)',
}
local name = names[math.random(1, #names)]
local tips = {
  'Use PgUp and PgDown to scroll through the history',
  'Use Ctrl + and Ctrl - to zoom the console in or out',
}
local tip = tips[math.random(1, #tips)]

local consoleOpen = false
local history = {}
local typedHistory = {}
local historyIdx = 0

local HistoryType = {
  OK = 0,
  Error = 1,
  Input = 2,
  Log = 3,
}

local function formatReturn(args, n)
  n = n or 1
  local text = {}
  for i = n, math.max(n, #args) do
    table.insert(text, pretty(args[i]))
  end
  return table.concat(text, ', ')
end

local function eval(str)
  local fn, err = loadstring(
    string.format('return (%s)', str), 'console')

  if not fn then
    fn, err = loadstring(str, 'console')
  end

  if not fn then
    return HistoryType.Error, err
  end

  paw(fn)

  local res = {pcall(function()
    return (function(...)
      return arg
    end)(fn())
  end)}
  local ok = res[1]

  if not ok then
    return HistoryType.Error, res[2]
  else
    return HistoryType.OK, formatReturn(res[2], 1)
  end
end

-- check this shit out

local _print = print
_G.print = function(...)
  table.insert(history, {HistoryType.Log, formatReturn(arg)})
  return _print(unpack(arg))
end

-- !!!!: actors built by `init` MUST remain deterministic.
-- in other words, make sure the actors initialized never change conditionally

---@param ctx Context
local function init(self, ctx)
  local zoom = 0.4
  local PADDING = 8
  local LEFT_PADDING = 16
  local HISTORY_HEIGHT = 250

  local REPEAT_DELAY = 0.35
  local REPEAT_INTERVAL = 0.03

  local blink = os.clock()

  local scroll = 0

  local repeatT = {}

  local scissor = ctx:Shader('Shaders/scissor.frag')

  local bitmapText = ctx:BitmapText(FONTS.monospace, '')
  bitmapText:xy(PADDING, PADDING)
  bitmapText:zoom(zoom)
  bitmapText:shadowlength(0)
  bitmapText:align(0, 0)
  bitmapText:diffuse(1, 1, 1, 1)

  local quad = ctx:Quad()

  local t = TextInput.new()

  event.on('keypress', function(device, key)
    if device ~= InputDevice.Key then return end

    blink = os.clock()

    if key == '9' and (inputs.rawInputs[device]['left ctrl'] or inputs.rawInputs[device]['right ctrl']) then
      consoleOpen = not consoleOpen
      SCREENMAN:SetInputMode(consoleOpen and 1 or 0)
      return
    end

    if consoleOpen then
      if key == 'enter' and not (inputs.rawInputs[device]['left shift'] or inputs.rawInputs[device]['right shift']) then
        table.insert(typedHistory, t.text)
        historyIdx = 0
        table.insert(history, {HistoryType.Input, t:toString()})
        local status, res = eval(t:toString())
        table.insert(history, {status, res})
        t.cursor = 0
        t.text = {}
        scroll = 0
        return
      end

      if key == 'up' or key == 'down' then
        historyIdx = historyIdx + ((key == 'up') and 1 or -1)
        historyIdx = math.max(historyIdx, 0)
        historyIdx = math.min(historyIdx, #typedHistory)

        if historyIdx == 0 then
          t.text = {}
        else
          t.text = typedHistory[#typedHistory - (historyIdx - 1)]
        end
        t.cursor = #t.text
      end
      if key == 'pgup' or key == 'pgdn' then
        scroll = scroll + ((key == 'pgup' and 1 or -1)) * 70
        scroll = math.max(scroll, 0)
      end
      if (inputs.rawInputs[device]['left ctrl'] or inputs.rawInputs[device]['right ctrl']) and (key == '-' or key == '=') then
        local mult = key == '=' and (1 / 0.85) or 0.85
        zoom = zoom * mult
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
      quad:diffuse(1, 0.4, 0.6, 1)
      quad:xywh(scx, HISTORY_HEIGHT/2, sw, HISTORY_HEIGHT)
      quad:Draw()

      quad:diffuse(1, 0.3, 0.55, 1)
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

      bitmapText:SetShader(actorgen.Proxy.getRaw(scissor))
      scissor:uniform2f('res', dw, dh)

      --quad:diffuse(0, 0, 0, 0.4)
      --quad:xywh(scx, HISTORY_HEIGHT/2, sw, HISTORY_HEIGHT)
      --quad:Draw()

      bitmapText:diffuse(1, 1, 1, 0.2)
      bitmapText:align(1, 0)
      bitmapText:xy(sw - PADDING, PADDING)
      bitmapText:zoom(0.3)
      bitmapText:settext('GIMMICK v' .. gimmick._VERSION)
      bitmapText:Draw()
      bitmapText:zoom(zoom)

      local maxWidth = sw - PADDING * 2 - LEFT_PADDING

      bitmapText:diffuse(1, 1, 1, 1)
      bitmapText:align(0, 0)
      bitmapText:wrapwidthpixels(maxWidth / zoom)

      local y = HISTORY_HEIGHT + scroll
      local totalHeight = 0
      for i = #history, 1, -1 do
        local hist = history[i]
        local status, text = hist[1], hist[2]
        bitmapText:settext(text)
        local height = (bitmapText:GetHeight() + 40) * zoom
        y = y - height
        totalHeight = totalHeight + height

        if (y + height) > 0 and y < HISTORY_HEIGHT then
          height = math.min(height, HISTORY_HEIGHT - y)
          --bitmapText:cropbottom(height / bitmapText:GetHeight())
          scissor:uniform1f('bottom', 1 - HISTORY_HEIGHT / sh)

          if (#history - i) % 2 == 1 then
            quad:diffuse(0, 0, 0, 0.04)
            quad:xywh(scx, y + height/2, sw, height)
            quad:Draw()
          end
          if status == HistoryType.Error then
            quad:diffuse(1, 0, 0, 0.15)
            quad:xywh(scx, y + height/2, sw, height)
            quad:Draw()
          end

          bitmapText:diffuse(1, 1, 1, 1)
          if status == HistoryType.OK and text == 'nil' then
            bitmapText:diffuse(0.9, 0.9, 0.9, 1)
          end
          bitmapText:xy(PADDING + LEFT_PADDING, y + 20 * zoom)
          bitmapText:Draw()

          if status == HistoryType.Error then
            bitmapText:xy(PADDING, y + 20 * zoom)
            bitmapText:settext('!')
            bitmapText:diffuse(0, 0, 0, 1)
            drawBorders(bitmapText, 1)
            bitmapText:diffuse(1, 0.2, 0.2, 1)
            bitmapText:Draw()
          elseif status == HistoryType.OK then
            bitmapText:xy(PADDING, y + 20 * zoom)
            bitmapText:settext('>')
            bitmapText:diffuse(0, 0, 0, 1)
            drawBorders(bitmapText, 1)
            bitmapText:diffuse(0.2, 1, 0.2, 1)
            bitmapText:Draw()
          elseif status == HistoryType.Log then
            bitmapText:xy(PADDING, y + 20 * zoom)
            bitmapText:settext('?')
            bitmapText:diffuse(0, 0, 0, 1)
            drawBorders(bitmapText, 1)
            bitmapText:diffuse(0.3, 0.4, 1, 1)
            bitmapText:Draw()
          end
        end
      end
      scroll = math.min(scroll, math.max(totalHeight - HISTORY_HEIGHT, 0))

      scissor:uniform1f('bottom', 0)
      bitmapText:maxwidth(0)

      if totalHeight > HISTORY_HEIGHT then
        local scrollHeight = HISTORY_HEIGHT / totalHeight
        local scrollPos = scroll / (totalHeight - HISTORY_HEIGHT)
        local top = mix(1 - scrollHeight, 0, scrollPos)
        local bot = mix(1, scrollHeight, scrollPos)

        local barWidth = 4

        quad:diffuse(1, 1, 1, 0.4)
        quad:xywh(sw - barWidth/2, ((top + bot) / 2) * HISTORY_HEIGHT, barWidth, HISTORY_HEIGHT * scrollHeight)
        quad:Draw()
      end

      if #history == 0 then
        bitmapText:settext('Welcome to ' .. name .. '\n' .. 'Tip: ' .. tip .. '\nType a Lua expression...')
        bitmapText:diffuse(1, 1, 1, 1)
        bitmapText:xy(PADDING + LEFT_PADDING, HISTORY_HEIGHT - bitmapText:GetHeight() * zoom - 12)
        bitmapText:Draw()
      end

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
      bitmapText:xy(PADDING + LEFT_PADDING + cursorPos.x + cursorOffset * zoom, HISTORY_HEIGHT + PADDING + cursorPos.y)
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
        bitmapText:xy(sw - PADDING - 20 * zoom, HISTORY_HEIGHT + backHeight - PADDING - 38 * zoom)
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