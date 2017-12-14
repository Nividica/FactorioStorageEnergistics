-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-13
-- Description:

-- Dropdown listing all networks, ID = circuit network id
-- Progress bar showing capacity
-- Grid showing item counts, sorted by amount? or by item id?
-- Close button [x]? or [Close]?
-- Are tabs an option? If so add members grid
return function(BaseGUI)
  local NetworkOverviewGUI = {
    NeedsTicks = true
  }
  setmetatable(NetworkOverviewGUI, {__index = BaseGUI})

  function NetworkOverviewGUI.OnShow(player, data)
    -- Get root
    local root = player.gui[SE.Constants.Names.Gui.NetworkFrameRoot]

    -- Has frame?
    local frame = root[SE.Constants.Names.Gui.NetworkFrame]
    if (frame ~= nil) then
      -- Already open
      return
    end

    -- Add the frame
    frame =
      root.add(
      {
        type = "frame",
        name = SE.Constants.Names.Gui.NetworkFrame,
        caption = "Storage Network" -- TODO: Make localized
      }
    )
    frame.style.title_bottom_padding = 6

    -- Get network ids
    data.NetworkIDs = SE.Networks.GetNetworkIDs()

    -- Build dropdown list
    local ddItems = {}
    for idx, networkID in ipairs(data.NetworkIDs) do
      ddItems[#ddItems + 1] = "Network #" .. tostring(networkID)
    end

    -- Add dropdown
    frame.add(
      {
        type = "drop-down",
        name = SE.Constants.Names.Gui.NetworkDropdown,
        items = ddItems,
        selected_index = 1
      }
    )
  end

  function NetworkOverviewGUI.OnClose(player, data)
    local root = player.gui[SE.Constants.Names.Gui.NetworkFrameRoot]
    local frame = root[SE.Constants.Names.Gui.NetworkFrame]
    if (frame ~= nil) then
      frame.destroy()
    end
  end

  function NetworkOverviewGUI.OnPlayerChangedDropDown(player, element, data)
    player.print("Element changed " .. tostring(data.NetworkIDs[element.selected_index]))
  end

  return NetworkOverviewGUI
end
