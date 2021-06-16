#macro mDirLevels "data/levels/"

enum eLevel {logo, title, trailer, debug}

enum eRoomData {model, collision, actors, movers, deadActors}

enum eActorData {_id, _x, _y, z, _direction, _persistent, tag, special}

enum eMoverData {model, collision, tag}

function pn_level_goto(_levelID) { instance_create_depth(0, 0, -1, objLoading).goto = _levelID; }

function pn_level_transition(_levelID, _transition)
{
	if (instance_exists(objTransition)) exit
	with (instance_create_depth(0, 0, -1, objTransition))
	{
		transition = _transition;
		pn_transition_set_timer();
		goto = _levelID;
	}
}

function pn_level_transition_start(_transition)
{
	if (instance_exists(objTransition)) exit
	with (instance_create_depth(0, 0, -1, objTransition))
	{
		transition = _transition;
		pn_transition_set_timer();
		reverse = true;
	}
}

function pn_level_goto_internal(_levelID)
{
	global.level = _levelID;
	global.levelStart = true;
	
	//Remove everything
	for (var i = 0; i < 2; i++)
	{
		FMODGMS_Chan_StopChannel(global.channel[i]);
		FMODGMS_Chan_Set_Volume(global.channel[i], 1 - i);
		var slot = i * 5;
		global.levelMusic[slot + 1] = 1 - i;
		global.levelMusic[slot + 2] = 1 - i;
		objControl.timer[i] = -65536;
	}
	
	with (all) if !(pn_is_internal_object()) instance_destroy();
	
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
		ds_map_delete(global.materials, material);
	}
	repeat (ds_map_size(global.fonts))
	{
		var font = ds_map_find_first(global.fonts), getFont = global.fonts[? font];
		if (is_array(getFont))
		{
			font_delete(getFont[0]);
			sprite_delete(getFont[1]);
		}
		else font_delete(getFont);
		ds_map_delete(global.fonts, font);
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
	
	//Load level file
	var levelFile = mDirLevels + string(_levelID) + ".pnl";
	if (file_exists(levelFile))
	{
		var levelCarton = carton_load(levelFile, true);
		if (levelCarton == -1) show_debug_message("!!! PNLevel: " + string(_levelID) + ".pnl has an invalid file format");
		else
		{
			var levelBuffer = carton_get_buffer(levelCarton, 0);
			buffer_delete(levelBuffer);
			carton_destroy(levelCarton);
		}
	}
	else show_debug_message("!!! PNLevel: Level " + string(_levelID) + " not found");
	
	//Special level code
	switch (_levelID)
	{
		case (eLevel.logo):
			pn_sprite_queue("sprLogo");
			pn_font_queue("fntMario");
			pn_font_queue("fntMessage");
			pn_sound_load("sndCoinIntro");
			pn_sound_load("sndMarioIntro");

			instance_create_depth(0, 0, 0, objIntro);
		break
		
		case (eLevel.title):
			pn_sprite_queue("sprLogo");
			pn_sprite_queue("sprNNLogo");
			pn_sprite_queue("sprSidebar");
			pn_material_queue("mtlVoid");
			pn_font_queue("fntMario");
			pn_sound_load("sndStart");
			pn_sound_load("sndSelect");
			pn_sound_load("sndEnter");
			pn_music_load("musTitle");
			FMODGMS_Snd_PlaySound(global.music[? "musTitle"], global.channel[0]);
			
			pn_level_transition_start(eTransition.circle2);
			instance_create_depth(0, 0, 0, objTitle);
		break
		
		case (eLevel.trailer): instance_create_depth(0, 0, 0, objTrailer); break
	}
	
	pn_room_goto(0); //All levels must start at room 0
}

function pn_room_goto(_roomID)
{
	if !(ds_map_exists(global.levelData, _roomID))
	{
		show_debug_message("!!! PNLevel: Room " + string(_roomID) + " does not exist");
		exit
	}
	
	global.levelRoom = _roomID;
	
	with (all) if (object_index != objControl && object_index != rousrDissonance) instance_destroy();
	ds_list_clear(global.particles);
	
	var roomData = global.levelData[? _roomID], i = 0;
	repeat (ds_list_size(roomData[eRoomData.actors]))
	{
		var actor = roomData[eRoomData.actors][| i];
		
		//Check if actor is "dead" (destroyed while persistent)
		if (global.levelStart && actor[eActorData._persistent])
		{
			var dead = false;
			for (var j = 0; j < ds_list_size(roomData[eRoomData.deadActors]); j++) if (i == roomData[eRoomData.deadActors][| j])
			{
				dead = true;
				break
			}
			if (dead) continue
		}
		
		//Spawn actor
		var actorObject;
		switch (actor[eActorData._id])
		{
			default:
				show_debug_message("!!! PNLevel: Unknown actor ID " + actor[eActorData._id] + " in room " + string(_roomID));
				continue
		}
		with (instance_create_depth(actor[eActorData._x], actor[eActorData._y], 0, actorObject))
		{
			z = actor[eActorData.z];
			faceDirection = actor[eActorData._direction];
			fPersistent = actor[eActorData._persistent];
			tag = actor[eActorData.tag];
			special = actor[eActorData.special];
		}
		
		i++;
	}
}