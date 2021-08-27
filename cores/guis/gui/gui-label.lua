-------------------------------------------------------------------------------
-- Class to help to build GuiLabel
--
-- @module GuiLabel
--

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiLabel] constructor
-- @param #arg name
-- @return #GuiLabel
--
GuiLabel = newclass(GuiElement,function(base,...)
  GuiElement.init(base,...)
  base.classname = "SEGuiLabel"
  base.options.type = "label"
end)

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiLabel] wordWrap
-- @param #boolean wrap
-- @return #GuiLabel
--
function GuiLabel:wordWrap(wrap)
  self.options.word_wrap = wrap
  return self
end

-------------------------------------------------------------------------------
--
-- @function [parent=#GuiLabel] ignored_by_interaction
-- @param #boolean ignored_by_interaction
-- @return #GuiLabel
--
function GuiLabel:ignored_by_interaction(ignored_by_interaction)
  self.options.ignored_by_interaction = ignored_by_interaction
  return self
end



