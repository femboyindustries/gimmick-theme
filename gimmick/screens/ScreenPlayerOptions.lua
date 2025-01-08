local options = require 'gimmick.options'
local stack   = require 'gimmick.stack'
local easable = require 'gimmick.lib.easable'

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
    ---@type ActorFrame[]
    local optionRows = {}

    ---@type ActorFrame
    local cursorP1
    ---@type ActorFrame
    local cursorP2

    local cursorEases = {}
    for pn = 1, 2 do
      cursorEases[pn] = {scope.tick:easable(0, 25), scope.tick:easable(0, 25), scope.tick:easable(0, 25)}
    end

    local quad = ctx:Quad()
    local text = ctx:BitmapText(FONTS.sans_serif, '')
    text:halign(1)
    text:shadowlength(0)
    text:zoom(0.3)

    self:SetDrawFunction(function()
      if drawOverlay then drawOverlay() end
    end)

    optionsFrameDrawfunc = function(frame)
      if firstFrame then
        local sprHightlightP1 = frame(2)
        local sprHightlightP2 = frame(3)

        cursorP1 = frame(4)
        cursorP2 = frame(5)

        CursorP1 = cursorP1

        local optIndex = 1
        while not frame(6 + optIndex - 1).GetText do
          local row = frame(6 + optIndex - 1)
          optionRows[optIndex] = row
          print(row:GetChildAt(0):GetChildAt(3))
          
          optIndex = optIndex + 1
        end

        -- despite both having Change fired on them, these are fired regardless
        -- of if P1 or P2 moves
        sprHightlightP1:addcommand('Change', function()
          print('something just happened')
          print(cursorP1:GetX(), cursorP1:GetY())
        end)

        firstFrame = false
      end

      for pn, cursor in ipairs({cursorP1, cursorP2}) do
        local eases = cursorEases[pn]

        cursor:finishtweening()
        local color = pn == 1 and rgb(1, 0.3, 0.4) or rgb(0.2, 0.3, 1)
        local x, y = cursor:GetX(), cursor:GetY()
        eases[1]:set(x) eases[2]:set(y)
        quad:xy(eases[1].eased, eases[2].eased)
        local zoomX = cursor(1):GetZoomX()
        local frameWidth = cursor(2):GetWidth()
        local barWidth = frameWidth * zoomX
        eases[3]:set(barWidth)
        quad:zoomto(eases[3].eased + 16, 20)
        quad:diffuse(color:unpack())
        quad:skewx(-0.4)
        quad:Draw()
      end

      for _, row in ipairs(optionRows) do
        local rowFrame = row:GetChildAt(0) --[[@as ActorFrame]]
        local title = rowFrame(4) --[[@as BitmapText]]
        --[[text:settext(title:GetText())
        text:xy(rowFrame:GetX() + title:GetX(), rowFrame:GetY() + title:GetY())
        text:diffuse(title:getdiffuse())
        text:Draw()]]
        --for i = 5, rowFrame:GetNumChildren() do
        --  rowFrame(i):Draw()
        --end
        rowFrame:Draw()
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