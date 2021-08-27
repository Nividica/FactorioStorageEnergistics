
return function(BaseHandler)
    local ControllerNodeHandlers = {
        HandlerName = SE.Constants.Names.NodeHandlers.Controller,
        Type = SE.Constants.NodeTypes.Controller
    }
    setmetatable(ControllerNodeHandlers, {__index = BaseHandler})

    -- @See BaseNode.NewNode
    function ControllerNodeHandlers.NewNode(entity)
        -- Prevent player interaction with the Controller GUI
        entity.operable = false

        return ControllerNodeHandlers.EnsureStructure(BaseHandler.NewNode(entity))
    end

    -- @See BaseNode:EnsureStructure
    function ControllerNodeHandlers:EnsureStructure()
        BaseHandler.EnsureStructure(self)
        self.HandlerName = ControllerNodeHandlers.HandlerName
        return self
    end

    return ControllerNodeHandlers
end