/// @description Destroy Actor
if (fPersistent && uID != -1) ds_list_add(global.levelData[? global.levelRoom][eRoomData.deadActors], uID);
if (audio_emitter_exists(emitter)) audio_emitter_free(emitter);