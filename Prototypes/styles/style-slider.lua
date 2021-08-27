-- Description: GUI styles Textbox

local default_gui = data.raw["gui-style"].default

-------------------------------------------------------------------------------
-- Style slider
--
-- @type Slider
--

-------------------------------------------------------------------------------
-- Style of default
--
-- @field [parent=#Slider] default
default_gui[Constants.Names.Styles.Sliders.SELogisticsSlider] = {
    type = "slider_style",
    parent = "slider",
    width = 167,
    height = 19,
    top_padding = 5
}