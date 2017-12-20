-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-13
-- Description: Manages the global UI for storage networks.

-- Constructs and returns the NetworkOverviewGUI
return function(BaseGUI)
  local NetworkOverviewGUI = {
    NeedsTicks = true,
    TicksBetweenUpdates = 60.0 * 5.0
  }
  setmetatable(NetworkOverviewGUI, {__index = BaseGUI})

  require "Utils/Strings"

  local LocalStrings = SE.Constants.Strings.Local

  -- AddCountToSlot( LuaGuiElement ) :: void
  -- Alright, this sucks, but I have yet to find a better way
  -- to add the shadow to the count
  local function AddCountToSlot(parent)
    local shadow_color = {r = 0.2, g = 0.2, b = 0.25}
    local vert_center = 14
    local label_style = "electric_usage_label_style"
    local font_style = "default-small-bold"
    local countStr = tostring(-1)

    -- Top-left shadow
    local tlShadow =
      parent.add(
      {
        type = "label",
        caption = countStr,
        style = label_style
      }
    )
    tlShadow.style.top_padding = vert_center - 1
    tlShadow.style.left_padding = 0
    tlShadow.style.font = font_style
    tlShadow.style.font_color = shadow_color

    -- Bottom-right shadow
    local brShadow =
      parent.add(
      {
        type = "label",
        caption = countStr,
        style = label_style
      }
    )
    brShadow.style.top_padding = vert_center + 1
    brShadow.style.left_padding = 2
    brShadow.style.font = font_style
    brShadow.style.font_color = shadow_color

    -- Foreground
    local numLabel =
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

    return {TLS = tlShadow, BRS = brShadow, Label = numLabel}
  end

  -- NewItemCell( LuaGuiElement ) :: ItemCell
  -- ItemCell :: { Cell, Slot, CountLabels :: { TLS, BRS, Label }, Label }
  local function NewItemCell(itemTable)
    local cellWidth = 275

    -- Create the item cell
    local itemCell =
      itemTable.add(
      {
        type = "flow",
        tooltip = "<Warning: Unused Item Cell>"
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
        item = nil,
        name = "slot",
        enabled = false,
        style = "se_slot_button_style"
      }
    )

    -- Add count
    local countLabels = AddCountToSlot(slot)

    -- Add the label
    local itemLabel =
      itemCell.add(
      {
        type = "label",
        name = "label",
        caption = "",
        style = "se_item_table_item_label"
      }
    )

    return {Cell = itemCell, Slot = slot, CountLabels = countLabels, Label = itemLabel}
  end

  -- NewItemCell( LuaGuiElement, ItemInfo ) :: void
  -- Update the tooltip, count, and icon to match the given item
  local function UpdateItemCell(itemCell, item)
    -- Get the item prototype
    local itemPrototype = game.item_prototypes[item.ID]

    -- Update tooltip
    itemCell.Cell.tooltip = ConcatStringWithLocalized(NumberToStringWithThousands(item.Count) .. "x ", itemPrototype.localised_name)

    -- Update the slot
    itemCell.Slot.elem_value = itemPrototype.name

    -- Update counts
    local countStr = NumberToStringWithSuffix(item.Count)
    itemCell.CountLabels.TLS.caption = countStr
    itemCell.CountLabels.BRS.caption = countStr
    itemCell.CountLabels.Label.caption = countStr

    -- Update label
    itemCell.Label.caption = itemPrototype.localised_name
  end

  -- DisplayItems( Table, ItemInfo ) :: void
  -- Shows the items in the table
  -- Where items = Map( itemName => count )
  local function DisplayItems(guiData, items)
    -- Create intermediate table for sorting
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

    -- Ensure item cells has been added
    guiData.ItemCells = guiData.ItemCells or {}

    -- Get new and old number of cells
    local newCellCount = #indexedItems
    local oldCellCount = #guiData.ItemCells

    -- Update existing cells
    local cellIndex = 1
    while cellIndex <= newCellCount do
      local itemCell = nil
      if cellIndex <= oldCellCount then
        -- Get the existing cell
        itemCell = guiData.ItemCells[cellIndex]
      else
        -- Create a new cell
        itemCell = NewItemCell(guiData.FrameData.ItemTable)
        guiData.ItemCells[#guiData.ItemCells + 1] = itemCell
      end

      -- Get the item
      local item = indexedItems[cellIndex]

      -- Update the item cell
      UpdateItemCell(itemCell, item)

      -- Move to next cell
      cellIndex = cellIndex + 1
    end

    -- Are there any unused cells?
    while cellIndex <= oldCellCount do
      -- Get the last cell
      local itemCell = guiData.ItemCells[#guiData.ItemCells]

      -- Destroy it
      itemCell.Cell.destroy()

      -- Remove from cells
      guiData.ItemCells[#guiData.ItemCells] = nil

      -- Increment index
      cellIndex = cellIndex + 1
    end
  end

  -- LoadNetworkContents( Table ) :: void
  -- Adds the contents of the network to the frame
  local function LoadNetworkContents(guiData)
    -- Get the network
    local network = SE.Networks.GetNetwork(guiData.NetworkIDs[guiData.FrameData.NetworkDropDown.selected_index])

    -- Query the network for the items
    local networkContents = SE.NetworkHandler.GetStorageContents(network)

    -- Extract capacity amounts
    local totalSlots = networkContents[SE.Constants.Strings.TotalSlots]
    local freeSlots = networkContents[SE.Constants.Strings.FreeSlots]

    -- Remove capacity amounts from item list
    networkContents[SE.Constants.Strings.TotalSlots] = nil
    networkContents[SE.Constants.Strings.FreeSlots] = nil

    -- Update capacity progress bar
    local capacityPercent = 0
    if (totalSlots ~= nil and totalSlots > 0 and freeSlots ~= nil) then
      capacityPercent = 1.0 - (freeSlots / totalSlots)
    end
    guiData.FrameData.Capacity.value = capacityPercent
    guiData.FrameData.Capacity.tooltip = ConcatStringWithLocalized(LocalStrings.NetCap, tostring(math.floor(capacityPercent * 1000) / 10) .. "%")

    DisplayItems(guiData, networkContents)
  end

  -- UpdateDropdownNetworks( Table )
  -- Sets the networks in the dropdown
  local function UpdateDropdownNetworks(guiData)
    -- Get network ids
    guiData.NetworkIDs = SE.Networks.GetNetworkIDs()

    local ddList = {}
    if (#guiData.NetworkIDs > 0) then
      -- Build dropdown list
      local idx = #guiData.NetworkIDs
      while idx > 0 do
        -- Get the next network ID
        local networkID = guiData.NetworkIDs[idx]

        -- Get the network
        local network = SE.Networks.GetNetwork(networkID)

        -- Ensure there are non-controller devices on the network
        if SE.NetworkHandler.EmptyEmptyExceptControllers(network) then
          -- Remove the empty network
          table.remove(guiData.NetworkIDs, idx)
        else
          -- Add to the dropdown list
          ddList[#ddList + 1] = ConcatStringWithLocalized(LocalStrings.NetworkID, "# " .. tostring(networkID))
        end

        -- Decrement index
        idx = idx - 1
      end
      -- Assign dropdown list
      guiData.FrameData.NetworkDropDown.items = ddList
      guiData.FrameData.NetworkDropDown.selected_index = 1

      -- Load the first network
      LoadNetworkContents(guiData)
    end
  end

  -- NewFrame( LuaGuiElement ) :: FrameData
  -- FrameData
  -- - ItemTable :: LuaGuiElement
  -- - NetworkDropDown :: LuaGuiElement
  -- - Capacity :: LuaGuiElement
  local function NewFrame(root)
    local width = 600
    local height = 450

    -- Add the frame
    local frame =
      root.add(
      {
        type = "frame",
        name = SE.Constants.Names.Gui.NetworkFrame,
        caption = LocalStrings.StorageNetwork
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
    header.style.column_alignments[1] = "top-right"

    -- Add dropdown to header
    local networkDropDown =
      header.add(
      {
        type = "drop-down",
        name = SE.Constants.Names.Gui.NetworkDropdown,
        items = {}
      }
    )

    -- Add the progress bar
    local progBar =
      header.add(
      {
        type = "progressbar",
        size = width,
        value = 0,
        tooltip = ""
      }
    )
    progBar.style.minimal_width = width

    -- Header horizontal line
    local h_hzline =
      header.add(
      {
        type = "progressbar",
        size = width,
        value = 1.0,
        style = "se_horizontal_line"
      }
    )
    h_hzline.style.minimal_width = width
    h_hzline.style.minimal_height = 2
    h_hzline.style.maximal_height = 2

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

    -- Add footer
    local footer =
      contents.add(
      {
        type = "table",
        name = "footer",
        colspan = 1
      }
    )
    footer.style.minimal_width = width
    footer.style.column_alignments[1] = "middle-right"

    -- Footer horizontal line
    local f_hzline =
      footer.add(
      {
        type = "progressbar",
        size = width,
        value = 1.0,
        style = "se_horizontal_line"
      }
    )
    f_hzline.style.minimal_width = width
    f_hzline.style.minimal_height = 2
    f_hzline.style.maximal_height = 2

    -- Add close button
    footer.add(
      {
        type = "button",
        caption = LocalStrings.Close,
        name = "se_network_overview_close"
      }
    )

    return {ItemTable = itemTable, NetworkDropDown = networkDropDown, Capacity = progBar}
  end

  -- @See BaseGui:OnShow
  function NetworkOverviewGUI:OnShow(player)
    -- Get root
    local root = player.gui[SE.Constants.Names.Gui.NetworkFrameRoot]

    -- Has frame?
    if (root[SE.Constants.Names.Gui.NetworkFrame] ~= nil) then
      -- Already open, close first
      NetworkOverviewGUI.OnClose(self, player)
    end

    -- Does the player have something else opened?
    if (player.opened ~= nil) then
      -- Player has something else open
      return false
    end

    -- Build the frame
    self.FrameData = NewFrame(root)

    -- Build dropdown list
    UpdateDropdownNetworks(self)

    -- Add tick info
    self.TickCount = 0

    return true
  end

  -- @See BaseGui:OnClose
  function NetworkOverviewGUI:OnClose(player)
    local root = player.gui[SE.Constants.Names.Gui.NetworkFrameRoot]
    local frame = root[SE.Constants.Names.Gui.NetworkFrame]
    if (frame ~= nil) then
      frame.destroy()
    end
  end

  -- @See BaseGui:OnPlayerChangedDropDown
  function NetworkOverviewGUI:OnPlayerChangedDropDown(player, element)
    LoadNetworkContents(self, self.NetworkIDs[element.selected_index])
  end

  -- @See BaseGUI:OnPlayerClicked
  function NetworkOverviewGUI:OnPlayerClicked(player, element)
    if (element ~= nil and element.name == "se_network_overview_close") then
      SE.GuiManager.CloseGui(player, NetworkOverviewGUI)
    end
  end

  -- @See BaseGui:OnTick
  function NetworkOverviewGUI:OnTick(player)
    if (self == nil or self.TickCount == nil) then
      -- Invalid data, close the gui
      NetworkOverviewGUI.OnClose(nil, player)
      return false
    end

    if (player.opened ~= nil) then
      -- Player has opened something else, close this
      NetworkOverviewGUI.OnClose(self, player)
      return false
    end

    -- Increment tick count
    self.TickCount = self.TickCount + 1

    -- Skip this tick?
    if (self.TickCount < NetworkOverviewGUI.TicksBetweenUpdates) then
      return true
    end
    self.TickCount = 0

    LoadNetworkContents(self)

    return true
  end

  return NetworkOverviewGUI
end
