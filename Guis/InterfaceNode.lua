-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description:

-- Constructs and returns the InterfaceNodeGUI object
return function(BaseGUI)
  local InterfaceNodeGUI = {}
  setmetatable(InterfaceNodeGUI, {__index = BaseGUI})

  -- @See BaseGUI:OnShow
  function InterfaceNodeGUI:OnShow(player)
    -- Get the network node
    local node = self.Node

    -- Get root
    local root = player.gui[SE.Constants.Names.Gui.InterfaceFrameRoot]

    -- Has frame?
    local frame = root[SE.Constants.Names.Gui.InterfaceFrame]
    if (frame ~= nil) then
      -- Already open
      return false
    end

    -- Add the frame
    frame =
      root.add(
      {
        type = "frame",
        name = SE.Constants.Names.Gui.InterfaceFrame,
        caption = SE.Constants.Strings.Local.InterfaceSettings
      }
    )
    frame.style.title_bottom_padding = 6

    -- Create the inner body
    local body =
      frame.add(
      {
        type = "table",
        name = "body",
        colspan = 5
      }
    )

    -- Add selection buttons
    for idx = 1, 10 do
      body.add(
        {
          type = "choose-elem-button",
          name = SE.Constants.Names.Gui.InterfaceItemSelectionElement .. tostring(idx),
          elem_type = "item",
          item = node.RequestFilters[idx]
        }
      )
    end

    return true
  end

  -- @See BaseGUI:OnClose
  function InterfaceNodeGUI:OnClose(player)
    local root = player.gui[SE.Constants.Names.Gui.InterfaceFrameRoot]
    local frame = root[SE.Constants.Names.Gui.InterfaceFrame]
    if (frame ~= nil) then
      frame.destroy()
    end
  end

  -- @See BaseGUI:OnPlayerChangedSelectionElement
  function InterfaceNodeGUI:OnPlayerChangedSelectionElement(player, element)
    -- Get the index of the changed element
    local index = tonumber(string.sub(element.name, 1 + string.len(SE.Constants.Names.Gui.InterfaceItemSelectionElement)))

    -- Set the filter
    self.Node.RequestFilters[index] = element.elem_value

    -- Recalc request amounts
    self.Handler.RecalculateRequestedAmounts(self.Node)
  end

  return InterfaceNodeGUI
end
