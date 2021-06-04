/// @description Transition Variables

enum eTransition {loading, circle, circle2, fade}

transition = eTransition.loading;
reverse = false;
goto = noone;

timer_create();

//Update transition
global.clock.add_cycle_method(function ()
{
	if (timer[0] == -65536) switch (transition)
	{
		case (eTransition.loading): timer[0] = 1; break
		case (eTransition.circle):
		case (eTransition.circle2): timer[0] = 60; break
		case (eTransition.fade): timer[0] = 120; break
	}
	else if (timer_tick(0))
	{
		if (goto == noone)
		{
			game_end();
			exit
		}
	
		if (transition == eTransition.loading) pn_level_goto_internal(goto);
		else pn_level_goto(goto);
	
		instance_destroy();
	}
});