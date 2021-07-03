/// @description Event Handler
eventID = undefined;
eventList = undefined;
eventListPos = 2;
currentActions = ds_list_create();
active = true;
timer_create();

global.clock.add_cycle_method(function ()
{
	if !(active) exit
	/*shader_set(sh_smf_animate);
	for (var i = 0; i < ds_list_size(currentAction); i = i)
	{
	    switch (currentAction[| i])
	    {
	        case (5): //cutscene_fade_skybox_color(color, ticks)
	            currentAction[| i + 3]++;
	            var progress = currentAction[| i + 3], ticks = currentAction[| i + 4];
	            background_color[0] = merge_colour(currentAction[| i + 1], currentAction[| i + 2], currentAction[| i + 3] / currentAction[| i + 4]);
	            if (progress >= ticks) repeat (5) ds_list_delete(currentAction, i);
	            else i += 5;
	        break
	        case (7): //cutscene_fade_light(color, ticks)
	            currentAction[| i + 19]++;
	            var progress = currentAction[| i + 19], ticks = currentAction[| i + 20], fade = progress / ticks;
	            global.light[0] = lerp(currentAction[| i + 1], currentAction[| i + 2], fade);
	            global.light[1] = lerp(currentAction[| i + 3], currentAction[| i + 4], fade);
	            global.light[2] = lerp(currentAction[| i + 5], currentAction[| i + 6], fade);
	            shader_set_uniform_f(shader_get_uniform(sh_smf_animate, "lightDirection"), global.light[0], global.light[1], global.light[2]);
	            global.light[3] = lerp(currentAction[| i + 7], currentAction[| i + 8], fade);
	            global.light[4] = lerp(currentAction[| i + 9], currentAction[| i + 10], fade);
	            global.light[5] = lerp(currentAction[| i + 11], currentAction[| i + 12], fade);
	            shader_set_uniform_f(shader_get_uniform(sh_smf_animate, "lightColor"), global.light[3], global.light[4], global.light[5], 1);
	            global.light[6] = lerp(currentAction[| i + 13], currentAction[| i + 14], fade);
	            global.light[7] = lerp(currentAction[| i + 15], currentAction[| i + 16], fade);
	            global.light[8] = lerp(currentAction[| i + 17], currentAction[| i + 18], fade);
	            shader_set_uniform_f(shader_get_uniform(sh_smf_animate, "lightAmbient"), global.light[6], global.light[7], global.light[8], 1);
	            if (progress >= ticks) repeat (21) ds_list_delete(currentAction, i);
	            else i += 21;
	        break
	    }
	}
	shader_reset();*/
	timer_tick(0);
	while (timer[0] == -65536)
	{
	    if !(active) break
		
		var action = eventList[| eventListPos];
		
		var actionID = is_array(action) ? action[0] : action;
	    switch (actionID)
	    {
	        case (eEventAction.wait):
				timer[0] = action[1];
				eventListPos++;
			break
			
	        case (eEventAction.waitMessage):
				if (instance_exists(objMessage))
				{
					var nextAction = eventList[| eventListPos + 1];
					if (objMessage.timer[3] && is_array(nextAction) && nextAction[0] == eEventAction._message) eventListPos++;
					else timer[0] = 0;
				}
				else eventListPos++;
			break
			
	        case (eEventAction.waitTrigger): eventListPos++; break
			
	        case (eEventAction.setRoom):
				pn_room_goto(action[1]);
				eventListPos++;
			break
			
	        case (eEventAction.setSkyboxTexture):
				global.skybox = action[1];
				eventListPos++;
			break
			
	        /*case (5): //cutscene_fade_skybox_color(color, ticks)
	            ds_list_add(currentAction, 5, background_color[0], eventList[| eventListPos + 1], 0, eventList[| eventListPos + 2]);
	            eventListPos += 3;
	        break*/
			
	        /*case (6): //cutscene_fade_fog(start, end, color, ticks)
	            //ds_list_add(currentAction, 6, global.fog[0], eventList[| eventListPos + 1], global.fog[1], eventList[| eventListPos + 2], global.fog[2], eventList[| eventListPos + 3], 0, eventList[| eventListPos + 4]);
	            eventListPos += 5;
	        break*/
	        
			/*case (7): //cutscene_fade_light(xn, yn, zn, color, ambientColor, ticks)
	            var color = eventList[| eventListPos + 4], ambientColor = eventList[| eventListPos + 5];
	            ds_list_add(currentAction, 7, global.light[0], eventList[| eventListPos + 1], 
	                                          global.light[1], eventList[| eventListPos + 2], 
	                                          global.light[2], eventList[| eventListPos + 3], 
	                                          global.light[3], color_get_red(color) / 255, 
	                                          global.light[4], color_get_green(color) / 255, 
	                                          global.light[5], color_get_blue(color) / 255, 
	                                          global.light[6], color_get_red(ambientColor) / 255, 
	                                          global.light[7], color_get_green(ambientColor) / 255, 
	                                          global.light[8], color_get_blue(ambientColor) / 255, 
	                                          0, eventList[| eventListPos + 6]);
	            eventListPos += 7;
	        break*/
			
	        case (eEventAction.triggerEvent):
				pn_event_create(action[1]);
				eventListPos++;
			break
			
	        case (eEventAction.gotoLevel):
				pn_level_goto(action[1]);
				eventListPos++;
			break
			
	        case (eEventAction._message):
	            if (instance_exists(objMessage)) with (objMessage)
	            {
	                _message = "";
	                targetMessage = action[1];
	                show = true;
	                timer[1] = 1;
	                timer[3] = -65536;
	            }
	            else instance_create_depth(0, 0, -1, objMessage).targetMessage = action[1];
				eventListPos++;
	        break
			
	        case (eEventAction.lockPlayer):
				global.lockPlayer = action[1];
				eventListPos++;
			break
			
	        case (eEventAction.pauseEvent):
	            var getEventID = action[1];
	            switch (getEventID)
	            {
	                case (-1): with (objEventHandler) active = false; break
	                case (-2): with (objEventHandler) if !(is_undefined(eventID)) active = false; break
	                case (-3): with (objEventHandler) if (is_undefined(eventID)) active = false; break
	                default: with (objEventHandler) if (!is_undefined(eventID) && eventID == getEventID) active = false;
	            }
				eventListPos++;
	        break
			
	        case (eEventAction.resumeEvent):
	            var getEventID = action[1];
	            switch (getEventID)
	            {
	                case (-1): with (objEventHandler) active = true; break
	                case (-2): with (objEventHandler) if !(is_undefined(eventID)) active = true; break
	                case (-3): with (objEventHandler) if (is_undefined(eventID)) active = true; break
	                default: with (objEventHandler) if (!is_undefined(eventID) && eventID == getEventID) active = true;
	            }
				eventListPos++;
	        break
			
	        case (eEventAction.stopEvent):
	            var getEventID = action[1];
	            switch (getEventID)
	            {
	                case (-1): with (objEventHandler) instance_destroy(); break
	                case (-2): with (objEventHandler) if !(is_undefined(eventID)) instance_destroy(); break
	                case (-3): with (objEventHandler) if (is_undefined(eventID)) instance_destroy(); break
	                default: with (objEventHandler) if (!is_undefined(eventID) && eventID == getEventID) instance_destroy();
	            }
				eventListPos++;
	        break
			
			//OTHER MISSING ACTIONS ETC ETC CAMERA.....
			
			case (eEventAction.exclamation):
				var voice = "sndExclamation";
				if (action[2]) switch (action[1])
				{
					case (0): voice = "sndNickObjection"; break
					case (1): voice = "sndNickTakeThat"; break
					case (2): voice = "sndNickHoldIt"; break
				}
				
				instance_create_depth(0, 0, 0, objExclamation).image_index = action[1];
				audio_play_sound(global.sounds[? voice][0], 1, false);
			break
			
	        default:
				show_debug_message("!!! PNEvent: Unknown action " + string(actionID) + " in event " + string(eventID));
				eventListPos++;
	    }
		
		if (is_undefined(eventList[| eventListPos]))
	    {
	        instance_destroy();
	        break
	    }
	}
});