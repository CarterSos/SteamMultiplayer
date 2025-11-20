/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

image_xscale = 5
image_yscale = .5

selectAction = function() {
    global.client = instance_create_depth(0,0,0,obj_Client);
    steam_lobby_join_id(lobby_id); //lobby_index (not correct from mr youtube, but still helpful for earlier comment lol
}