-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-19
-- Description: GUI styles

local guiStyles = data.raw["gui-style"]["default"]

guiStyles["se_item_table_item_label"] = {
  type = "label_style",
  parent = "label",
  font = "default-semibold"
}

guiStyles["se_horizontal_line"] = {
  type = "progressbar_style",
  parent = "progressbar",
  smooth_color = default_orange_color
}

guiStyles["se_logistics_slider"] = {
  type = "slider_style",
  parent = "slider",
  width = 167,
  height = 19,
  top_padding = 5
}

guiStyles["se_logistics_textfield"] = {
  type = "textfield_style",
  parent = "textfield",
  width = 50
}
