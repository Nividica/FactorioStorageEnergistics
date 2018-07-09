-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description:

-- Constructs and returns the InterfaceNodeGUI object
return function(BaseGUI)
  local InterfaceNodeGUI = {}
  setmetatable(InterfaceNodeGUI, {__index = BaseGUI})

  require "Utils/GUIHelper"

  local SliderSteps = {}
  for sldIdx = 1, 9 do
    -- 1s
    SliderSteps[sldIdx] = sldIdx
    -- 10s
    SliderSteps[sldIdx + 9] = sldIdx * 10
    -- 100s
    SliderSteps[sldIdx + 18] = sldIdx * 100
    -- 1000s
    SliderSteps[sldIdx + 27] = sldIdx * 1000
  end
  -- 10 and 20 thousand
  SliderSteps[#SliderSteps + 1] = 10000
  SliderSteps[#SliderSteps + 1] = 20000

  -- Sets the slider to the nearest step
  local function SetSliderValue(guiData, amount)
    -- Is there no selection?
    local noSelection = (guiData.SelectedIndex == 0)

    -- Enable/Disable
    guiData.AmountSlider.enabled = not noSelection

    if (noSelection) then
      -- Reset
      guiData.AmountSlider.slider_value = 1
      return
    end

    -- Local the nearest step, rounded down
    local step = 1
    for stepIdx = 1, #SliderSteps do
      if (amount >= SliderSteps[stepIdx]) then
        step = stepIdx
      end
    end
    guiData.AmountSlider.slider_value = step
  end

  -- Set the text shown in the amount field
  local function SetAmountText(guiData, text)
    -- Is there no selection?
    local noSelection = (guiData.SelectedIndex == 0)

    -- Enable/Disable
    guiData.AmountTextfield.enabled = not noSelection

    -- Is there no selection?
    if (noSelection) then
      text = "1"
    end

    guiData.AmountTextfield.text = text or ""
    guiData.PreviousAmountText = guiData.AmountTextfield.text
  end

  -- Sets which slot is selected
  local function SetSelectedIndex(guiData, index)
    local filterAmount = 0

    -- Was there a slot selected previously?
    if (guiData.SelectedIndex > 0) then
      local prevSelectedSlot = guiData.Slots[guiData.SelectedIndex]
      -- Set un-highlighted
      prevSelectedSlot.style = "slot_button"

      -- Lock if has filter, unlock if does not
      prevSelectedSlot.locked = (guiData.Node.RequestFilters[guiData.SelectedIndex] ~= nil)
    end

    -- Selecting a slot?
    if (index > 0) then
      -- Get the slot
      local slot = guiData.Slots[index]

      -- Get the filter
      local filter = guiData.Node.RequestFilters[index]
      if (filter ~= nil) then
        filterAmount = filter.Amount

        -- Set highlighted and unlocked
        slot.style = "selected_slot_button"
        slot.locked = false
      end
    end

    -- Store the index
    guiData.SelectedIndex = index

    -- Set slider
    SetSliderValue(guiData, filterAmount)

    -- Set amount
    SetAmountText(guiData, (filterAmount > 0 and tostring(filterAmount)) or "")
  end

  -- Sets the filter and slot
  local function SetFilter(guiData, index, filter)
    -- Set filter
    guiData.Node.RequestFilters[index] = filter

    local slot = guiData.Slots[index]
    if (filter ~= nil) then
      -- Update slot
      slot.elem_value = filter.Item
      UpdateSlotCount(slot, filter.Amount)
    else
      -- Clear slot
      slot.elem_value = nil
      UpdateSlotCount(slot, nil)

      -- If this slot was selected, remove selection
      if (index == guiData.SelectedIndex) then
        SetSelectedIndex(guiData, 0)
      else
        -- Ensure empty slots are unlocked
        slot.locked = false
      end
    end
  end

  -- Sets the amount for the currently selected item
  local function SetFilterAmount(guiData, amount)
    -- Slot with filter selected?
    if ((guiData.SelectedIndex == 0) or (guiData.Node.RequestFilters[guiData.SelectedIndex] == nil)) then
      return
    end

    -- Set the filter amount
    guiData.Node.RequestFilters[guiData.SelectedIndex].Amount = amount or 0

    -- Update label
    UpdateSlotCount(guiData.Slots[guiData.SelectedIndex], amount)
  end

  -- @See BaseGUI:OnShow
  function InterfaceNodeGUI:OnShow(event)
    local SLOT_COUNT = 12

    -- Create properties
    self.Slots = {}
    self.SelectedIndex = 0
    self.PreviousAmountText = "1"
    self.AmountSlider = nil
    self.AmountTextfield = nil

    -- Get root
    local root = game.players[event.player_index].gui[SE.Constants.Names.Gui.InterfaceFrameRoot]

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

    -- Create the body
    local body =
      frame.add(
      {
        type = "flow",
        name = "body",
        direction = "vertical",
        style = "vertical_flow"
      }
    )

    -- Create the inventory table
    local invTable =
      body.add(
      {
        type = "table",
        name = "invTable",
        column_count = math.ceil(SLOT_COUNT / 2.0)
      }
    )

    -- Add selection slots
    local filters = self.Node.RequestFilters
    for idx = 1, SLOT_COUNT do
      -- Add slot
      self.Slots[idx] =
        invTable.add(
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
    for idx = 1, SLOT_COUNT do
      -- Lock a slot if it has a filter and it is not the selected slot
      self.Slots[idx].locked = (filters[idx] ~= nil) and (idx ~= self.SelectedIndex)
    end

    -- Add slider container
    local sliderContainer =
      body.add(
      {
        type = "flow",
        name = "slider-container",
        direction = "horizontal",
        style = "horizontal_flow"
      }
    )

    -- Add slider and input
    self.AmountSlider =
      sliderContainer.add(
      {
        type = "slider",
        name = "amount-slider",
        style = "se_logistics_slider",
        minimum_value = 1,
        maximum_value = #SliderSteps,
        value = 1
      }
    )
    self.AmountSlider.enabled = false

    self.AmountTextfield =
      sliderContainer.add(
      {
        type = "textfield",
        name = "amount-input",
        style = "se_logistics_textfield",
        text = "1"
      }
    )
    self.AmountTextfield.enabled = false

    return true
  end

  -- @See BaseGUI:OnClose
  function InterfaceNodeGUI:OnClose(playerIndex)
    local player = game.players[playerIndex]
    local root = player.gui[SE.Constants.Names.Gui.InterfaceFrameRoot]
    local frame = root[SE.Constants.Names.Gui.InterfaceFrame]
    if (frame ~= nil) then
      frame.destroy()
    end
  end

  -- @See BaseGUI:OnPlayerChangedSelectionElement
  function InterfaceNodeGUI:OnPlayerChangedSelectionElement(event)
    local dropdown = event.element

    -- Get the index of the changed element
    local index = tonumber(string.sub(dropdown.name, 1 + string.len(SE.Constants.Names.Gui.InterfaceItemSelectionElement)))

    if (dropdown.elem_value ~= nil) then
      -- Set filter
      SetFilter(self, index, {Item = dropdown.elem_value, Amount = 1})

      -- Select button
      SetSelectedIndex(self, index)
    else
      -- Clear filter
      SetFilter(self, index, nil)
    end
  end

  -- @See BaseGUI:OnPlayerClicked
  function InterfaceNodeGUI:OnPlayerClicked(event)
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

            -- Clear selection
            SetSelectedIndex(self, 0)
          else
            -- Select the slot
            SetSelectedIndex(self, clickedIdx)
          end
        end -- end Has filter?
      end -- end clickedIdx ~= self.SelectedIndex
    end -- end Is elem button?
  end

  -- @See BaseGUI:OnPlayerChangedText
  function InterfaceNodeGUI:OnPlayerChangedText(event)
    local txtBox = event.element

    -- Is there no selection?
    if (self.SelectedIndex == 0) then
      -- Reset
      txtBox.text = "1"
      self.PreviousAmountText = "1"
      return
    end

    -- Get the text
    local currentText = txtBox.text

    local amount = 0

    -- Is the text not empty?
    if (currentText ~= "") then
      -- Convert text to a number
      amount = tonumber(currentText)

      -- Is the amount valid?
      if (amount == nil) then
        -- Not numeric, restore last text
        txtBox.text = self.PreviousAmountText
        return
      end

      -- Is numeric, clamp to range
      amount = math.max(math.min(amount, 20000), 0)
      SetAmountText(self, tostring(amount))
    end

    -- Update slider
    SetSliderValue(self, amount)

    -- Update filter
    SetFilterAmount(self, amount)
  end

  -- @See BaseGUI:OnPlayerChangedSlider
  function InterfaceNodeGUI:OnPlayerChangedSlider(event)
    local slider = event.element

    -- Is there no selection?
    if (self.SelectedIndex == 0) then
      -- Reset
      slider.slider_value = 1
      return
    end

    -- Get the amount
    local amount = SliderSteps[math.floor(slider.slider_value)]

    -- Set the field
    SetAmountText(self, amount)

    -- Update filter
    SetFilterAmount(self, amount)
  end

  return InterfaceNodeGUI
end
