/// @description Initialize Game

//show_debug_overlay(true);
draw_set_circle_precision(32);

/*--------
ASSET MAPS
--------*/

global.sprites = ds_map_create();
global.materials = ds_map_create();
global.fonts = ds_map_create();
global.sounds = ds_map_create();
global.music = ds_map_create();

var missingAssetTexture = sprite_get_texture(sprMissingAsset, 0);
global.missingSprite = [sprMissingAsset, eSpriteType.normal, missingAssetTexture];
global.missingMaterial = [sprMissingAsset, 1, undefined, 0, 0, 0, 0, missingAssetTexture];
global.missingFont = font_add_sprite(sprMissingAsset, ord("!"), false, 0);

/*-----
SYSTEMS
-----*/

rousr_dissonance_create("732560402873057320");
rousr_dissonance_set_details("Loading");
rousr_dissonance_set_large_image("largeicon0");

smf_init();

FMODGMS_Sys_Create();
FMODGMS_Sys_Initialize(2);

colmesh_init();

/*----------
GAME SYSTEMS
----------*/

//Level
global.level = undefined;
global.levelRoom = 0;
global.levelName = "Loading";
global.levelIcon = "largeicon0";
global.levelData = ds_map_create();
global.events = ds_map_create();

//Graphics
global.cameraDefaultView = camera_get_view_mat(view_camera[0]);
global.cameraDefaultProjection = camera_get_proj_mat(view_camera[0]);
global.currentShader = shWorld;

global.skybox = [noone, undefined];
global.skyboxColor = [];
global.fogDistance = [0, 65536];
global.fogColor = c_black;
global.lightNormal = [-1, 0, -1];
global.lightColor = c_white;
global.particles = ds_list_create();

//Music
global.channel = [FMODGMS_Chan_CreateChannel(), FMODGMS_Chan_CreateChannel()]; //normal, battle
global.levelMusic = [noone, 1, 1, 1, 0, noone, 0, 0, 0, 0]; //normal, volume, volume start, volume end, time, battle, volume, volume start, volume end, time
global.battle = false;

//Update loop
timer_create();
global.levelStart = true;
global.clock = new iota_clock();
global.clock.set_update_frequency(60);
global.clock.add_cycle_method(function ()
{
	//Update input
	input_player_source_set(gamepad_is_connected(0) ? INPUT_SOURCE.GAMEPAD : INPUT_SOURCE.KEYBOARD_AND_MOUSE);
	input_tick();
	
	//Update music volume
	for (var i = 0; i < 2; i++) if (timer[i] >= 0)
	{
		var slot = i * 5;
		global.levelMusic[slot + 1] = lerp(global.levelMusic[slot + 2], global.levelMusic[slot + 3], (global.levelMusic[slot + 4] - timer[i]) / global.levelMusic[slot + 4]);
		FMODGMS_Chan_Set_Volume(global.channel[i], (global.volume[0] * global.volume[2]) * global.levelMusic[slot + 1]);
		timer_tick(i);
	}
	
	with (objActor) tick();
	
	if (!global.lockPlayer && instance_exists(objPlayer) && !instance_exists(objPause) && input_check_pressed(eBind.pause))
	{
		instance_deactivate_all(true);
		instance_create_depth(0, 0, 0, objPause);
	}
	
	if (keyboard_check_pressed(vk_f1)) show_debug_message(string(FMODGMS_Chan_Get_Position(global.channel[0])) + " / " + string(FMODGMS_Snd_Get_Length(global.music[? global.levelMusic[0]])));
});

//Settings
enum eBind {up, left, down, right, jump, attack, cameraUp, cameraLeft, cameraDown, cameraRight, zoom, center, pause}

input_default_key(ord("W"), eBind.up);
input_default_gamepad_axis(gp_axislv, true, eBind.up);
input_default_key(ord("A"), eBind.left);
input_default_gamepad_axis(gp_axislh, true, eBind.left);
input_default_key(ord("S"), eBind.down);
input_default_gamepad_axis(gp_axislv, false, eBind.down);
input_default_key(ord("D"), eBind.right);
input_default_gamepad_axis(gp_axislh, false, eBind.right);

input_default_key(vk_space, eBind.jump);
input_default_gamepad_button(gp_face1, eBind.jump);

input_default_mouse_button(mb_left, eBind.attack);
input_default_key(ord("E"), eBind.attack);
input_default_gamepad_button(gp_shoulderrb, eBind.attack);

input_default_key(vk_up, eBind.cameraUp);
input_default_gamepad_axis(gp_axisrv, true, eBind.cameraUp);
input_default_key(vk_left, eBind.cameraLeft);
input_default_gamepad_axis(gp_axisrh, true, eBind.cameraLeft);
input_default_key(vk_down, eBind.cameraDown);
input_default_gamepad_axis(gp_axisrv, false, eBind.cameraDown);
input_default_key(vk_right, eBind.cameraRight);
input_default_gamepad_axis(gp_axisrh, false, eBind.cameraRight);

input_default_mouse_button(mb_right, eBind.zoom);
input_default_key(ord("R"), eBind.zoom);
input_default_gamepad_button(gp_shoulderlb, eBind.zoom);

input_default_mouse_button(mb_middle, eBind.center);
input_default_key(ord("Q"), eBind.center);
input_default_gamepad_button(gp_face2, eBind.center);

input_default_key(vk_escape, eBind.pause);
input_default_gamepad_button(gp_start, eBind.pause);

input_player_source_set(INPUT_SOURCE.KEYBOARD_AND_MOUSE);
input_player_gamepad_set(0);

global.mouselook = true;

global.maxFPS = 60;
game_set_speed(global.maxFPS, gamespeed_fps);


global.volume = [1, 1, 1]; //master, sound, music
audio_master_gain(global.volume[0] * global.volume[1]);
for (var i = 0; i < 2; i++) FMODGMS_Chan_Set_Volume(global.channel[i], (global.volume[0] * global.volume[2]) * global.levelMusic[(i * 3) + 2]);

global.gameStart = true;

global.lockPlayer = false;

global.PAUSEDEBUG = false;

//Start intro
pn_level_goto(eLevel.logo);