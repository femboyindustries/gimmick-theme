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
        Name = 'ShowAllInRow SelectOne',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectOne',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectOne',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectOne',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectMultiple',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectMultiple',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectMultiple',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectMultiple',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectNone',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectNone',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectNone',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectNone',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectOne',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectOne',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectOne',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectOne',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectMultiple',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectMultiple',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectMultiple',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectMultiple',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectNone',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectNone',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectNone',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectNone',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectOne',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectOne',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectOne',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectOne',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectMultiple',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectMultiple',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectMultiple',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectMultiple',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectNone',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectNone',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectNone',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectNone',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectOne',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectOne',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectOne',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectOne',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectMultiple',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectMultiple',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectMultiple',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectMultiple',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectNone',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectNone',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectNone',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectNone',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectOne',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectOne',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectOne',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectOne',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectMultiple',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectMultiple',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectMultiple',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectMultiple',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectNone',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectNone',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectNone',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectNone',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectOne',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectOne',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectOne',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectOne',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function(self, selected) selected[1] = true end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectMultiple',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectMultiple',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectMultiple',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectMultiple',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowAllInRow SelectNone',
        LayoutType = 'ShowAllInRow',
        SelectType = 'SelectNone',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
    {
      type = 'lua',
      optionRow = {
        Name = 'ShowOneInRow SelectNone',
        LayoutType = 'ShowOneInRow',
        SelectType = 'SelectNone',
        Choices = { 'A', 'B', 'C', 'D', 'E', 'F', },
        LoadSelections = function() end,
        SaveSelections = function() end,
      },
    },
  },
}

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
    ---@type {actor: ActorFrame, layoutType: LayoutType, name: string, choices: string[]?}[]
    local optionRows = {}

    ---@type ActorFrame[]
    local cursors = {}

    local selectedRow = { 1, 1 }
    local selectedOption = { 1, 1 }

    local cursorEases = {}
    for pn = 1, 2 do
      cursorEases[pn] = {scope.tick:easable(0, 25), scope.tick:easable(0, 25), scope.tick:easable(0, 25)}
    end

    local LABEL_LEFT_X = 230
    local LABEL_MARGIN = 20
    local OPTION_GAP = 64
    local ROWS_TOP_Y = 32
    local ROW_HEIGHT = 32

    local quad = ctx:Quad()
    local text = ctx:BitmapText(FONTS.sans_serif, '')
    text:halign(1)
    text:shadowlength(0)
    text:zoom(0.25)
    local optText = ctx:BitmapText(FONTS.sans_serif, '')
    optText:shadowlength(0)
    optText:zoom(0.3)

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

          optionRows[optIndex] = {
            actor = row,
            layoutType = isShowAllInRow and 'ShowAllInRow' or 'ShowOneInRow',
            name = luaDef and luaDef.Name or row:GetChildAt(3):GetText(),
            choices = luaDef and luaDef.Choices,
            selected = {},
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

      local yOff = 0

      yOff = math.max(cursorEases[1][2].eased - scy, 0)
      yOff = math.min(yOff, ROW_HEIGHT * #optionRows - (sh - ROWS_TOP_Y))
      yOff = -yOff

      for pn, cursor in ipairs(cursors) do
        local eases = cursorEases[pn]

        cursor:finishtweening()

        local color = pn == 1 and rgb(1, 0.3, 0.4) or rgb(0.2, 0.3, 1)
        local x, y = LABEL_LEFT_X + LABEL_MARGIN + (selectedOption[pn] - 1 + 0.5) * OPTION_GAP, ROWS_TOP_Y + (selectedRow[pn] - 1) * ROW_HEIGHT
        if optionRows[selectedRow[pn]] and optionRows[selectedRow[pn]].layoutType == 'ShowOneInRow' then
          x = LABEL_LEFT_X + LABEL_MARGIN + OPTION_GAP*0.5
        end
        eases[1]:set(x) eases[2]:set(y)
        quad:xy(eases[1].eased, eases[2].eased + yOff)
        local zoomX = cursor(1):GetZoomX()
        local frameWidth = cursor(2):GetWidth()
        local barWidth = frameWidth * zoomX
        eases[3]:set(barWidth)
        quad:zoomto(eases[3].eased + 16, 20)
        quad:diffuse(color:alpha(0.5):unpack())
        quad:skewx(-0.4)
        quad:Draw()
      end

      for i, row in ipairs(optionRows) do
        --local rowFrame = row:GetChildAt(0) --[[@as ActorFrame]]
        --local title = rowFrame(4) --[[@as BitmapText]]
        --[[text:settext(title:GetText())
        text:xy(rowFrame:GetX() + title:GetX(), rowFrame:GetY() + title:GetY())
        text:diffuse(title:getdiffuse())
        text:Draw()]]
        --for i = 5, rowFrame:GetNumChildren() do
        --  rowFrame(i):Draw()
        --end
        --rowFrame:Draw()

        local opt = optionRows[i]
        local y = ROWS_TOP_Y + (i - 1) * ROW_HEIGHT

        if opt then
          text:settext(opt.name)
          text:xy(LABEL_LEFT_X, y + yOff)
          text:Draw()

          if opt.layoutType == 'ShowAllInRow' then
            for i, option in ipairs(opt.choices) do
              optText:settext(option)
              optText:xy(LABEL_LEFT_X + LABEL_MARGIN + (i - 1 + 0.5) * OPTION_GAP, y + yOff)
              optText:Draw()
            end
          else
            local pn = 1
            if opt.choices then
              local foundChoice = opt.actor:GetChildAt(4 + (pn - 1))
              for i, choice in ipairs(opt.choices) do
                if foundChoice and foundChoice.GetText and choice == foundChoice:GetText() then
                  optText:settext(choice)
                  optText:xy(LABEL_LEFT_X + LABEL_MARGIN + OPTION_GAP*0.5, y + yOff)
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