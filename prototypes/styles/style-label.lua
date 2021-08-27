-- Description: GUI styles Frame

local default_gui = data.raw["gui-style"].default


local shadowColor = {r = 0.2, g = 0.2, b = 0.25}

-------------------------------------------------------------------------------
-- Style label
--
-- @type Label
--

-------------------------------------------------------------------------------
-- Style of default
--
-- @field [parent=#Label] default
default_gui[Constants.Names.Styles.Labels.SEItemTableItemLabel] = {
  type = "label_style",
  parent = "label",
  font = "default-semibold"
}

default_gui[Constants.Names.Styles.Labels.SEElecticUsageLabelTL] = {
  type = "label_style",
  parent = "electric_usage_label",
  top_padding = 14 - 1,
  left_padding = 0,
  font = "default-small-bold",
  font_color = shadowColor
}

default_gui[Constants.Names.Styles.Labels.SEElecticUsageLabelBR] = {
  type = "label_style",
  parent = "electric_usage_label",
  top_padding = 14 + 1,
  left_padding = 2,
  font = "default-small-bold",
  font_color = shadowColor
}


default_gui[Constants.Names.Styles.Labels.SEElecticUsageLabelCount] = {
  type = "label_style",
  parent = "electric_usage_label",
  top_padding = 14,
  left_padding = 1,
  font = "default-small-bold",
  font_color = {r = 1, g = 1, b = 1}
}

