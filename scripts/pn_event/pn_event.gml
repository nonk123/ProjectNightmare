enum eEventAction
{
	wait,
	waitMessage,
	waitTrigger,
	setRoom,
	setSkyboxTexture,
	fadeSkyboxColor,
	fadeFog,
	fadeLight,
	triggerEvent,
	gotoLevel,
	_message,
	lockPlayer,
	pauseEvent,
	resumeEvent,
	stopEvent,
	restoreCamera,
	lockCamera,
	lockCameraToActor,
	lockCameraToPosition,
	unlockCameraDirection,
	setCameraPosition,
	setCameraRoll,
	setCameraFOV,
	setCameraTarget,
	lerpCamera
}

function pn_event_create(_eventID)
{
	/*Creates an event handler that will cycle through the actions in an event list.
	
	If the event handler is related to a level event, eventID must be a level event's ID.
	Otherwise, set eventID to -1 for persistent non-level events.
	
	Non-level event handlers are more flexible than ones defined by the level, since they are tied to the game's code.*/
	
	var eventHandler = instance_create_depth(0, 0, 0, objEventHandler);
	
	with (eventHandler) if (_eventID == -1)
	{
	    eventList = ds_list_create();
	    ds_list_add(eventList, false, true);
	}
	else
	{
	    eventID = _eventID;
	    eventList = global.events[? _eventID];
	}
	
	return (eventHandler)
}

function pn_event_find_actions(_actionID)
{
	//Finds all event actions with the corresponding ID in every event and returns them in an array.
	//Useful for asset-related actions.
	var actions = [];
	for (var key = ds_map_find_first(global.events), i, eventList; !is_undefined(key); key = ds_map_find_next(global.events, key))
	{
	    eventList = global.events[? key];
	    for (i = 2; i < ds_list_size(eventList); i++)
	    {
			var action = eventList[| i], actionID = is_array(action) ? action[0] : action;
	        if (actionID == _actionID) actions[@ array_length(actions)] = action;
	    }
	}
	return (actions)
}

//Waits for the specified amount of ticks before going to the next action.
function pn_event_wait(_ticks) { ds_list_add(eventList, [eEventAction.wait, _ticks]); }

//Waits until there are no active message boxes before going to the next action.
function pn_event_wait_message() { ds_list_add(eventList, eEventAction.waitMessage); }

//Waits until the player has left the event's trigger area (if there are any) before going to the next action.
function pn_event_wait_trigger() { ds_list_add(eventList, eEventAction.waitTrigger); }

//Changes the current room in the level.
function pn_event_set_room(_roomID) { ds_list_add(eventList, [eEventAction.setRoom, _roomID]); }

//Changes the level's skybox texture.
function pn_event_set_skybox_texture(_materialName) { ds_list_add(eventList, [eEventAction.setSkyboxTexture, _materialName]); }

//Fades the level's current skybox color to the new one within the specified amount of ticks.
function pn_event_fade_skybox_color(_color, _ticks) { ds_list_add(eventList, [eEventAction.fadeSkyboxColor, _color, _ticks]); }

//Fades the level's current fog settings to the new ones within the specified amount of ticks.
function pn_event_fade_fog(_start, _end, _color, _alpha, _ticks) { ds_list_add(eventList, [eEventAction.fadeFog, _start, _end, _color, _alpha, _ticks]); }

//Fades the level's current light settings to the new ones within the specified amount of ticks.
function pn_event_fade_light(_xNormal, _yNormal, _zNormal, _color, _alpha, _ambientColor, _ambientAlpha, _ticks) { ds_list_add(eventList, [eEventAction.fadeLight, _xNormal, _yNormal, _zNormal, _color, _alpha, _ambientColor, _ambientAlpha, _ticks]); }

//Triggers another event corresponding to the specified event ID. This can also be used to loop an event.
function pn_event_trigger_event(_eventID) { ds_list_add(eventList, [eEventAction.triggerEvent, _eventID]); }

//Moves to another level. This will end all ongoing events in the process, including persistent ones.
function pn_event_goto_level(_levelID) { ds_list_add(eventList, [eEventAction.gotoLevel, _levelID]); }

//Brings up a message box.
function pn_event_message(_string) { ds_list_add(eventList, [eEventAction._message, _string]); }

//Locks/unlocks the player's controls, making them unable/able to move. This also disables the ability to pause the game.
function pn_event_lock_player(_bool) { ds_list_add(eventList, [eEventAction.lockPlayer, _bool]); }

/*Pauses all event handlers with the corresponding event ID.
Pauses all events if set to "-1".
Pauses all level events if set to "-2".
Pauses all non-level events if set to "-3".*/
function pn_event_pause_event(_eventID) { ds_list_add(eventList, [eEventAction.pauseEvent, _eventID]); }

/*Resumes all event handlers with the corresponding event ID.
Resumes all events if set to "-1".
Resumes all level events if set to "-2".
Resumes all non-level events if set to "-3".*/
function pn_event_resume_event(_eventID) { ds_list_add(eventList, [eEventAction.resumeEvent, _eventID]); }

/*Stops all event handlers with the corresponding event ID.
Stops all events if set to "-1".
Stops all level events if set to "-2".
Stops all non-level events if set to "-3".*/
function pn_event_stop_event(_eventID) { ds_list_add(eventList, [eEventAction.stopEvent, _eventID]); }

//more yet to come