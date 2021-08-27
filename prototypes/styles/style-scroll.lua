-- Description: GUI styles scroll-pane

local default_gui = data.raw["gui-style"].default


-------------------------------------------------------------------------------
-- Style of default
--
-- @field [parent=#Frame] default

default_gui[Constants.Names.Styles.Scrolls.SEScrollDefault] = {
    type = "scroll_pane_style",
    parent = "scroll_pane",
    minimal_width = Constants.Variables.NetworkOverview.Scroll.Width,
    maximal_width = Constants.Variables.NetworkOverview.Scroll.Width,
    minimal_height = Constants.Variables.NetworkOverview.Scroll.Height,
    maximal_height = Constants.Variables.NetworkOverview.Scroll.Height
  }
