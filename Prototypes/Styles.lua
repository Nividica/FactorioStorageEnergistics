-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-19
-- Description: GUI styles

local guiStyles = data.raw["gui-style"]["default"]

guiStyles["se_slot_button_style"] = {
  type = "button_style",
  parent = "button_style",
  scalable = false,
  width = 36,
  height = 36,
  top_padding = 1,
  right_padding = 1,
  bottom_padding = 1,
  left_padding = 1,
  align = "center",
  default_graphical_set = {
    type = "monolith",
    top_monolith_border = 1,
    right_monolith_border = 1,
    bottom_monolith_border = 1,
    left_monolith_border = 1,
    monolith_image = {
      filename = "__core__/graphics/gui.png",
      priority = "extra-high-no-scale",
      width = 36,
      height = 36,
      x = 111
    }
  },
  disabled_graphical_set = {
    type = "monolith",
    top_monolith_border = 1,
    right_monolith_border = 1,
    bottom_monolith_border = 1,
    left_monolith_border = 1,
    monolith_image = {
      filename = "__core__/graphics/gui.png",
      priority = "extra-high-no-scale",
      width = 36,
      height = 36,
      x = 111
    }
  },
  pie_progress_color = {r = 0.98, g = 0.66, b = 0.22, a = 0.5}
}

guiStyles["se_item_table_item_label"] = {
  type = "label_style",
  parent = "label_style",
  font = "default-semibold"
}

guiStyles["se_horizontal_line"] = {
  type = "progressbar_style",
  parent = "progressbar_style",
  smooth_color = default_orange_color
}
