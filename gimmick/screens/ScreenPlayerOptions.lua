local options = require 'gimmick.options'
local stack   = require 'gimmick.stack'

local optionsStack = stack.new()
local stackLocked = true

local function setOptions(name)
  optionsStack:push(name)
  delayedSetScreen('ScreenPlayerOptions')
  stackLocked = true
  print('Pushing to stack: ' .. name)
end
local function stallOptions()
  delayedSetScreen('ScreenPlayerOptions')
  stackLocked = true
end

---@param screen string
---@param name string
---@param value string?
local function screenButton(screen, name, value)
  return options.option.button(name, value or name, function()
    setOptions(screen)
  end)
end

---@param screen string
---@param name string
---@param value string?
---Like screenButton but can go to any screen
local function arbitraryScreen(screen, name, value)
  return options.option.button(name, value or name, function()
    delayedSetScreen(screen)
  end)
end

---@type table<string, Option[]>
local optionsTable = {
  root = {
    {
      type = 'lua',
      optionRow = {
        Name = 'bwaaa',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectOne',
        Choices = { 'bingus', 'bongus', 'awawa', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'Bumpscosity',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectOne',
        Choices = { '1.00', '1.05', '1.10', '1.15', '1.20', '1.25', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = options.option.mods('Perspective', {'Overhead','Hallway','Distant','Incoming','Space'}, true)
    },
    {
      type = 'lua',
      optionRow = options.option.mods('Turn', {'Mirror','SoftShuffle','SmartBlender','Blender'})
    },
    {
      type = 'lua',
      optionRow = options.option.mods('Accel', {'Accel','Decel','Wave','Boomerang','Expand','Bump'}),
    },
    {
      type = 'lua',
      optionRow = options.option.mods('Scroll', {'Reverse','Split','Alternate','Cross','Centered'}),
    },
    {
      type = 'lua',
      optionRow = options.option.mods('Swaps', {'Flip', 'Invert'}),
    },
  },
}

-- todo move this somewhere more global
local function getPlayerColor(pn)
  return pn == 1 and rgb(1, 0.3, 0.4) or rgb(0.2, 0.3, 1)
end

local optionsFrameDrawfunc

return {
  Options = {
    Init = function(frame)
      print('frame Got!')
      print(frame)
      frame:SetDrawFunction(optionsFrameDrawfunc)
    end
  },

  overlay = gimmick.ActorScreen(function(self, ctx, scope)
    local opts = optionsStack:top()
    local res = optionsTable[opts]

    local drawOverlay = nil

    if res and res.overlay then
      drawOverlay = res.overlay(self, ctx)
    end

    --local testText = ctx:BitmapText('common','Fart')

    local firstFrame = true
    ---@type {actor: ActorFrame, layoutType: LayoutType, name: string, choices: string[]?, underlines: table<number, ActorFrame[]>, selected: table<number, boolean[]>, isExit: boolean, widths: number[]}[]
    local optionRows = {}

    ---@type ActorFrame[]
    local cursors = {}

    local selectedRow = { 1, 1 }
    local selectedOption = { 1, 1 }

    local cursorEases = {}
    for pn = 1, 2 do
      cursorEases[pn] = {scope.tick:easable(0, 25), scope.tick:easable(0, 25), scope.tick:easable(0, 25)}
    end

    local WIDTH = math.min(sw - 64, 640)
    local LABEL_LEFT_X = scx - WIDTH/2 + 230
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

    self:SetDrawFunction(function()
      if drawOverlay then drawOverlay() end
    end)

    optionsFrameDrawfunc = function(frame)
      if firstFrame then
        local sprHightlightP1 = frame(2)
        local sprHightlightP2 = frame(3)

        cursors[1] = frame(4)
        cursors[2] = frame(5)

        local optIndex = 1
        while not frame(6 + optIndex - 1).GetText do
          local row = frame(6 + optIndex - 1):GetChildAt(0)
          print(row:GetChildAt(3))
          local isShowAllInRow = false
          local opt1 = row:GetChildAt(4)

          if opt1 and opt1:GetX() ~= -1 then
            isShowAllInRow = true
          end

          local def = optionsTable[optionsStack:top()][optIndex]
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
          local choices = isExit and ({ 'EXIT' }) or (luaDef and luaDef.Choices or {})
          local widths = {}

          for i, choice in ipairs(choices) do
            optText:settext(choice)
            widths[i] = optText:GetWidth() * 0.35
          end

          optionRows[optIndex] = {
            actor = row,
            layoutType = isShowAllInRow and 'ShowAllInRow' or 'ShowOneInRow',
            name = luaDef and luaDef.Name or row:GetChildAt(3):GetText(),
            choices = choices,
            widths = widths,
            selected = { {}, {} },
            underlines = underlines,
            isExit = isExit,
          }
          
          optIndex = optIndex + 1
        end

        -- despite both having Change fired on them, these are fired regardless
        -- of if P1 or P2 moves
        sprHightlightP1:addcommand('Change', function()
          print('something just happened')
          scope.tick:func(0, function()
            print('(...contd)')
            for pn, cursor in ipairs(cursors) do
              print('p' .. pn)
              cursor:finishtweening()
              print(cursor:GetX(), cursor:GetY())
              local row = cursor:GetY()
              selectedRow[pn] = row
              if optionRows[row] and optionRows[row].layoutType == 'ShowAllInRow' then
                selectedOption[pn] = cursor:GetX() + 1
              else
                if optionRows[row].choices then
                  local foundChoice = optionRows[row].actor:GetChildAt(4 + (pn - 1))
                  for i, choice in ipairs(optionRows[row].choices) do
                    if foundChoice and foundChoice.GetText and choice == foundChoice:GetText() then
                      print(choice)
                      selectedOption[pn] = i
                      break
                    end
                  end
                end
              end
            end
          end)
        end)

        firstFrame = false
      end

      local yOff = cursorEases[1][2].eased - scy

      yOff = math.min(yOff, ROW_HEIGHT * #optionRows - (sh - ROWS_TOP_Y))
      yOff = math.max(yOff, 0)
      yOff = -yOff

      for rowIndex, row in ipairs(optionRows) do
        local opt = optionRows[rowIndex]
        local y = ROWS_TOP_Y + (rowIndex - 1) * ROW_HEIGHT

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
        quad:skewx(0)

        if opt then
          if opt.layoutType == 'ShowAllInRow' then
            local x = 0
            for i, option in ipairs(opt.choices) do
              local width = opt.widths[i] + OPTION_GAP*2
              if i % 2 == 0 then
                quad:diffuse(0, 0, 0, 0.2)
                quad:skewx(-SKEW/width*ROW_HEIGHT)
                quad:zoomto(width, ROW_HEIGHT)
                quad:xy(LABEL_LEFT_X + x + width/2, y + yOff)
                quad:Draw()
              end
              x = x + width
            end
          else
          end
        end
      end

      for pn, cursor in ipairs(cursors) do
        local eases = cursorEases[pn]

        cursor:finishtweening()

        local color = getPlayerColor(pn)
        local x
        local y = ROWS_TOP_Y + (selectedRow[pn] - 1) * ROW_HEIGHT
        if optionRows[selectedRow[pn]] and optionRows[selectedRow[pn]].layoutType == 'ShowOneInRow' then
          x = LABEL_LEFT_X + (optionRows[selectedRow[pn]].widths[selectedOption[pn]] + OPTION_GAP*2)/2
        else
          x = LABEL_LEFT_X
          for i = 1, selectedOption[pn] do
            x = x + optionRows[selectedRow[pn]].widths[i] + OPTION_GAP*2
          end
          x = x - (optionRows[selectedRow[pn]].widths[selectedOption[pn]] + OPTION_GAP*2)/2
        end
        eases[1]:set(x) eases[2]:set(y)
        local offset = (pn % 2 * 2 - 1) * 4
        quad:xy(eases[1].eased + offset, eases[2].eased + yOff)
        eases[3]:set((optionRows[selectedRow[pn]].widths[selectedOption[pn]] + OPTION_GAP*2))
        quad:zoomto(eases[3].eased, ROW_HEIGHT)
        quad:diffuse(color:unpack())
        quad:skewx(-SKEW/eases[3].eased*ROW_HEIGHT)
        quad:Draw()
        quad:skewx(0)
      end

      for rowIndex, row in ipairs(optionRows) do
        local opt = optionRows[rowIndex]
        local y = ROWS_TOP_Y + (rowIndex - 1) * ROW_HEIGHT

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
            for i, option in ipairs(opt.choices) do
              local width = opt.widths[i] + OPTION_GAP*2
              local hovered =
                (selectedRow[1] == rowIndex and selectedOption[1] == i) or
                (selectedRow[2] == rowIndex and selectedOption[2] == i)
              for pn = 1, 2 do
                local selected = opt.selected[pn][i]
                if selected then
                  quad:zoomto(opt.widths[i] * 0.9, 1)
                  quad:xy(LABEL_LEFT_X + x + width/2, y + yOff + 10 * (pn%2*2-1))
                  quad:diffuse((hovered and rgb(1, 1, 1) or getPlayerColor(pn)):unpack())
                  quad:Draw()
                end
              end
              if hovered then
                optText:diffuse(1, 1, 1, 1)
              else
                optText:diffuse(0.8, 0.8, 0.8, 1)
              end
              optText:settext(option)
              optText:xy(LABEL_LEFT_X + x + width/2, y + yOff)
              optText:Draw()
              x = x + width
            end
          else
            -- temp while i figure out how 2p rendering for this should go
            -- or rather if it should i guess
            local pn = 1
            if opt.choices then
              local foundChoice = opt.actor:GetChildAt(4 + (pn - 1))
              for i, choice in ipairs(opt.choices) do
                local width = opt.widths[i] + OPTION_GAP*2
                if foundChoice and foundChoice.GetText and choice == foundChoice:GetText() then
                  if not opt.isExit then
                    opt.selected[pn][i] = not opt.underlines[pn][1]:GetHidden()
                  end
                  local hovered = 
                    (selectedRow[1] == rowIndex) or
                    (selectedRow[2] == rowIndex)
                  for pn = 1, 2 do
                    local selected = opt.selected[pn][i]
                    if selected then
                      quad:zoomto(opt.widths[i]*0.9, 1)
                      quad:xy(LABEL_LEFT_X + width * 0.5, y + yOff + 10 * (pn%2*2-1))
                      quad:diffuse((hovered and rgb(1, 1, 1) or getPlayerColor(pn)):unpack())
                      quad:Draw()
                    end
                  end
                  if hovered then
                    optText:diffuse(1, 1, 1, 1)
                  else
                    optText:diffuse(0.8, 0.8, 0.8, 1)
                  end
                  optText:settext(choice)
                  optText:xy(LABEL_LEFT_X + width*0.5, y + yOff)
                  optText:Draw()
                  break
                end
              end
            end
          end
        end
      end
    end

    scope.event:on('press', function(pn, btn)
      -- hacky workaround to esc being broken
      if optionsStack:top() and btn == 'Back' then
        print('Popping stack forcefully: ' .. optionsStack:pop())
        if not optionsStack:top() then
          SCREENMAN:SetNewScreen('ScreenSelectMusic')
        end
      end
    end)
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
    --local bg = ctx:Sprite('Graphics/_missing')
    --bg:scaletocover(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
  end),
  --header = gimmick.ActorScreen(function(self, ctx)
  --end),
  --footer = gimmick.ActorScreen(function(self, ctx)
  --end),

  unlockStack = function()
    stackLocked = false
  end,
  resetStack = function()
    if optionsStack:top() then
      print('Clearing options stack due to premature exit')
      optionsStack:clear()
    end
  end,

  NextScreen = function()
    if not stackLocked then
      print('Popping stack: ' .. optionsStack:pop())
      stackLocked = true
    end
    if optionsStack:top() then
      return 'ScreenPlayerOptions'
    else
      print('Options stack empty, leaving options menu')
      return 'ScreenBranchStage'
    end
  end,

  lines = options.LineProvider('ScreenPlayerOptions', function()
    local opts = optionsStack:top()
    if not opts then
      print('Initializing options stack')
      opts = 'root'
      optionsStack:push(opts)
    end
    local res = optionsTable[opts]
    if not res then
      print('Invalid options screen: ' .. opts)
      optionsStack:clear()
      opts = 'root'
      optionsStack:push(opts)
      res = optionsTable[opts]
    end
    return res
  end),

}