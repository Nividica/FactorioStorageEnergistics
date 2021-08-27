-- Description: GUI styles Frame

local default_gui = data.raw["gui-style"].default
-------------------------------------------------------------------------------
-- Style of default
--
-- @field [parent=#Flow] default

default_gui[Constants.Names.Styles.Flows.SEFlowDefault] = {
  type = "flow_style",
  --horizontal_spacing = 1,
  --vertical_spacing = 1
}

default_gui[Constants.Names.Styles.Flows.SEFlowItemCell] = {
  type = "flow_style",
  minimal_width = Constants.Variables.NetworkOverview.Flow.ItemCell.Width,
  maximal_width = Constants.Variables.NetworkOverview.Flow.ItemCell.Width
}

-------------------------------------------------------------------------------
-- Style of horizontal
--
-- @field [parent=#Flow] horizontal

default_gui[Constants.Names.Styles.Flows.SEFlowHorizontal] = {
  type = "horizontal_flow_style",
  horizontal_spacing = 0
}

-------------------------------------------------------------------------------
-- Style of vertical
--
-- @field [parent=#Flow] vertical

default_gui[Constants.Names.Styles.Flows.SEFlowVertical] = {
  type = "vertical_flow_style",
  vertical_spacing = 0
}