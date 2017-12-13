-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 11/1/2017
-- Description: GUI related events

return function()
  local GuiHandler = {
    Guis = {}
  }

  -- Add GUI's
  GuiHandler.Guis.BaseGui = (require "Guis/BaseGui")()
  GuiHandler.Guis.InterfaceNode = (require "Guis/InterfaceNode")(GuiHandler.Guis.BaseGui)
  GuiHandler.Guis.StorageNode = (require "Guis/StorageNode")(GuiHandler.Guis.BaseGui)

  -- Map( PlayerIndex -> { Node, Handler, GuiHandler } or False )
  -- Tracks when players have opened a node
  -- False is stored when the player has something open, but it is not a node
  local OpenedNodes = {}

  local function OnOpenEntity(player)
    -- Does that entity have a node handler?
    local handler = SE.NodeHandlers.GetEntityHandler(player.opened)
    if (handler == nil) then
      -- Not a network node
      return false
    end

    -- Get the node for the entity
    local node = SE.Networks.GetNodeForEntity(player.opened)
    if (node == nil) then
      error("Storage Energistics: Player Opened An Unregistered Entity")
    end

    -- Ask the handler for a GUI
    local guiHandler = handler.OnPlayerOpenedNode(node, player)

    -- Mark the node as opened by this player
    local nodeInfo = {Node = node, Handler = handler, GuiHandler = guiHandler}

    -- Call the gui handler, if there is one
    if (guiHandler ~= nil) then
      guiHandler.OnShow(player, nodeInfo)
    end

    return nodeInfo
  end

  local function OnNodeClosed(player, nodeInfo)
    -- Inform the node handler
    nodeInfo.Handler.OnPlayerClosedNode(nodeInfo.Node, player)

    -- Has gui handler?
    local guiHandler = nodeInfo.GuiHandler
    if (guiHandler ~= nil) then
      -- Inform the gui handler
      guiHandler.OnClose(player, nodeInfo)
    end
  end

  -- Called every game tick
  function GuiHandler.Tick()
    -- Get the list of players
    for idx, player in pairs(game.players) do
      -- Does the player have anything open?
      local nodeInfo = OpenedNodes[idx]
      if (player.opened ~= nil) then
        -- Did the player have nothing open last tick?
        if (nodeInfo == nil) then
          -- Did the player just open an entity?
          if (type(player.opened) == "table" and player.opened.direction ~= nil) then
            OpenedNodes[idx] = OnOpenEntity(player)
          else
            -- Mark that the player has something opened
            -- This is purely for performance reasons, so we don't re-run the entity and handler check every tick.
            OpenedNodes[idx] = false
          end
        elseif (nodeInfo ~= false) then
          -- Player has a node open, does it have a gui, and does the gui need ticks
          if (nodeInfo.GuiHandler ~= nil and nodeInfo.GuiHandler.NeedsTicks == true) then
            -- Tick the gui
            nodeInfo.GuiHandler.OnTick(player, nodeInfo)
          end
        end
      else
        -- Did the player just close something?
        if (nodeInfo ~= nil) then
          -- Was the thing closed a node?
          if (nodeInfo ~= false) then
            OnNodeClosed(player, nodeInfo)
          end

          -- Mark as closed
          OpenedNodes[idx] = nil
        end
      end
    end
  end

  function GuiHandler.OnElementChanged(event)
    local nodeInfo = OpenedNodes[event.player_index]
    -- Does the player have a node with a gui opened?
    if (nodeInfo ~= nil and nodeInfo ~= false and nodeInfo.GuiHandler ~= nil) then
      -- Get the player
      local player = game.players[event.player_index]

      -- Inform the node
      nodeInfo.GuiHandler.OnPlayerChangedSelectionElement(player, event.element, nodeInfo)
    end
  end

  function GuiHandler.OnCheckboxChanged(event)
    local nodeInfo = OpenedNodes[event.player_index]
    -- Does the player have a node with a gui opened?
    if (nodeInfo ~= nil and nodeInfo ~= false and nodeInfo.GuiHandler ~= nil) then
      -- Get the player
      local player = game.players[event.player_index]

      -- Inform the node
      nodeInfo.GuiHandler.OnPlayerChangedCheckboxElement(player, event.element, nodeInfo)
    end
  end

  function GuiHandler.RegisterWithGame()
    script.on_event(defines.events.on_gui_elem_changed, GuiHandler.OnElementChanged)
    script.on_event(defines.events.on_gui_checked_state_changed, GuiHandler.OnCheckboxChanged)
  end

  return GuiHandler
end
