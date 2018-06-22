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
      -- Set selected index
      self.SelectedIndex = index

      -- Get the slot
      local slot = self.Slots[index]

      -- Set highlighted and unlocked
      slot.style = "selected_slot_button"
      slot.locked = false
    end
  end

  local function SetFilter(self, index, filter)
    -- Set filter
    self.Node.RequestFilters[index] = filter

    local slot = self.Slots[index]
    if (filter ~= nil) then
      -- Update slot
      slot.elem_value = filter.Item
      UpdateSlotCount(slot, filter.Amount)
    else
      -- Clear slot
      slot.elem_value = nil
      UpdateSlotCount(slot, nil)

      -- If this slot was selected, remove selection
      if (index == self.SelectedIndex) then
        RemoveSelection(self)
      else
        -- Ensure empty slots are unlocked
        slot.locked = false
      end
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
    local filters = self.Node.RequestFilters
    for idx = 1, 10 do
      -- Add slot
      self.Slots[idx] =
        body.add(
        {
          type = "choose-elem-button",
          name = SE.Constants.Names.Gui.InterfaceItemSelectionElement .. tostring(idx),
          elem_type = "item",
          item = (filters[idx] ~= nil and filters[idx].Item) or nil,
          style = (idx == self.SelectedIndex) and "selected_slot_button" or "slot_button"
        }
      )

      -- Add count
      AddCountToSlot(self.Slots[idx], (filters[idx] ~= nil and filters[idx].Amount) or nil)
    end

    -- Slots can only be locked after being added
    for idx = 1, 10 do
      -- Lock a slot if it has a filter and it is not the selected slot
      self.Slots[idx].locked = (filters[idx] ~= nil) and (idx ~= self.SelectedIndex)
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

    if (element.elem_value ~= nil) then
      -- Set filter
      SetFilter(self, index, {Item = element.elem_value, Amount = 1})

      -- Select button
      SetSelection(self, index)
    else
      -- Clear filter
      SetFilter(self, index, nil)
    end
  end

  -- @See BaseGUI:OnPlayerClicked
  function InterfaceNodeGUI:OnPlayerClicked(player, event)
    local element = event.element

    -- Is the clicked element a select element button?
    if (element.type == "choose-elem-button") then
      -- Get the index of the slot
      local clickedIdx = tonumber(string.sub(element.name, 1 + string.len(SE.Constants.Names.Gui.InterfaceItemSelectionElement)))

      -- Clicked slot is not selected?
      if (clickedIdx ~= self.SelectedIndex) then
        -- Does the clicked slot have a filter?
        if (self.Node.RequestFilters[clickedIdx] ~= nil) then
          -- Was the click a right click?
          if (event.button == defines.mouse_button_type.right) then
            -- Clear the slot
            SetFilter(self, clickedIdx, nil)
          else
            -- Select the slot
            SetSelection(self, clickedIdx)
          end
        end

      -- Do things with slider!
      end
    end
  end

  return InterfaceNodeGUI
end
