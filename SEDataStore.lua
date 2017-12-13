-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 10/26/2017
-- Description: Persistance data
-- Singleton

return function()
  Store = {
    Nodes = nil
  }

  function Store.OnInit()
    -- Nodes
    if (global.Nodes == nil) then
      global.Nodes = {}
    end
    Store.OnLoad(global)
  end

  function Store.OnLoad()
    Store.Nodes = global.Nodes
  end

  return Store
end
