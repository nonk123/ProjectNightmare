/// @description Initialize Game

show_debug_overlay(true);

/*--------
ASSET MAPS
--------*/

global.sprites = ds_map_create();
global.materials = ds_map_create();
global.fonts = ds_map_create();
global.sounds = ds_map_create();
global.music = ds_map_create();

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
global.skybox = noone;
global.skyboxColor = [0, 0, 0];
global.fogDistance = [0, 65536];
global.fogColor = c_black;
global.lightNormal = [-1, 0, -1];
global.lightColor = c_white;
global.particles = ds_list_create();

//Music
global.channel = [FMODGMS_Chan_CreateChannel(), FMODGMS_Chan_CreateChannel()]; //normal, battle
global.levelMusic = [noone, 1, 1, noone, 0, 0]; //normal, volume, target volume, battle, volume, target volume
global.battle = false;

//Update loop
global.levelStart = true;
global.clock = new iota_clock();
global.clock.set_update_frequency(60);

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


global.volume = [1, 1, 0.5]; //master, sound, music
audio_master_gain(global.volume[0] * global.volume[1]);
for (var i = 0; i < 2; i++) FMODGMS_Chan_Set_Volume(global.channel[i], global.volume[0] * global.volume[2] * global.levelMusic[(i * 3) + 2]);

//Start intro
pn_level_goto(eLevel.logo);