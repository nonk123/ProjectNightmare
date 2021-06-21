/// @description Message Box
timer_create();
timer[0] = 10;
timer[1] = 5;
timer[2] = 1;
alarmToggle = false;
show = false;
_message = "";
targetMessage = "";
scale = 0;
audio_play_sound(global.sounds[? "sndMessageOpen"][0], 1, false);

global.clock.variable_interpolate("scale", "scale_smooth");
global.clock.add_cycle_method(function ()
{
	if (timer_tick(0)) if (alarmToggle) instance_destroy();
	else
	{
	    alarmToggle = true;
	    show = true;
	}
	if (timer_tick(1) && _message != targetMessage)
	{
	    audio_play_sound(global.sounds[? "sndMessage"][0], 1, false);
	    timer[1] = 5;
	}
	if (alarmToggle && timer[0] == -65536)
	{
	    if (_message != targetMessage)
	    {
	        if (timer_tick(2))
	        {
	            _message = string_copy(targetMessage, 1, string_length(_message) + 1);
	            timer[2] = 1;
	        }
	        if (input_check_pressed(eBind.jump))
	        {
	            _message = targetMessage;
	            timer[2] = -65536;
	            exit
	        }
	    }
	    if (input_check_pressed(eBind.jump) && show)
	    {
	        timer[3] = 2;
	        show = false;
	    }
	    if (timer_tick(3) && !show)
	    {
	        audio_play_sound(global.sounds[? "sndMessageClose"][0], 1, false);
	        timer[0] = 10;
	    }
	}
	
	if (show) scale = 10;
	else if (alarmToggle) scale = timer[0];
	else scale = (10 - timer[0]);
	scale *= 0.1;
});