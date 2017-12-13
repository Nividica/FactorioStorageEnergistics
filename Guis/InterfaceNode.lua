-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description:

return function(BaseGUI)
  local InterfaceNodeGUI = {}
  setmetatable(InterfaceNodeGUI, {__index = BaseGUI})

  function InterfaceNodeGUI.OnShow(player, data)
    -- Get the network node
    local node = data.Node

    -- Get root
    local root = player.gui[SE.Constants.Names.Gui.InterfaceFrameRoot]

    -- Has frame?
    local frame = root[SE.Constants.Names.Gui.InterfaceFrame]
    if (frame ~= nil) then
      -- Already open
      return
    end

    -- Add the frame
    frame =
      root.add(
      {
        type = "frame",
        name = SE.Constants.Names.Gui.InterfaceFrame,
        caption = "Energistics request" -- Make localized
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
  end

  function InterfaceNodeGUI.OnClose(player, data)
    local root = player.gui[SE.Constants.Names.Gui.InterfaceFrameRoot]
    local frame = root[SE.Constants.Names.Gui.InterfaceFrame]
    if (frame ~= nil) then
      frame.destroy()
    end
  end

  -- Player changed a gui filter
  function InterfaceNodeGUI.OnPlayerChangedSelectionElement(player, element, data)
    -- Get the handler and node
    local handler = data.Handler
    local node = data.Node

    -- Get the index of the changed element
    local index = tonumber(string.sub(element.name, 1 + string.len(SE.Constants.Names.Gui.InterfaceItemSelectionElement)))

    -- Set the filter
    node.RequestFilters[index] = element.elem_value

    -- Recalc request amounts
    handler.RecalculateRequestedAmounts(node)
  end

  return InterfaceNodeGUI
end
