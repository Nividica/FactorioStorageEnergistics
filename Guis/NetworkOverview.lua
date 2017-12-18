-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-13
-- Description:

-- Dropdown listing all networks, ID = circuit network id
return function(BaseGUI)
  local NetworkOverviewGUI = {
    NeedsTicks = true,
    TicksBetweenUpdates = 60 * 5
  }
  setmetatable(NetworkOverviewGUI, {__index = BaseGUI})

  require "Utils/Strings"

  -- Alright, this sucks, but I have yet to find a better way
  local function AddCountToSlot(parent, count)
    local shadow_color = {r = 0.2, g = 0.2, b = 0.25}
    local vert_center = 14
    local label_style = "electric_usage_label_style"
    local font_style = "default-small-bold"
    local countStr = NumberToStringWithSuffix(count)

    -- Top-left shadow
    local numLabel =
      parent.add(
      {
        type = "label",
        caption = countStr,
        style = label_style
      }
    )
    numLabel.style.top_padding = vert_center - 1
    numLabel.style.left_padding = 0
    numLabel.style.font = font_style
    numLabel.style.font_color = shadow_color

    -- Bottom-right shadow
    numLabel =
      parent.add(
      {
        type = "label",
        caption = countStr,
        style = label_style
      }
    )
    numLabel.style.top_padding = vert_center + 1
    numLabel.style.left_padding = 2
    numLabel.style.font = font_style
    numLabel.style.font_color = shadow_color

    -- Foreground
    numLabel =
      parent.add(
      {
        type = "label",
        caption = countStr,
        style = label_style
      }
    )
    numLabel.style.top_padding = vert_center
    numLabel.style.left_padding = 1
    numLabel.style.font = font_style
    numLabel.style.font_color = {r = 1, g = 1, b = 1}
  end

  -- Shows the items in the table
  -- Where items = Map( itemName => count )
  local function DisplayItems(itemTable, items)
    local cellWidth = 275

    -- Clear the existing table
    itemTable.clear()

    -- Create intermediate table
    local indexedItems = {}
    for itemID, count in pairs(items) do
      indexedItems[#indexedItems + 1] = {ID = itemID, Count = count}
    end

    -- Sort the items
    table.sort(
      indexedItems,
      function(a, b)
        return a.Count > b.Count
      end
    )

    -- Create slots
    for _, item in ipairs(indexedItems) do
      -- Get the prototype
      local itemPrototype = game.item_prototypes[item.ID]

      -- Add the cell
      local itemCell =
        itemTable.add(
        {
          type = "flow",
          name = "item_cell_" .. itemPrototype.name,
          tooltip = NumberToStringWithThousands(item.Count) .. "x " .. itemPrototype.name
        }
      )
      itemCell.style.minimal_width = cellWidth
      itemCell.style.maximal_width = cellWidth

      -- Add the item slot
      local slot =
        itemCell.add(
        {
          type = "choose-elem-button",
          elem_type = "item",
          item = itemPrototype.name,
          enabled = false,
          style = "se_slot_button_style"
        }
      )

      -- Add count
      AddCountToSlot(slot, item.Count)

      -- Add the label
      local itemLabel =
        itemCell.add(
        {
          type = "label",
          caption = itemPrototype.localised_name,
          style = "se_item_table_item_label"
        }
      )
    end
  end

  -- Adds the contents of the network to the frame
  local function LoadNetworkContents(guiData)
    -- Get the network
    local network = SE.Networks.GetNetwork(guiData.NetworkIDs[guiData.FrameData.NetworkDropDown.selected_index])

    -- Query the network for the items
    local networkContents = SE.NetworkHandler.GetStorageContents(network)

    -- Clear totals TODO: Use totals
    networkContents[SE.Constants.Strings.TotalSlots] = nil
    networkContents[SE.Constants.Strings.FreeSlots] = nil

    DisplayItems(guiData.FrameData.ItemTable, networkContents)
  end

  -- Sets the networks in the dropdown
  local function UpdateDropdownNetworks(guiData)
    -- Get network ids
    guiData.NetworkIDs = SE.Networks.GetNetworkIDs()

    local ddList = {}
    if (#guiData.NetworkIDs > 0) then
      -- Build dropdown list
      for _, networkID in ipairs(guiData.NetworkIDs) do
        ddList[#ddList + 1] = "Network #" .. tostring(networkID)
      end
      -- Assign dropdown list
      guiData.FrameData.NetworkDropDown.items = ddList
      guiData.FrameData.NetworkDropDown.selected_index = 1

      -- Load the first network
      LoadNetworkContents(guiData)
    end
  end

  -- Returns FrameData {
  -- ItemTable
  -- NetworkDropDown
  -- }
  local function BuildFrame(root)
    local width = 600
    local height = 450

    -- Add the frame
    local frame =
      root.add(
      {
        type = "frame",
        name = SE.Constants.Names.Gui.NetworkFrame,
        caption = "Storage Network" -- TODO: Make localized
      }
    )
    frame.style.title_bottom_padding = 10

    -- Add the contents table
    local contents =
      frame.add(
      {
        type = "table",
        name = "contents",
        colspan = 1
      }
    )

    -- Add header
    local header =
      contents.add(
      {
        type = "table",
        name = "header",
        colspan = 1
      }
    )
    header.style.minimal_width = width
    header.style.bottom_padding = 10
    header.style.column_alignments[1] = "top-right" -- Seems to have no effect

    -- Add dropdown to header
    local networkDropDown =
      header.add(
      {
        type = "drop-down",
        name = SE.Constants.Names.Gui.NetworkDropdown,
        items = {}
      }
    )

    -- Add scroll pane
    local scrollWrapper =
      contents.add(
      {
        type = "scroll-pane",
        name = "scroll_wrapper"
      }
    )
    scrollWrapper.vertical_scroll_policy = "always"
    scrollWrapper.style.minimal_width = width
    scrollWrapper.style.maximal_width = width
    scrollWrapper.style.minimal_height = height
    scrollWrapper.style.maximal_height = height

    -- Add item table
    local itemTable =
      scrollWrapper.add(
      {
        type = "table",
        name = "item_table",
        colspan = 2
      }
    )

    return {ItemTable = itemTable, NetworkDropDown = networkDropDown}
  end

  function NetworkOverviewGUI.OnShow(player, data)
    -- Get root
    local root = player.gui[SE.Constants.Names.Gui.NetworkFrameRoot]

    -- Has frame?
    if (root[SE.Constants.Names.Gui.NetworkFrame] ~= nil) then
      -- Already open
      return
    end

    -- Build the frame
    data.FrameData = BuildFrame(root)

    -- Build dropdown list
    UpdateDropdownNetworks(data)

    -- Add tick info
    data.TickCount = 0
  end

  function NetworkOverviewGUI.OnClose(player, data)
    local root = player.gui[SE.Constants.Names.Gui.NetworkFrameRoot]
    local frame = root[SE.Constants.Names.Gui.NetworkFrame]
    if (frame ~= nil) then
      frame.destroy()
    end
  end

  function NetworkOverviewGUI.OnPlayerChangedDropDown(player, element, data)
    LoadNetworkContents(data, data.NetworkIDs[element.selected_index])
  end

  function NetworkOverviewGUI.OnTick(player, data)
    -- Increment tick count
    data.TickCount = data.TickCount + 1

    -- Skip this tick?
    if (data.TickCount < NetworkOverviewGUI.TicksBetweenUpdates) then
      return
    end
    data.TickCount = 0

    player.print("NetworkOverview Ticked")
    LoadNetworkContents(data)
  end

  return NetworkOverviewGUI
end
