-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2018-06-22
-- Description: Provides helper function for interacting with a GUI

require "Utils/Strings"

-- AddCountToSlot( LuaGuiElement ) :: void
-- Alright, this sucks, but I have yet to find a better way
-- to add the shadow to the count
function AddCountToSlot(slot, count)
  local shadow_color = {r = 0.2, g = 0.2, b = 0.25}
  local vert_center = 14
  local label_style = "electric_usage_label"
  local font_style = "default-small-bold"
  local countStr = (count and NumberToStringWithSuffix(count)) or ""

  -- Top-left shadow
  local tlShadow =
    slot.add(
    {
      type = "label",
      name = "count_tl_shadow",
      caption = countStr,
      style = label_style,
      ignored_by_interaction = true
    }
  )
  tlShadow.style.top_padding = vert_center - 1
  tlShadow.style.left_padding = 0
  tlShadow.style.font = font_style
  tlShadow.style.font_color = shadow_color

  -- Bottom-right shadow
  local brShadow =
    slot.add(
    {
      type = "label",
      name = "count_br_shadow",
      caption = countStr,
      style = label_style,
      ignored_by_interaction = true
    }
  )
  brShadow.style.top_padding = vert_center + 1
  brShadow.style.left_padding = 2
  brShadow.style.font = font_style
  brShadow.style.font_color = shadow_color

  -- Foreground
  local numLabel =
    slot.add(
    {
      type = "label",
      name = "count",
      caption = countStr,
      style = label_style,
      ignored_by_interaction = true
    }
  )
  numLabel.style.top_padding = vert_center
  numLabel.style.left_padding = 1
  numLabel.style.font = font_style
  numLabel.style.font_color = {r = 1, g = 1, b = 1}

  return {TLS = tlShadow, BRS = brShadow, Label = numLabel}
end

function UpdateSlotCount(slot, count)
  local countStr = (count and NumberToStringWithSuffix(count)) or ""
  slot["count"].caption = countStr
  slot["count_br_shadow"].caption = countStr
  slot["count_tl_shadow"].caption = countStr
end
