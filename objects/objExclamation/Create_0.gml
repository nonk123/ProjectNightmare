/// @description Exclamation

shake = 0;
shakeFactor = 60;
image_speed = 0;

global.clock.variable_interpolate("shake", "shake_smooth");
global.clock.variable_interpolate("shakeFactor", "shakeFactor_smooth");
global.clock.variable_interpolate("image_alpha", "image_alpha_smooth");
global.clock.add_cycle_method(function ()
{
	if (image_alpha <= 0)
	{
		instance_destroy();
		exit
	}
	if (shakeFactor > 30)
	{
		var realShakeFactor = shakeFactor - 30;
		shake = irandom_range(-realShakeFactor, realShakeFactor);
	}
	if !(shakeFactor) image_alpha -= 0.01;
	else shakeFactor--;
});