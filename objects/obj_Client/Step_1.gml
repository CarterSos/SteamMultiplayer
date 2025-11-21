/// @description  Listening for Activity as Client

// Receiving Packets
while(steam_net_packet_receive()){
    
    var _sender = steam_net_packet_get_sender_id();
    steam_net_packet_get_data(inbuf);
    buffer_seek(inbuf, buffer_seek_start, 0); // sets the seek position so that EVERY packet we ever get as a client begins at the beginning
    // applies to buffer read and write
    var _type = buffer_read(inbuf, buffer_u8);
    switch (_type){
        case NETWORK_PACKETS.SYNC_PLAYERS:
            var _playerList = json_parse(buffer_read(inbuf, buffer_string));
            sync_players(_playerList);
            break;
        
        case NETWORK_PACKETS.SPAWN_OTHER:
			var _layer = layer_get_id("Instances");
			var _x = buffer_read(inbuf, buffer_u16)
			var _y = buffer_read(inbuf, buffer_u16)
			var _steamID = buffer_read(inbuf, buffer_u64)
			var _num = array_length(playerList)
			var _inst = instance_create_layer(_x,_y,_layer,obj_Player,{
							steamName : steam_get_user_persona_name(_steamID),
							steamID : _steamID,
							lobbyMemberID : _num
							})
			array_push(playerList, {
				steamID	 : _steamID,
				steamName: steam_get_user_persona_name(_steamID),
				character: _inst,
				lobbyMemberID : _num
			})
				
			break;
			
		case NETWORK_PACKETS.SPAWN_SELF:
			for (var _i = 0; _i < array_length(playerList); _i++){
				if playerList[_i].steamID == steamID then lobbyMemberID = playerList[_i].lobbyMemberID	
			}
			var _layer = layer_get_id("Instances");
			var _x = buffer_read(inbuf, buffer_u16)
			var _y = buffer_read(inbuf, buffer_u16)
			var _inst = instance_create_layer(_x,_y,_layer,obj_Player,{
							steamName	: steamName,
							steamID: steamID,
							lobbyMemberID: lobbyMemberID
						})
			playerList[0].character = _inst
			character = _inst
			break;
        
        case NETWORK_PACKETS.SERVER_PLAYER_INPUT:
            //{steamID: _steam_id, xInput: _xInput, yInput: _yInput, runKey: _runKey, actionKey: _actionKey}
            receive_player_input(inbuf)
            break;
        
		default:
			show_debug_message("Unknown packet received: "+string(_type))
			break;
    }
    
    
    
    
}