//Timers replace Alarm events due to the game engine's logic system.

function timer_create() {timer = array_create(12, -65536);}

/// @description timer_tick(slot)
/// @param slot
function timer_tick(_slot)
{
	//Returns true if the alarm is ready to perform an event.
	var t = timer[_slot];
	if (t != -65536)
	{
	    timer[_slot]--;
	    if (t <= 0)
	    {
	        timer[_slot] = -65536;
	        return (true)
	    }
	}
	return (false)
}