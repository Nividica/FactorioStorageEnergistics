return function()
    Store = {
        Nodes = nil
    }

    function Store.OnInit()
        -- Nodes
        if (global.Nodes == nil) then
            global.Nodes = {}
        end
        Store.OnLoad()
    end

    function Store.OnLoad()
        if (global.Nodes == nil) then
            global.Nodes = {}
        end
        Store.Nodes = global.Nodes
    end

    return Store
end
