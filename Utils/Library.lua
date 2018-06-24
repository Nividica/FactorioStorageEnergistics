-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2018-06-23
-- Description: General purprose helper functions

-- fpairs( t :: Table, predicate :: ( Function( key, value ) :: boolean ) )
-- Iterates over a table, returning only those items
-- that match the predicate
function fpairs(t, predicate)
  local key = nil
  local value = nil

  return function()
    -- Get next item
    key, value = next(t, key)

    --  Search until match or no more items
    while ((key ~= nil) and (not predicate(key, value))) do
      -- Get next
      key, value = next(t, key)
    end

    -- Found match?
    if (key ~= nil) then
      return key, value
    end
  end
end
