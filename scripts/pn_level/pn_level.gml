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
	
	for (var i = 0; i < 2; i++) FMODGMS_Chan_StopChannel(global.channel[i]);
	
	with (all) if !(pn_is_internal_object()) instance_destroy();
	
	ds_map_clear(global.events);
	
	//Unload assets
	if !(is_undefined(global.skybox[1]))
	{
		vertex_delete_buffer(global.skybox[1]);
		global.skybox[1] = undefined;
	}
	repeat (ds_map_size(global.sprites))
	{
		var sprite = ds_map_find_first(global.sprites), getSprite = global.sprites[? sprite][0];
		if (is_array(getSprite))
		{
			var submodels = getSprite[0], bodygroups = getSprite[1], i = 0;
			repeat (array_length(submodels))
			{
				vertex_delete_buffer(submodels[i][0]);
				i++;
			}
			i = 0;
			repeat (array_length(bodygroups))
			{
				var getBodygroup = bodygroups[i], j = 0;
				repeat (array_length(getBodygroup) * 0.5)
				{
					vertex_delete_buffer(getBodygroup[j]);
					j += 2;
				}
				i++;
			}
			ds_list_clear(SMF_bindList);
			ds_list_clear(SMF_bindLocalList);
			for (var i = 0; i < ds_list_size(SMF_frameList); i++) ds_grid_destroy(SMF_frameList[| i]);
			ds_list_clear(SMF_frameList);
		}
		else sprite_delete(getSprite);
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
			var currentLevelBuffer = carton_get_buffer(levelCarton, 0);
			
			//Level information
			global.levelName = buffer_read(currentLevelBuffer, buffer_string);
			global.levelIcon = buffer_read(currentLevelBuffer, buffer_string);
			
			rousr_dissonance_set_details(global.levelName);
			rousr_dissonance_set_large_image(global.levelIcon);
			
			for (var i = 0; i < 6; i += 5)
			{
				global.levelMusic[i] = buffer_read(currentLevelBuffer, buffer_string);
				if (global.levelMusic[i] == "") global.levelMusic[i] = noone;
				else pn_music_load(global.levelMusic[i]);
			}
			
			global.skybox[0] = buffer_read(currentLevelBuffer, buffer_string);
			if (global.skybox[0] == "") global.skybox[0] = noone;
			else
			{
				global.skybox[1] = smf_model_load("data/gfx/skybox.smf");
				pn_material_queue(global.skybox[0]);
			}
			
			for (var i = 0; i < 3; i++) global.skyboxColor[i] = buffer_read(currentLevelBuffer, buffer_u8);
			for (var i = 0; i < 2; i++) global.fogDistance[i] = buffer_read(currentLevelBuffer, buffer_u32);
			for (var i = 0; i < 4; i++) global.fogColor[i] = buffer_read(currentLevelBuffer, buffer_u8);
			for (var i = 0; i < 3; i++) global.lightNormal[i] = buffer_read(currentLevelBuffer, buffer_s8);
			for (var i = 0; i < 4; i++) global.lightColor[i] = buffer_read(currentLevelBuffer, buffer_u8);
			for (var i = 0; i < 4; i++) global.lightAmbientColor[i] = buffer_read(currentLevelBuffer, buffer_u8);
			
			var events = buffer_read(currentLevelBuffer, buffer_u16), rooms = buffer_read(currentLevelBuffer, buffer_u16);
			
			buffer_delete(currentLevelBuffer);
			
			//Events
			show_debug_message(string(events) + " events found");
			for (var i = 1, n = events + 1; i < n; i++)
			{
				var loadEvent = ds_list_create(), j = 3;
				
				currentLevelBuffer = carton_get_buffer(levelCarton, i);
				
				for (var j = 0; j < 2; j++) ds_list_add(loadEvent, buffer_read(currentLevelBuffer, buffer_u8));
				repeat (buffer_read(currentLevelBuffer, buffer_u16))
				{
					var actionData = string_parse(buffer_read(currentLevelBuffer, buffer_string), true), eventAction, actionArgs = array_length(actionData), j = 0;
					if (actionArgs == 1) eventAction = actionData[0]; //Action has no arguments, therefore a string
					else
					{
						eventAction = [];
						repeat (actionArgs)
						{
							eventAction[@ array_length(eventAction)] = actionData[j];
							j++;
						}
					}
					ds_list_add(loadEvent, eventAction);
				}
				
				buffer_delete(currentLevelBuffer);
				
				var eventID = carton_get_metadata(levelCarton, i);
				show_debug_message(string(i) + "/" + string(n - 1) + ", ID " + eventID + ", " + string(ds_list_size(loadEvent)) + " actions");
				ds_map_add_list(global.events, real(eventID), loadEvent);
			}
			
			//Event assets
			var actions = pn_event_find_actions(eEventAction.setSkyboxTexture), i = 0;
			repeat (array_length(actions))
			{
				pn_material_queue(actions[i][1]);
				i++;
			}
			
			if (array_length(pn_event_find_actions(eEventAction._message)))
			{
				pn_font_queue("fntMessage");
				pn_sound_load("sndMessageOpen");
				pn_sound_load("sndMessage");
				pn_sound_load("sndMessageClose");
			}
			
			var actions = pn_event_find_actions(eEventAction.exclamation);
			if (array_length(actions))
			{
				pn_sprite_queue("sprExclamation");
				i = 0;
				repeat (array_length(actions))
				{
					var voice = "sndExclamation";
					if (actions[i][2]) switch (actions[i][1])
					{
						case (0): voice = "sndNickObjection"; break
						case (1): voice = "sndNickTakeThat"; break
						case (2): voice = "sndNickHoldIt"; break
					}
					pn_sound_load(voice);
					i++;
				}
			}
			
			carton_destroy(levelCarton);
		}
	}
	else show_debug_message("!!! PNLevel: Level " + string(_levelID) + " not found");
	
	pn_room_goto(0); //All levels must start at room 0
	
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
			
			pn_level_transition_start(eTransition.circle2);
			instance_create_depth(0, 0, 0, objTitle);
		break
		
		case (eLevel.trailer): instance_create_depth(0, 0, 0, objTrailer); break
		
		case (eLevel.debug):
			pn_actor_create(objCamera, 0, 0, 10, 0);
			pn_sprite_queue("sprMario");
			pn_sprite_queue("sprLogo");
			pn_sprite_queue("sprSidebar");
			pn_sprite_queue("sprPauseMario");
			pn_sprite_queue("sprPauseLink");
			pn_font_queue("fntMario");
			pn_font_queue("fntZelda");
			pn_sound_load("sndPauseMario");
			pn_sound_load("sndPauseLink");
			pn_sound_load("sndPauseOpen");
			pn_sound_load("sndPauseClose");
			pn_sound_load("sndSelect");
			pn_actor_create(objPlayer, 32, 0, 0, 180);
			
			pn_sprite_queue("sprExclamation");
			pn_sound_load("sndExclamation");
			instance_create_depth(0, 0, 0, objExclamation);
			audio_play_sound(global.sounds[? "sndExclamation"][0], 1, false);
		break
	}
	
	//Activate events that are flagged to trigger on level start
	for (var key = ds_map_find_first(global.events); !is_undefined(key); key = ds_map_find_next(global.events, key)) if (global.events[? key][| 0]) pn_event_create(key);
	
	//Start music
	global.battle = false;
	for (var i = 0; i < 6; i += 5)
	{
		var slot = i == 5;
		global.levelMusic[i + 1] = 1 - slot;
		global.levelMusic[i + 2] = 1 - slot;
		objControl.timer[slot] = -65536;
		if (global.levelMusic[i] != noone) FMODGMS_Snd_PlaySound(global.music[? global.levelMusic[i]], global.channel[slot]);
	}
	FMODGMS_Chan_Set_Volume(global.channel[0], global.volume[0] * global.volume[2]);
	FMODGMS_Chan_Set_Volume(global.channel[1], 0);
}

function pn_room_goto(_roomID)
{
	if !(ds_map_exists(global.levelData, _roomID))
	{
		show_debug_message("!!! PNLevel: Room " + string(_roomID) + " does not exist");
		exit
	}
	
	global.levelRoom = _roomID;
	
	with (all) switch (object_index)
	{
		case (objControl):
		case (rousrDissonance):
		case (objCamera): continue break
		
		case (objEventHandler): if !(eventList[| 1]) instance_destroy(); break
		
		default: instance_destroy();
	}
	
	ds_list_clear(global.particles);
	
	var roomActors = global.levelData[? _roomID][eRoomData.actors], i = 0;
	if (is_undefined(roomActors)) exit
	repeat (array_length(roomActors))
	{
		var actor = roomActors[i];
		
		//Check if actor is "dead" (destroyed while persistent)
		if (global.levelStart && actor[eActorData._persistent])
		{
			var dead = false;
			for (var j = 0; j < ds_list_size(roomData[eRoomData.deadActors]); j++) if (i == roomData[eRoomData.deadActors][| j])
			{
				dead = true;
				break
			}
			if (dead)
			{
				i++;
				continue
			}
		}
		
		//Spawn actor
		var actorObject;
		switch (actor[eActorData._id])
		{
			default:
				show_debug_message("!!! PNLevel: Unknown actor ID " + actor[eActorData._id] + " in room " + string(_roomID));
				continue
		}
		with (pn_actor_create(actorObject, actor[eActorData._x], actor[eActorData._y], actor[eActorData.z], actor[eActorData._direction]))
		{
			fPersistent = actor[eActorData._persistent];
			tag = actor[eActorData.tag];
			special = actor[eActorData.special];
		}
		
		i++;
	}
}

function pn_actor_create(_object, _x, _y, _z, _faceDirection)
{
	var actor = instance_create_depth(_x, _y, 0, _object);
	with (actor)
	{
		z = _z;
		faceDirection = _faceDirection;
		yaw = _faceDirection;
		postInitialize();
	}
	return (actor)
}