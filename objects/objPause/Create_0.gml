/// @description Start Pause

global.levelStart = true; //Freeze the game without delta timing to prevent frameskipping on pause animation

background = sprite_create_from_surface(application_surface, 0, 0, surface_get_width(application_surface), surface_get_height(application_surface), false, false, 0, 0);
animation = -463;
exiting = false;

option = 0;
optionX = [0, 0, 0];

confirm = false;
confirmOption = true;
confirmAnimation = 0;

timer_create();

FMODGMS_Chan_Set_Volume(global.channel[global.battle], ((global.volume[0] * global.volume[2]) * global.levelMusic[(global.battle * 3) + 2]) * 0.5);
audio_play_sound(global.PAUSEDEBUG ? global.sounds[? "sndPauseLink"][0] : global.sounds[? "sndPauseMario"][0], 1, false);

global.clock.variable_interpolate("animation", "animation_smooth");
global.clock.variable_interpolate("confirmAnimation", "confirmAnimation_smooth");
global.clock.add_cycle_method(function ()
{
	if !(exiting)
	{
		animation = lerp(animation, 0, 0.2);
		confirmAnimation = clamp(confirmAnimation + (confirm ? 0.075 : -0.075), 0, 1);
		if (timer[0] == -65536) if (confirm && confirmAnimation > 0)
		{
			if (confirmAnimation == 1)
			{
				if (input_check_pressed(eBind.left) || input_check_pressed(eBind.right))
				{
					confirmOption = !confirmOption;
					audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
				}
				if (input_check_pressed(eBind.jump))
				{
					if (confirmOption)
					{
						timer[0] = 60;
						audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
					}
					else
					{
						confirm = false;
						audio_play_sound(global.sounds[? "sndPauseClose"][0], 1, false);
					}
				}
				if (input_check_pressed(eBind.pause))
				{
					confirm = false;
					audio_play_sound(global.sounds[? "sndPauseClose"][0], 1, false);
				}
			}
		}
		else if (ceil(animation) == 0 && !instance_exists(objTransition))
		{
			var up = input_check_pressed(eBind.up), down = input_check_pressed(eBind.down);
			if (up || down)
			{
				option += down - up;
				option = ((option) mod (3)) + (option < 0) * 3;
				audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
			}
			if (input_check_pressed(eBind.jump))
			{
				if (option == 2)
				{
					confirm = true;
					confirmOption = true;
					audio_play_sound(global.sounds[? "sndPauseOpen"][0], 1, false);
				}
				else audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
			}
			if (input_check_pressed(eBind.pause))
			{
				animation = 0;
				exiting = true;
				audio_play_sound(global.sounds[? "sndPauseClose"][0], 1, false);
			}
		}
	}
	else
	{
		if (animation >= -463) animation -= 25;
		else
		{
			instance_activate_all();
			instance_destroy();
		}
	}
	
	for (var i = 0; i < 3; i++) optionX[i] = lerp(optionX[i], (option == i) * -32, 0.2);
	
	if (timer_tick(0)) pn_level_transition(eLevel.title, eTransition.circle);
	
	if (instance_exists(objTransition) && objTransition.timer[0] == 0) instance_activate_all();
});