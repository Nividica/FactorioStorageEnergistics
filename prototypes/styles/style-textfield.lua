-- Description: GUI styles Textfield

local default_gui = data.raw["gui-style"].default

-------------------------------------------------------------------------------
-- Style Textfield
--
-- @type Textfield
--

-------------------------------------------------------------------------------
-- Style of default
--
-- @field [parent=#Textfield] default

default_gui[Constants.Names.Styles.Textfields.SELogisticsTextfield] = {
    type = "textbox_style",
    parent = "search_textfield_with_fixed_width",
    width = 50
}