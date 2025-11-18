//listen for server list response
switch (async_load[?"event_type"]){
    case "lobby_list":
        //reset lobby list
        show_debug_message("Async received! Listing lobbies...");
        resetLobbyList();
        var _lobbyCount = steam_lobby_list_get_count();
        show_debug_message($"Found {_lobbyCount} lobbies.");
        if _lobbyCount == 0 {
            lobbyList[0] = instance_create_depth(x, bbox_top+40, -20, obj_LobbyItem);
        } else {
            for (var _i = 0; _i < _lobbyCount; _i++){
                var _inst = instance_create_depth(x, bbox_top+40, -20, obj_LobbyItem, {
                    lobby_index : _i,
                    lobby_id    : steam_lobby_list_get_lobby_id(_i),
                    lobby_creator: steam_lobby_list_get_data(_i, "Creator")   
                });
                array_push(lobbyList, _inst);
            }
        }
        
        
        break;
}