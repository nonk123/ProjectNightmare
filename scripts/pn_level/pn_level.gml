enum eLevel
{
	logo = -1,
	title, debug
}

function pn_level_goto(_roomID) { pn_level_transition(_roomID, eTransition.loading); }

function pn_level_transition(_roomID, _transition)
{
	with (instance_create_depth(0, 0, 0, objTransition))
	{
		transition = _transition;
		goto = _roomID;
	}
}

function pn_level_goto_internal(_roomID)
{
	global.level = _roomID;
	
	//Remove everything
	for (var i = 0; i < 2; i++)
	{
		FMODGMS_Chan_StopChannel(global.channel[i]);
		FMODGMS_Chan_Set_Volume(global.channel[i], 1 - i);
	}
	global.levelMusic[1] = global.levelMusic[2] = 1;
	global.levelMusic[4] = global.levelMusic[5] = 0;
	
	with (all) if (object_index != objControl && object_index != rousrDissonance) instance_destroy();
	
	//Unload assets
	repeat (ds_map_size(global.sprites))
	{
		var sprite = ds_map_find_first(global.sprites), getSprite = global.sprites[? sprite][0];
		if !(is_array(getSprite)) sprite_delete(getSprite);
		ds_map_delete(global.sprites, sprite);
	}
	repeat (ds_map_size(global.materials))
	{
		var material = ds_map_find_first(global.materials);
		sprite_delete(global.materials[? material][0]);
		ds_map_delete(global.sprites, material);
	}
	repeat (ds_map_size(global.sounds))
	{
		var sound = ds_map_find_first(global.sounds);
		audio_destroy_stream(global.sounds[? sound][0]);
		ds_map_delete(global.sounds, sound);
	}
	repeat (ds_map_size(global.music))
	{
		var track = ds_map_find_first(global.music);
		FMODGMS_Snd_Unload(global.music[? track]);
		ds_map_delete(global.music, track);
	}
	
	//Special level code
	switch (_roomID)
	{
		case (eLevel.logo):
			pn_sprite_queue("sprLogo");
			pn_sound_load("sndCoinIntro");
			pn_sound_load("sndMarioIntro");

			instance_create_depth(480, 270, 0, objIntro);
		break
	}
}