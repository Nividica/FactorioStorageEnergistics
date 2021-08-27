-- Description: GUI styles Frame

local default_gui = data.raw["gui-style"].default

-------------------------------------------------------------------------------
-- Style of default
--
-- @field [parent=#Frame] default

default_gui[Constants.Names.Styles.Frames.SEFrameDefault] = {
    type = "frame_style",
    flow_style = {
      type = "flow_style",
      horizontal_spacing = 0,
      vertical_spacing = 0
    },
    horizontal_flow_style =
    {
      type = "horizontal_flow_style",
      horizontal_spacing = 0,
    },
  
    vertical_flow_style =
    {
      type = "vertical_flow_style",
      vertical_spacing = 0
    }
    --- parent = "frame",
    -- marge interieure
    --- padding  = 4
  }
