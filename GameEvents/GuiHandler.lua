-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 11/1/2017
-- Description: GUI related events

return function()
  local GuiHandler = {}

  -- Map( PlayerIndex -> NetworkNode or False )
  -- Tracks when players have opened a node
  -- False is stored when the player has something open, but it is not a node
  local OpenedNodes = {}

  -- Called every game tick
  function GuiHandler.Tick()
    -- Get the list of players
    for idx, player in pairs(game.players) do
      -- Does the player have anything open?
      if (player.opened ~= nil) then
        -- Did the player have nothing open last tick?
        if (OpenedNodes[idx] == nil) then
          -- Mark that the player has something opened
          -- This is purely for performance reasons, so we don't re-run the entity and handler check every tick.
          OpenedNodes[idx] = false

          -- Did the player just open an entity?
          if (type(player.opened) == "table" and player.opened.direction ~= nil) then
            -- Does that entity have a node handler?
            local handler = SE.NodeHandlers.GetEntityHandler(player.opened)
            if (handler ~= nil) then
              -- Get the node for the entity
              local node = SE.Networks.GetNodeForEntity(player.opened)
              if (node == nil) then
                error("Storage Energistics: Player Opened An Unregistered Entity")
              end

              -- Mark the node as opened by this player
              OpenedNodes[idx] = node

              -- Inform the handler
              handler.OnPlayerOpenedNode(node, player)
            end -- End (nil handler)
          end -- End (is entity)
        end -- End (OpenedNodes?)
      else
        -- Did the player just close something?
        if (OpenedNodes[idx] ~= nil) then
          -- Was the thing closed a node?
          if (OpenedNodes[idx] ~= false) then
            local node = OpenedNodes[idx]
            -- Get the nodes handler
            local handler = SE.NodeHandlers.GetNodeHandler(node)

            -- Inform the handler
            handler.OnPlayerClosedNode(node, player)
          end

          -- Mark as closed
          OpenedNodes[idx] = nil
        end
      end
    end
  end

  function GuiHandler.OnElementChanged(event)
    -- Does the player have a node opened?
    if (OpenedNodes[event.player_index]) then
      -- Get the node
      local node = OpenedNodes[event.player_index]

      -- Get the nodes handler
      local handler = SE.NodeHandlers.GetNodeHandler(node)

      -- Get the player
      local player = game.players[event.player_index]

      -- Inform the node
      handler.OnPlayerChangedSelectionElement(node, player, event.element)
    end
  end

  function GuiHandler.OnCheckboxChanged(event)
    -- Does the player have a node opened?
    if (OpenedNodes[event.player_index]) then
      -- Get the node
      local node = OpenedNodes[event.player_index]

      -- Get the nodes handler
      local handler = SE.NodeHandlers.GetNodeHandler(node)

      -- Get the player
      local player = game.players[event.player_index]

      -- Inform the node
      handler.OnPlayerChangedCheckboxElement(node, player, event.element)
    end
  end

  function GuiHandler.RegisterWithGame()
    script.on_event(defines.events.on_gui_elem_changed, GuiHandler.OnElementChanged)
    script.on_event(defines.events.on_gui_checked_state_changed, GuiHandler.OnCheckboxChanged)
  end

  return GuiHandler
end
