local M = {}

---@param device InputDevice
local function isCtrlDown(device)
  return
    (inputs.rawInputs[device]['left ctrl'] or inputs.rawInputs[device]['right ctrl'])
    and not (inputs.rawInputs[device]['left alt'] or inputs.rawInputs[device]['right alt'])
    and not (inputs.rawInputs[device]['left shift'] or inputs.rawInputs[device]['right shift'])
end

local devtoolsOpen = false

local function walk(node, func, parent, depth)
  depth = depth or 0
  func(node, parent, depth)
  if node.GetChildren then
    for _, childNode in ipairs(node:GetChildren()) do
      walk(childNode, func, node, depth + 1)
    end
  end
end

---@param ctx Context
---@param scope Scope
function M.init(self, ctx, scope)
  local PADDING = 8
  local LEFT_PADDING = 16
  local TOOLS_HEIGHT = 350
  local NODE_HEIGHT = 16
  local zoom = 0.3
  local scroll = 0
  local treeHeight = 0

  local devtoolsOpenAux = scope.tick:aux()
  
  local scissor = ctx:Shader('Shaders/scissor.frag')

  local bitmapText = ctx:BitmapText(FONTS.monospace, '')
  bitmapText:zoom(zoom)
  bitmapText:shadowlength(0)
  bitmapText:align(0, 0)
  bitmapText:diffuse(1, 1, 1, 1)

  local quad = ctx:Quad()

  local rootNode = nil
  ---@alias NodeData { open: boolean, parent: Actor?, depth: number }
  ---@type table<string, NodeData>
  local nodeData = {}
  local flatNodes = {}
  local selectedNode = nil

  local blur = gimmick.common.blurMask(ctx, scope, function()
    return function()
      local yoff = (1 - devtoolsOpenAux.value) * -TOOLS_HEIGHT
      
      quad:diffuse(1, 0.5, 0.45, 1)
      quad:xywh(scx, TOOLS_HEIGHT/2 + yoff, sw, TOOLS_HEIGHT)
      quad:Draw()
    end
  end, 30)

  ---@return NodeData
  local function getNode(node)
    local str = tostring(node)
    nodeData[str] = nodeData[str] or {
      open = false,
      depth = 0,
    }
    return nodeData[str]
  end

  event:on('keypress', function(device, key)
    if device ~= InputDevice.Key then return end

    if key == '8' and isCtrlDown(device) then
      devtoolsOpen = not devtoolsOpen
      SCREENMAN:SetInputMode(devtoolsOpen and 1 or 0)
      devtoolsOpenAux:ease(0, 0.3, devtoolsOpen and outQuad or inQuad, devtoolsOpen and 1 or 0)
      return true
    end

    if devtoolsOpen then
      if key == 'down' or key == 'up' then
        local delta = 1
        if key == 'up' then delta = -1 end
        local i
        for i2, node in ipairs(flatNodes) do
          if selectedNode == node then
            i = i2
            break
          end
        end
        if i then selectedNode = flatNodes[i + delta] or selectedNode end
      end
      if key == 'enter' then
        getNode(selectedNode).open = not getNode(selectedNode).open
        if not getNode(selectedNode).open then
          walk(selectedNode, function(node) getNode(node).open = false end)
        end
      end
      if key == 'h' then
        if selectedNode then
          selectedNode:hidden(selectedNode:GetHidden() and 0 or 1)
        end
      end
      if key == 'r' then
        _SelectedNode = selectedNode
        print('Set global _SelectedNode to the highlighted node')
      end
      return true
    end
  end)

  return function(dt)
    blur()

    local yoff = (1 - devtoolsOpenAux.value) * -(TOOLS_HEIGHT + PADDING*2)

    if devtoolsOpenAux.value > 0.01 then
      rootNode = SCREENMAN:GetTopScreen()

      flatNodes = {}
      local selectedExists = false
      walk(rootNode, function(node, parent, depth)
        local data = getNode(node)
        data.parent = parent
        data.depth = depth
        if node == selectedNode then
          selectedExists = true
        end
        if (not data.parent) or getNode(data.parent).open then
          table.insert(flatNodes, node)
        end
      end)
      if not selectedExists then
        selectedNode = rootNode
      end
      
      --[[local tailNode = selectedNode
      while tailNode do
        if not nodeData[tailNode] then break end
        tailNode = nodeData[tailNode].parent
        if not nodeData[tailNode] then break end
        nodeData[tailNode].open = true
      end]]

      bitmapText:SetShader(actorgen.Proxy.getRaw(scissor))
      scissor:uniform2f('res', dw, dh)
      scissor:uniform1f('bottom', 1 - (TOOLS_HEIGHT + yoff) / sh)

      quad:xywh(sw/2, TOOLS_HEIGHT/2 + yoff, sw, TOOLS_HEIGHT)
      quad:diffuse(0, 0, 0, 0.7)
      quad:Draw()

      local y = PADDING

      for _, node in ipairs(flatNodes) do
        if selectedNode == node then
          scroll = clamp(y - TOOLS_HEIGHT/2, 0, math.max(treeHeight - TOOLS_HEIGHT + PADDING, 0))
        end

        y = y + NODE_HEIGHT
      end
      treeHeight = y

      y = PADDING

      for _, node in ipairs(flatNodes) do
        local data = getNode(node)

        if selectedNode == node then
          quad:diffuse(1, 1, 1, 0.2)
          quad:xywh(sw/2, y + NODE_HEIGHT/2 + yoff - scroll, sw, NODE_HEIGHT)
          quad:Draw()
        end

        if node:GetHidden() then
          bitmapText:diffuse(0.7, 0.7, 0.7, 1)
        else
          bitmapText:diffuse(1, 1, 1, 1)
        end
        bitmapText:settext(actorToString(node, true))
        bitmapText:xy(LEFT_PADDING + data.depth * 10 + 16, y + yoff - scroll)
        bitmapText:Draw()
        if node.GetChildren then
          bitmapText:diffuse(0.7, 0.7, 0.7, 1)
          bitmapText:settext(data.open and 'v' or '>')
          bitmapText:xy(LEFT_PADDING + data.depth * 10, y + yoff - scroll)
          bitmapText:Draw()
        end

        y = y + NODE_HEIGHT
      end
    end
  end
end

return M