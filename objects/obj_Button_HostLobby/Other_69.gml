// listening for lobby creation
switch(async_load[?"event_type"]){
    case "lobby_created":
        show_debug_message("Lobby created: " + string(steam_lobby_get_lobby_id()) + ". Attempting to join...");
        steam_lobby_join_id(steam_lobby_get_lobby_id());
        
        break;
    
    case "lobby_joined":
        
        if (steam_lobby_is_owner())
        {
            show_debug_message("Joined your own lobby");
            steam_lobby_set_data("isGameMakerTest","true");
            steam_lobby_set_data("Creator", steam_get_persona_name());
            //can also set values for a lobby
            //example random room to play in
            //steam_lobby_set_data("Map", "rm_GameRoom");
        }
        room_goto(rm_GameRoom);
        break;
}