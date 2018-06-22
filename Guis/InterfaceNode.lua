-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description:

-- Constructs and returns the InterfaceNodeGUI object
return function(BaseGUI)
  local InterfaceNodeGUI = {}
  setmetatable(InterfaceNodeGUI, {__index = BaseGUI})

  require "Utils/GUIHelper"

  -- Removes the selection highlight
  local function RemoveSelection(self)
    if (self.SelectedIndex > 0) then
      local prevSelectedSlot = self.Slots[self.SelectedIndex]
      prevSelectedSlot.style = "slot_button"
      prevSelectedSlot.locked = (self.Node.RequestFilters[self.SelectedIndex] ~= nil)
      self.SelectedIndex = 0
    end
  end

  -- Sets the selection highlight
  local function SetSelection(self, index)
    RemoveSelection(self)

    if (self.Node.RequestFilters[index] ~= nil) then
      self.SelectedIndex = index
      local slot = self.Slots[index]
      slot.style = "selected_slot_button"
      slot.locked = false
    end
  end

  -- @See BaseGUI:OnShow
  function InterfaceNodeGUI:OnShow(player)
    self.SelectedIndex = 0

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
        column_count = 5
      }
    )

    -- Add selection slots
    self.Slots = {}
    for idx = 1, 10 do
      -- Add slot
      self.Slots[idx] =
        body.add(
        {
          type = "choose-elem-button",
          name = SE.Constants.Names.Gui.InterfaceItemSelectionElement .. tostring(idx),
          elem_type = "item",
          item = self.Node.RequestFilters[idx],
          style = (idx == self.SelectedIndex) and "selected_slot_button" or "slot_button"
        }
      )

      -- Add count
      AddCountToSlot(self.Slots[idx], self.Node.RequestedItemAmounts[idx])
    end

    -- Slots can only be locked after being added
    for idx = 1, 10 do
      -- Lock a slot if it has a filter and it is not the selected slot
      self.Slots[idx].locked = (self.Node.RequestFilters[idx] ~= nil) and (idx ~= self.SelectedIndex)
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

    -- Select button
    SetSelection(self, index)
  end

  -- @See BaseGUI:OnPlayerClicked
  function InterfaceNodeGUI:OnPlayerClicked(player, element)
    -- Is the clicked element a select element button?
    if (element.type == "choose-elem-button") then
      -- Get the index of the slot
      local clickedIdx = tonumber(string.sub(element.name, 1 + string.len(SE.Constants.Names.Gui.InterfaceItemSelectionElement)))

      -- Clicked slot is not selected?
      if (clickedIdx ~= self.SelectedIndex) then
        -- Does the clicked slot have a filter?
        if (self.Node.RequestFilters[clickedIdx] ~= nil) then
          -- Select the slot
          SetSelection(self, clickedIdx)
        end

      -- Do things with slider!
      end
    end
  end

  return InterfaceNodeGUI
end
