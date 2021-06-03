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

colmesh_init();

/*----------
GAME SYSTEMS
----------*/

//Level

global.level = undefined;
global.levelRoom = 0;
global.levelName = "Loading";
global.levelIcon = "largeicon0";

//Update loop

levelStart = true;
global.deltaTime = 1;
gameLoop = 0;

//Start intro

pn_level_goto(eLevel.logo);