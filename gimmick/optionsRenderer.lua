---@class OptionsRenderer
local OptionsRenderer = {}

OptionsRenderer.frameDrawFunc = nil

function OptionsRenderer.OptionsRenderer()
  return {
    --[[
      additionally requires all of the following at ScreenOptions:

      ItemsLongRowSharedX=-1
      ItemsLongRowP1X=-1
      ItemsLongRowP2X=-1
      ItemsGapX=1
      ItemsStartX=0
      ItemsEndX=9999999
      # helps w/ positioning
      ItemsOnCommand=zoomx,0

      Row1Y=1
      Row2Y=2
      Row3Y=3
      Row4Y=4
      Row5Y=5
      # ...
    ]]

    Init = function(frame)
      if not OptionsRenderer.frameDrawFunc then
        error('frameDrawFunc not defined, likely forgot to call OptionsRenderer.init')
      end
      frame:SetDrawFunction(OptionsRenderer.frameDrawFunc)
    end
  }
end

-- todo move this somewhere more global
local function getPlayerColor(pn)
  return pn == 1 and rgb(1, 0.3, 0.4) or rgb(0.2, 0.3, 1)
end

---@param ctx Context
---@param scope Scope
---@param optionsGetter fun(): Option[]
---@param players number?
function OptionsRenderer.init(ctx, scope, optionsGetter, players)
  players = players or 2
  local firstFrame = true
  ---@type {idx: number?, actor: ActorFrame, layoutType: LayoutType, name: string, choices: string[]?, underlines: table<number, ActorFrame[]>, selected: table<number, boolean[]>, selectedX: easable, isExit: boolean, widths: number[], oneChoiceForAllPlayers: boolean, opt: Option}[]
  local optionRows = {}
  local optionRowOverlays = {}

  for i, opt in ipairs(optionsGetter()) do
    if opt.overlay then
      optionRowOverlays[i] = opt.overlay(ctx, scope)
    end
  end

  local function getRow(idx)
    for _, row in ipairs(optionRows) do
      if idx == row.idx then
        return row
      end
    end
  end

  ---@type ActorFrame[]
  local cursors = {}

  local selectedRow = { 1, 1 }
  local selectedOption = { 1, 1 }

  local cursorEases = {}
  for pn = 1, players do
    cursorEases[pn] = {scope.tick:easable(0, 25), scope.tick:easable(0, 25), scope.tick:easable(0, 25)}
  end

  local WIDTH = math.min(sw - 64, 640)
  local LABEL_LEFT_X = scx - WIDTH/2 + 200
  local OPTION_GAP = 10
  local ROWS_TOP_Y = 32
  local ROW_HEIGHT = 28
  local SKEW = 0.4

  local quad = ctx:Quad()
  local text = ctx:BitmapText(FONTS.sans_serif, '')
  text:halign(1)
  text:shadowlength(0)
  text:zoom(0.3)
  local optText = ctx:BitmapText(FONTS.sans_serif, '')
  optText:shadowlength(0)
  optText:zoom(0.35)

  OptionsRenderer.frameDrawFunc = function(frame)
    if firstFrame then
      local sprHightlightP1 = frame(2)
      local sprHightlightP2 = frame(3)

      for pn = 1, players do
        cursors[pn] = frame(4 + pn - 1)
      end

      local optIndex = 1
      while not frame(6 + optIndex - 1).GetText do
        local row = frame(6 + optIndex - 1):GetChildAt(0)
        --print(row:GetChildAt(3))
        local isShowAllInRow = false
        local opt1 = row:GetChildAt(4)

        if opt1 and opt1:GetX() ~= -1 then
          isShowAllInRow = true
        end

        local def = optionsGetter()[optIndex]
        local luaDef = def and def.optionRow

        for _, child in ipairs(row:GetChildren()) do
          child:zoomx(1)
        end

        local underlines = {{}, {}}
        local underlineBuffer = {}

        local subOptIndex = #row:GetChildren()
        while row(subOptIndex).GetChildren do
          table.insert(underlineBuffer, 1, row(subOptIndex))
          subOptIndex = subOptIndex - 1
        end
        for i = 1, #underlineBuffer/2 do
          table.insert(underlines[1], underlineBuffer[i])
        end
        for i = #underlineBuffer/2+1, #underlineBuffer do
          table.insert(underlines[2], underlineBuffer[i])
        end

        local isExit = not row:GetChildAt(5)
        local choices = isExit and ({ 'EXIT' }) or (luaDef and luaDef.Choices)
        if not choices then
          choices = {}
          if not isShowAllInRow then
            error('don\'t know how to generically get choices from ShowOneInRow. sorry!!!')
          end
          subOptIndex = 4
          while row:GetChildAt(subOptIndex).GetText do
            table.insert(choices, row:GetChildAt(subOptIndex):GetText())
            subOptIndex = subOptIndex + 1
          end
        end
        local widths = {}

        for i, choice in ipairs(choices) do
          optText:settext(choice)
          widths[i] = optText:GetWidth() * 0.35
        end

        local oneChoiceForAllPlayers = false
        if luaDef then
          oneChoiceForAllPlayers = luaDef.OneChoiceForAllPlayers or false
        else
          if isExit then
            oneChoiceForAllPlayers = true
          else
            if isShowAllInRow then
              oneChoiceForAllPlayers = #underlines[1] < #choices
            else
              oneChoiceForAllPlayers = #underlines[1] == 0
            end
          end
        end

        if def and def.marginTop then
          for _ = 1, def.marginTop do
            table.insert(optionRows, {})
          end
        end

        table.insert(optionRows, {
          idx = optIndex,
          actor = row,
          layoutType = isShowAllInRow and 'ShowAllInRow' or 'ShowOneInRow',
          name = luaDef and luaDef.Name or row:GetChildAt(3):GetText(),
          choices = choices,
          widths = widths,
          selected = { {}, {} },
          underlines = underlines,
          isExit = isExit,
          selectedX = scope.tick:easable(0, 25),
          oneChoiceForAllPlayers = oneChoiceForAllPlayers,
          opt = def,
        })

        if def and def.marginBottom then
          for _ = 1, def.marginBottom do
            table.insert(optionRows, {})
          end
        end
        
        optIndex = optIndex + 1
      end

      -- despite both having Change fired on them, these are fired regardless
      -- of if P1 or P2 moves
      sprHightlightP1:addcommand('Change', function()
        scope.tick:func(0, function()
          for pn, cursor in ipairs(cursors) do
            --print('p' .. pn)
            cursor:finishtweening()
            --print(cursor:GetX(), cursor:GetY())
            local rowIdx = cursor:GetY()
            local lastRow, lastOption = selectedRow[pn], selectedOption[pn]
            selectedRow[pn] = rowIdx
            local row = getRow(rowIdx)
            if row and row.layoutType == 'ShowAllInRow' then
              selectedOption[pn] = cursor:GetX() + 1
            else
              local foundOpt = false
              if row.choices then
                local idx = 4 + (pn - 1)
                if row.oneChoiceForAllPlayers then
                  idx = 4
                end
                local foundChoice = row.actor:GetChildAt(idx)
                for i, choice in ipairs(row.choices) do
                  if foundChoice and foundChoice.GetText and choice == foundChoice:GetText() then
                    selectedOption[pn] = i
                    foundOpt = true
                    break
                  end
                end
              end
              if not foundOpt then selectedOption[pn] = 1 end
            end
            if lastRow == selectedRow[pn] and lastOption ~= selectedOption[pn] then
              if row.opt.onChange then
                row.opt.onChange(scope, pn)
              end
            end
          end
        end)
      end)
    end

    local yOff = cursorEases[1][2].eased - scy

    yOff = math.min(yOff, ROW_HEIGHT * #optionRows - (sh - ROWS_TOP_Y))
    yOff = math.max(yOff, 0)
    yOff = -yOff

    for rowIndex, row in ipairs(optionRows) do
      local opt = optionRows[rowIndex]
      local y = ROWS_TOP_Y + (rowIndex - 1) * ROW_HEIGHT + yOff

      -- todo this is a fucking disaster

      quad:diffuse(0.2, 0.2, 0.2, 1)
      quad:skewx(-SKEW/WIDTH*ROW_HEIGHT)
      quad:zoomto(WIDTH, ROW_HEIGHT)
      quad:xy(scx, y)
      quad:Draw()

      quad:diffuse(0.17, 0.17, 0.17, 1)
      quad:skewx(-SKEW/WIDTH*(ROW_HEIGHT/2))
      quad:zoomto(WIDTH, ROW_HEIGHT/2)
      quad:xy(scx, y+ROW_HEIGHT/4)
      quad:Draw()

      quad:diffuse(0, 0, 0, 0.2)
      quad:skewx(-SKEW/(LABEL_LEFT_X - (scx - WIDTH/2))*ROW_HEIGHT)
      quad:zoomto(LABEL_LEFT_X - (scx - WIDTH/2), ROW_HEIGHT)
      quad:xy(scx - WIDTH/2 + (LABEL_LEFT_X - (scx - WIDTH/2))/2, y)
      quad:Draw()

      quad:diffuse(1, 1, 1, 1)
      quad:zwrite(1)
      quad:blend('noeffect')
      -- help
      quad:skewx(-SKEW/(WIDTH - (LABEL_LEFT_X - (scx - WIDTH/2)))*ROW_HEIGHT)
      quad:zoomto(WIDTH - (LABEL_LEFT_X - (scx - WIDTH/2)), ROW_HEIGHT)
      quad:xy(LABEL_LEFT_X + (WIDTH - (LABEL_LEFT_X - (scx - WIDTH/2)))/2, y)
      quad:Draw()
      quad:zwrite(0)
      quad:blend('normal')
      quad:skewx(0)

      if opt then
        if opt.layoutType == 'ShowAllInRow' then
          local x = 0

          -- todo don't do this twice
          local optsWidth = 0
          for i, option in ipairs(opt.choices) do
            local width = opt.widths[i] + OPTION_GAP*2
            optsWidth = optsWidth + width
          end
          local totalWidth = WIDTH - (LABEL_LEFT_X - (scx-WIDTH/2))
          x = -math.max(opt.selectedX.eased - totalWidth/2, 0)
          x = math.max(x, -optsWidth + totalWidth)

          if optsWidth < totalWidth then
            x = 0
          end

          for i, option in ipairs(opt.choices) do
            local width = opt.widths[i] + OPTION_GAP*2
            if i % 2 == 0 then
              quad:diffuse(0, 0, 0, 0.2)
              quad:skewx(-SKEW/width*ROW_HEIGHT)
              quad:zoomto(width, ROW_HEIGHT)
              quad:xy(LABEL_LEFT_X + x + width/2, y)
              quad:ztest(1)
              quad:ztestmode('writeonfail')
              quad:Draw()
              quad:ztest(0)
              quad:ztestmode('off')
            end
            x = x + width
          end
        else
        end
      end
    end

    for pn = #cursors, 1, -1 do
      local cursor = cursors[pn]
      local eases = cursorEases[pn]

      cursor:finishtweening()

      local color = getPlayerColor(pn)
      local x = eases[1].eased
      local width = eases[3].eased
      if (x-width/2) < LABEL_LEFT_X then
        local cut = LABEL_LEFT_X - (x-width/2)
        width = math.max(width - cut, 0)
        x = x + cut/2
      end
      if (x+width/2) > scx+WIDTH/2 then
        local cut = (x+width/2) - (scx+WIDTH/2)
        width = math.max(width - cut, 0)
        x = x - cut/2
      end
      quad:xy(x, eases[2].eased + yOff)
      eases[3]:set((getRow(selectedRow[pn]).widths[selectedOption[pn]] + OPTION_GAP*2))
      quad:zoomto(width, ROW_HEIGHT)
      quad:diffuse(color:unpack())
      quad:skewx(-SKEW/width*ROW_HEIGHT)
      quad:Draw()
      quad:skewx(0)
    end
    if players > 1 then
      -- todo: ideally, we shouldn't duplicate this
      local pn = 2

      local cursor = cursors[pn]
      local eases = cursorEases[pn]

      cursor:finishtweening()

      local color = getPlayerColor(pn)
      local x = eases[1].eased
      local width = eases[3].eased
      if (x-width/2) < LABEL_LEFT_X then
        local cut = LABEL_LEFT_X - (x-width/2)
        width = math.max(width - cut, 0)
        x = x + cut/2
      end
      if (x+width/2) > scx+WIDTH/2 then
        local cut = (x+width/2) - (scx+WIDTH/2)
        width = math.max(width - cut, 0)
        x = x - cut/2
      end
      quad:xy(x - SKEW*ROW_HEIGHT/4, eases[2].eased + yOff + ROW_HEIGHT/4)
      quad:zoomto(width, ROW_HEIGHT/2)
      quad:diffuse(color:unpack())
      quad:skewx(-SKEW/width*(ROW_HEIGHT/2))
      quad:Draw()
      quad:skewx(0)
    end

    for rowIndex, row in ipairs(optionRows) do
      local optIdx = row.idx

      if optIdx then
        local opt = row
        local y = ROWS_TOP_Y + (rowIndex - 1) * ROW_HEIGHT
        local enabledPlayers = players
        local players = players
        if opt.oneChoiceForAllPlayers then
          players = 1
        end

        if opt then
          text:settext(opt.name)
          text:xy(LABEL_LEFT_X - 10, y + yOff)
          text:Draw()

          if opt.layoutType == 'ShowAllInRow' then
            local x = 0
            for pn, underlines in ipairs(opt.underlines) do
              for i, underline in ipairs(underlines) do
                opt.selected[pn][i] = not underline:GetHidden()
              end
            end

            -- todo: switch followed pn based on which one moved last
            local followPn = 1

            local optsWidth = 0
            for i, option in ipairs(opt.choices) do
              local width = opt.widths[i] + OPTION_GAP*2
              if selectedRow[followPn] == optIdx and selectedOption[followPn] == i then
                opt.selectedX:set(optsWidth + width/2)
              end
              optsWidth = optsWidth + width
            end
            local totalWidth = WIDTH - (LABEL_LEFT_X - (scx-WIDTH/2))
            x = -math.max(opt.selectedX.eased - totalWidth/2, 0)
            x = math.max(x, -optsWidth + totalWidth)

            if optsWidth < totalWidth then
              x = 0
            end

            for i, option in ipairs(opt.choices) do
              local width = opt.widths[i] + OPTION_GAP*2
              local hovered = false
              for pn = 1, players do
                hovered = hovered or
                  (selectedRow[pn] == optIdx and selectedOption[pn] == i)
                local selected = opt.selected[pn][i]
                if selected then
                  quad:zoomto(opt.widths[i] * 0.9, 1)
                  quad:xy(LABEL_LEFT_X + x + width/2, y + yOff + 10 * (pn%2*2-1))
                  quad:diffuse((hovered and rgb(1, 1, 1) or getPlayerColor(pn)):unpack())
                  quad:ztest(1)
                  quad:ztestmode('writeonfail')
                  quad:Draw()
                  quad:ztest(0)
                  quad:ztestmode('off')
                end
              end
              if hovered then
                optText:diffuse(1, 1, 1, 1)
              else
                optText:diffuse(0.8, 0.8, 0.8, 1)
              end
              for pn = 1, enabledPlayers do
                if selectedRow[pn] == optIdx and selectedOption[pn] == i then
                  cursorEases[pn][1]:set(LABEL_LEFT_X + x + width/2)
                  cursorEases[pn][2]:set(y)
                end
              end
              optText:settext(option)
              optText:xy(LABEL_LEFT_X + x + width/2, y + yOff)
              optText:ztest(1)
              optText:ztestmode('writeonfail')
              optText:Draw()
              optText:ztest(0)
              optText:ztestmode('off')

              if optionRowOverlays[opt.idx] then
                local draw = optionRowOverlays[opt.idx]
                draw(opt.opt.optionRow, opt.selected, 1, LABEL_LEFT_X + totalWidth/2, y + yOff)
              end
              
              x = x + width
            end
          else
            for pn = 1, players do
              local baseX = LABEL_LEFT_X
              local totalWidth = WIDTH - (LABEL_LEFT_X - (scx-WIDTH/2))
              local segmentWidth = totalWidth/players

              local x = baseX + segmentWidth * (pn-0.5)
              local align = 0

              if opt.choices then
                local foundChoice = opt.actor:GetChildAt(4 + (pn - 1)) -- m_textItems[pn]
                local onChoice
                for i, choice in ipairs(opt.choices) do
                  if foundChoice and foundChoice.GetText and choice == foundChoice:GetText() then
                    if not opt.isExit then
                      opt.selected[pn][i] = not opt.underlines[pn][1]:GetHidden()
                    end
                    onChoice = i
                    break
                  end
                end
                if onChoice then
                  local width = opt.widths[onChoice] + OPTION_GAP*2
                  local choice = opt.choices[onChoice]
                  
                  local hovered = selectedRow[pn] == optIdx
                  if opt.oneChoiceForAllPlayers and enabledPlayers > 1 then
                    hovered =
                      selectedRow[1] == optIdx or
                      selectedRow[2] == optIdx
                  end
                  local selected = opt.selected[pn][onChoice]
                  if selected then
                    quad:zoomto(opt.widths[onChoice]*0.9, 1)
                    quad:xy(x + width*align, y + yOff + 10)
                    quad:diffuse((hovered and rgb(1, 1, 1) or getPlayerColor(pn)):unpack())
                    quad:Draw()
                  end
                  if hovered then
                    optText:diffuse(1, 1, 1, 1)
                  else
                    if opt.isExit then
                      optText:diffuse(0.9, 0.7, 0.7, 1)
                    else
                      optText:diffuse(0.8, 0.8, 0.8, 1)
                    end
                  end
                  -- this is ugly but oh well
                  if opt.oneChoiceForAllPlayers and enabledPlayers > 1 then
                    for pn = 1, enabledPlayers do
                      if selectedRow[pn] == optIdx then
                        cursorEases[pn][1]:set(x + width*align)
                        cursorEases[pn][2]:set(y)
                      end
                    end
                  else
                    if hovered then
                      cursorEases[pn][1]:set(x + width*align)
                      cursorEases[pn][2]:set(y)
                    end
                  end
                  optText:settext(choice)
                  optText:xy(x + width*align, y + yOff)
                  optText:Draw()

                  if optionRowOverlays[opt.idx] then
                    local draw = optionRowOverlays[opt.idx]
                    draw(opt.opt.optionRow, opt.selected, pn, x + width * align, y + yOff)
                  end
                end
              end
            end
          end
        end
      end
    end

    if firstFrame then
      for _, eases in ipairs(cursorEases) do
        for _, v in ipairs(eases) do v.eased = v.target end
      end
    end

    firstFrame = false
  end
end

return OptionsRenderer