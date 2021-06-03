/// @description Initialize Game

/*--------
ASSET MAPS
--------*/

global.sprites = ds_map_create();
global.materials = ds_map_create();
global.sounds = ds_map_create();
global.music = ds_map_create();

/*-----
SYSTEMS
-----*/

rousr_dissonance_create("732560402873057320");
rousr_dissonance_set_details("Loading");
rousr_dissonance_set_large_image("largeicon0");

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

//Music

global.channel = [FMODGMS_Chan_CreateChannel(), FMODGMS_Chan_CreateChannel()]; //normal, battle
global.levelMusic = [noone, 1, 1, noone, 0, 0]; //normal, volume, target volume, battle, volume, target volume
global.battle = false;

//Update loop

global.levelStart = true;
global.deltaTime = 1;
gameLoop = 0;

//Settings

global.bind = undefined;
global.volume = [1, 1, 0.5]; //master, sound, music

audio_master_gain(global.volume[0] * global.volume[1]);
for (var i = 0; i < 2; i++) FMODGMS_Chan_Set_Volume(global.channel[i], global.volume[0] * global.volume[2] * global.levelMusic[(i * 3) + 2]);

//Start intro

pn_level_goto(eLevel.logo);