-------------------------------------------------------------------------------
-- Class to help to build GuiTextField
--
-- @module GuiTextField
--

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTextField] constructor
-- @param #arg name
-- @return #GuiTextField
--
GuiTextField = newclass(GuiElement,function(base,...)
  GuiElement.init(base,...)
  base.classname = "SEGuiTextField"
  base.options.type = "textfield"
end)

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTextField] text
-- @param #string text
-- @return #GuiTextField
--
function GuiTextField:text(text)
  self.options.text = text
  return self
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTextField] isNumeric
-- @return #GuiTextField
--
function GuiTextField:isNumeric()
  self.options.numeric = true
  return self
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTextField] allowDecimal
-- @return #GuiTextField
--
function GuiTextField:allowDecimal ()
  self.options.allow_decimal = true
  return self
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiTextField] allowNegative
-- @return #GuiTextField
--
function GuiTextField:allowNegative ()
  self.options.allow_negative = true
  return self
end