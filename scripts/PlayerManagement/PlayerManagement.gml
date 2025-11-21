function grab_spawn_point(_player){
    var _spawnPoint = instance_find(obj_SpawnPoint, _player);
    if _spawnPoint == noone return {x:0, y:0}
    return {x: _spawnPoint.x, y: _spawnPoint.y}
}


///@self obj_Client 
function send_player_input(_input, _lobby_host) {
    var _xInput = (_input.rightKey - _input.leftKey);
	var _yInput = (_input.downKey - _input.upKey);
	var _runKey = _input.runKey;
	var _actionKey = _input.actionKey;
	var _b = buffer_create(5, buffer_fixed, 1); //1+1+1+1+1
	buffer_write(_b, buffer_u8, NETWORK_PACKETS.CLIENT_PLAYER_INPUT);//1
	buffer_write(_b, buffer_s8, _xInput);//1
	buffer_write(_b, buffer_s8, _yInput);//1
	buffer_write(_b, buffer_u8, _runKey);//1
	buffer_write(_b, buffer_u8, _actionKey);//1
	steam_net_packet_send(_lobby_host, _b);
	buffer_delete(_b);
    
}

///@description Player Input Packet Reading for server/client
function  receive_player_input(_b, _steam_id =-1) {
    if _steam_id == -1 then _steam_id = buffer_read(_b, buffer_u64)
    // need to double check why this works
	var _xInput = buffer_read(_b, buffer_s8)
	var _yInput = buffer_read(_b, buffer_s8)
	var _runKey = buffer_read(_b, buffer_u8)
	var _actionKey = buffer_read(_b, buffer_u8)
	var _player = find_player_by_steam_id(_steam_id)
	if _player == noone return;
	_player.xInput = _xInput
	_player.yInput = _yInput
	_player.runKey = _runKey
	_player.actionKey = _actionKey
	
	return {steamID: _steam_id, xInput: _xInput, yInput: _yInput, runKey: _runKey, actionKey: _actionKey}
}

///@description Finding player object on client/server
function find_player_by_steam_id(_steam_id){
    for (var _i = 0; _i < array_length(playerList); _i++){
		var _player = playerList[_i].character
		if _player == undefined continue;
		if _player.steamID == _steam_id return _player;
		
	}
	return noone;
    
}

///@desc Constantly update other clients on every player's position
///@self obj_Server
function send_player_positions() {
    // this is all based on the SERVER's playerList so everyone will be updated to those values
    for (var _i = 0; _i < array_length(playerList); _i++){	
		var _player = playerList[_i];
        // this is because there are a few frames where the player hasn't spawned so they don't have a character yet
		if _player.character == undefined then continue;
		if _player.steamID == undefined then continue;
		var _b = buffer_create(13, buffer_fixed, 1); //1+8+2+2
		buffer_write(_b, buffer_u8, NETWORK_PACKETS.PLAYER_POSITION);//1
		buffer_write(_b, buffer_u64, _player.steamID);//8
		buffer_write(_b, buffer_u16, _player.character.x);//2
		buffer_write(_b, buffer_u16, _player.character.y);//2
		for (var _k = 0; _k < array_length(playerList); _k++){
			if (playerList[_k].steamID != obj_Server.steamID) {
				steam_net_packet_send(playerList[_k].steamID, _b);
			}
		}
		buffer_delete(_b);
	}
}

///@self obj_Client
function update_player_position(_b) {
    var _steam_id = buffer_read(_b, buffer_u64);
	var _x = buffer_read(_b, buffer_u16);
	var _y = buffer_read(_b, buffer_u16);
	for (var _i = 0; _i < array_length(playerList); _i++){
		if (_steam_id == playerList[_i].steamID) {
			if playerList[_i].character = undefined then continue;
			playerList[_i].character.x = _x;
			playerList[_i].character.y = _y;
		}
	}
}