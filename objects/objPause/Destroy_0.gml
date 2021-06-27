/// @description End Pause
sprite_delete(background);
FMODGMS_Chan_Set_Volume(global.channel[global.battle], (global.volume[0] * global.volume[2]) * global.levelMusic[(global.battle * 3) + 2]);
global.levelStart = true;
global.PAUSEDEBUG = !global.PAUSEDEBUG;