-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/26/2017
-- Description: Controller node

return function(BaseHandler)
  local ControllerNode = {
    HandlerName = SE.Constants.Names.NodeHandlers.Controller,
    Type = SE.Constants.NodeTypes.Controller
  }
  setmetatable(ControllerNode, {__index = BaseHandler})

  local function GetControllerGUIRoot(player)
    return player.gui[SE.Constants.Names.Gui.ControllerFrameRoot]
  end

  local function GetControllerGUIFrame(root)
    return root[SE.Constants.Names.Gui.ControllerFrame]
  end

  -- TODO Integrate with Network View gui
  local function ShowControllerGUI(node, root)
    if (GetControllerGUIFrame(root) ~= nil) then
      -- GUI already shown
      return
    end
    -- Add the frame
    local frame =
      root.add(
      {
        type = "frame",
        name = SE.Constants.Names.Gui.ControllerFrame,
        caption = "Storage Network" -- TODO: Make localized
      }
    )
    frame.style.title_bottom_padding = 6

    -- Add read only checkbox
    frame.add(
      {
        type = "checkbox",
        name = SE.Constants.Names.Gui.StorageChestReadOnlyCheckbox,
        state = (node.ReadOnlyMode == true),
        caption = "Test",
        tooltip = "Testing"
      }
    )
  end

  function ControllerNode.NewNode(entity)
    return ControllerNode.EnsureStructure(BaseHandler.NewNode(entity))
  end

  function ControllerNode:OnPlayerOpenedNode(player)
    -- Close the default gui
    player.opened = nil

    -- Show the custom gui
    ShowControllerGUI(self, GetControllerGUIRoot(player))
  end

  function ControllerNode:EnsureStructure()
    BaseHandler.EnsureStructure(self)
    self.HandlerName = ControllerNode.HandlerName
    return self
  end

  return ControllerNode
end
