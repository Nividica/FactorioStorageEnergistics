-------------------------------------------------------------------------------
-- Class to help to build GuiCheckBox
--
-- @module GuiCheckBox
--

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiCheckBox] constructor
-- @param #arg name
-- @return #GuiCheckBox
--
GuiCheckBox = newclass(GuiElement,function(base,...)
  GuiElement.init(base,...)
  base.classname = "SEGuiCheckBox"
  base.options.type = "checkbox"
end)

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiCheckBox] state
-- @param #boolean state
-- @return #GuiCheckBox
--
function GuiCheckBox:state(state)
  self.options.state = state
  return self
end