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
  GuiHandler.Guis.NetworkOverview = (require "Guis/NetworkOverview")(GuiHandler.Guis.BaseGui)

  -- Map( PlayerIndex -> ( {GuiHandler, Node, Handler} or False ) )
  -- Tracks what nodes players have open, and each nodes data
  -- False is stored when the player has something open, but it is not a node
  local OpenedNodes = {}

  -- Map( PlayerIndex -> Map( GuiHandler -> GuiData ) )
  -- Tracks what Guis players have open, and each Guis data
  local OpenedGuis = {}

  -- Called when the player has just opened an entity
  -- Returns the nodes info, or false
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

    local nodeInfo = {Node = node, Handler = handler}

    -- Ask the handler for a GUI
    local guiHandler = handler.OnPlayerOpenedNode(node, player)
    if (guiHandler ~= nil) then
      -- Show the gui
      nodeInfo.GuiHandler = guiHandler
      GuiHandler.ShowGui(player, guiHandler, nodeInfo)
    end

    return nodeInfo
  end

  -- Called when the player no longer has a node-entity open
  local function OnNodeClosed(player, nodeInfo)
    -- Inform the node handler
    nodeInfo.Handler.OnPlayerClosedNode(nodeInfo.Node, player)

    -- Close the GUI
    if (nodeInfo.GuiHandler ~= nil) then
      GuiHandler.CloseGui(player, nodeInfo.GuiHandler)
    end
  end

  -- Check what the player has open and send events.
  -- For each player there are several possibilities:
  -- A) Nothing changed
  -- B) Player opened new non-node entity
  -- C) Player opened new node with no GUI
  -- D) Player opened new node with GUI
  -- E) Player closed non-node entity
  -- F) Player closed node with no GUI
  -- G) Player closed node with GUI
  -- In case B, it will be marked the player has something open
  -- In cases C and F, the node events will fire, but no gui events
  -- In cases D and G, node and gui events will fire
  -- In case E, it will be marked the player no longer has anything open
  -- Note: It is assumed that a player can not have X opened one tick then Y opened the next
  -- and that there must be at least one tick where player.opened is nil
  local function CheckPlayerOpened(player, playerIndex)
    -- Get the exising opened node
    local nodeInfo = OpenedNodes[playerIndex]

    if (nodeInfo ~= nil and player.opened == nil) then
      -- Something was opened, and is now closed.
      -- Mark as closed
      OpenedNodes[playerIndex] = nil

      -- Was the opened thing a node?
      if (nodeInfo ~= false) then
        -- Close the node
        OnNodeClosed(player, nodeInfo)
      end
    elseif (nodeInfo == nil and player.opened ~= nil) then
      -- Nothing was opened, but now something is
      -- Does the player have an entity opened?
      if (type(player.opened) == "table" and player.opened.direction ~= nil) then
        -- Check the entity
        OpenedNodes[playerIndex] = OnOpenEntity(player)
      else
        -- Mark that the player has a non node/entity open
        -- This is purely for performance reasons, so we don't re-run the entity and handler check every tick.
        OpenedNodes[playerIndex] = false
      end
    end
  end

  local function TickGuis(player)
    -- Get the map for this player
    local guiMap = OpenedGuis[player.index]
    if (guiMap ~= nil) then
      -- Check each open gui
      for guiHandler, guiData in pairs(guiMap) do
        if (guiHandler.NeedsTicks) then
          -- Tick the gui
          guiHandler.OnTick(player, guiData)
        end
      end
    end
  end

  function GuiHandler.ShowGui(player, guiHandler, data)
    -- Ensure there is a handler
    if (guiHandler == nil) then
      return
    end

    -- Ensure there is a map
    local guiMap = OpenedGuis[player.index] or {}

    -- Does the player already have this gui open?
    if (guiMap[guiHandler] ~= nil) then
      -- Close the GUI
      GuiHandler.CloseGui(player, guiHandler)
    end

    -- Ensure data is not nil
    data = data or {}

    -- Save the data
    guiMap[guiHandler] = data
    OpenedGuis[player.index] = guiMap

    -- Open the GUI
    guiHandler.OnShow(player, data)
  end

  function GuiHandler.CloseGui(player, guiHandler)
    -- Ensure there is a handler
    if (guiHandler == nil) then
      return
    end

    -- Get the map
    local guiMap = OpenedGuis[player.index]
    if (guiMap == nil) then
      return
    end

    -- Get the data
    local guiData = guiMap[guiHandler]
    if (guiData == nil) then
      return
    end

    -- Close the GUI
    guiHandler.OnClose(player, guiData)

    -- Clear the entry
    guiMap[guiHandler] = nil
  end

  -- Called every game tick
  -- If there are any GUIs open, and those GUIs accept ticks, they will be ticked.
  function GuiHandler.Tick()
    -- Get the list of players
    for playerIndex, player in pairs(game.players) do
      -- Check what the player has open
      CheckPlayerOpened(player, playerIndex)

      -- Tick GUIs for this player
      TickGuis(player)
    end
  end

  -- Called when a selection element has changed
  function GuiHandler.OnElementChanged(event)
    -- Get the player
    local player = game.players[event.player_index]

    -- Get the handler map
    local handlerMap = OpenedGuis[player.index]
    if (handlerMap == nil) then
      return
    end

    for guiHandler, guiData in pairs(handlerMap) do
      -- Inform the GUI
      guiHandler.OnPlayerChangedSelectionElement(player, event.element, guiData)
    end
  end

  -- Called when a checkbox changes
  function GuiHandler.OnCheckboxChanged(event)
    -- Get the player
    local player = game.players[event.player_index]

    -- Get the handler map
    local handlerMap = OpenedGuis[player.index]
    if (handlerMap == nil) then
      return
    end

    for guiHandler, guiData in pairs(handlerMap) do
      -- Inform the GUI
      guiHandler.OnPlayerChangedCheckboxElement(player, event.element, guiData)
    end
  end

  -- Called when a dropdown changes
  function GuiHandler.OnDropDownChanged(event)
    -- Get the player
    local player = game.players[event.player_index]

    -- Get the handler map
    local handlerMap = OpenedGuis[player.index]
    if (handlerMap == nil) then
      return
    end

    for guiHandler, guiData in pairs(handlerMap) do
      -- Inform the GUI
      guiHandler.OnPlayerChangedDropDown(player, event.element, guiData)
    end
  end

  -- Called to register the handler events
  function GuiHandler.RegisterWithGame()
    script.on_event(defines.events.on_gui_elem_changed, GuiHandler.OnElementChanged)
    script.on_event(defines.events.on_gui_checked_state_changed, GuiHandler.OnCheckboxChanged)
    script.on_event(defines.events.on_gui_selection_state_changed, GuiHandler.OnDropDownChanged)
  end

  return GuiHandler
end
