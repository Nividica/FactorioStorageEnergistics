-- Description: GUI styles Frame

local default_gui = data.raw["gui-style"].default

-------------------------------------------------------------------------------
-- Style progressbar
--
-- @type Progressbar
--

default_gui[Constants.Names.Styles.Progressbars.SEProgressbarDefault] = {
  type = "progressbar_style",
  minimal_width = Constants.Variables.NetworkOverview.Progressbar.Width
}

default_gui[Constants.Names.Styles.Progressbars.SEProgressbarHorizontalLine] = {
  type = "progressbar_style",
  smooth_color = Constants.Variables.NetworkOverview.Progressbar.Color,
  minimal_width = Constants.Variables.NetworkOverview.Progressbar.Width,
  minimal_height = Constants.Variables.NetworkOverview.Progressbar.MiniHeight,
  maximal_height = Constants.Variables.NetworkOverview.Progressbar.MaxiHeight
}
