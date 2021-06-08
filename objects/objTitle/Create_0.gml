//Title variables

enum eMenu {intro, start, main, play, options}
enum eSubmenu {controls, gfx, sfx}

menu = [eMenu.intro, eSubmenu.controls]; //menu, submenu

function pn_option(_name, _disabled, _function, _unlockCondition) constructor
{
	label = _name;
	xOffset = 0;
	isDisabled = _disabled;
	activate = _function;
	unlockCondition = _unlockCondition;
}

options = 
[
	undefined,
	undefined,
	[
		new pn_option("Play", false, function()
		{
			audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
			menu[0] = eMenu.play;
			option[0] = options[eMenu.play][0].isDisabled;
		}, undefined),
		new pn_option("Options", false, function()
		{
			audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
			menu[0] = eMenu.options;
			option[0] = 3;
		}, undefined),
		new pn_option("Exit", false, function()
		{
			audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
			pn_music_gain(0, 0, 90);
			timer[1] = 60;
			leaveTitle = function() { pn_level_transition(noone, eTransition.circle2); };
		}, undefined)
	],
	[
		new pn_option("Load Game", true, undefined, undefined),
		new pn_option("New Game", false, function()
		{
			audio_play_sound(global.sounds[? "sndStart"][0], 1, false);
			pn_music_gain(0, 0, 90);
			image_alpha = 0.25;
			timer[1] = 80;
			leaveTitle = function() { pn_level_transition(eLevel.debug, eTransition.circle2); };
		}, undefined),
		new pn_option("Back", false, function()
		{
			audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
			menu[0] = eMenu.main;
			option[0] = 0;
		}, undefined)
	],
	[
		new pn_option("Controls", true, undefined, undefined),
		new pn_option("Graphics", true, undefined, undefined),
		new pn_option("Sounds", true, undefined, undefined),
		new pn_option("Back", false, function()
		{
			audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
			menu[0] = eMenu.main;
			option[0] = 1;
		}, undefined)
	]
];
submenuOptions = undefined;
option = [0, 0]; //menu, submenu

leaveTitle = undefined;

timer_create();
timer[0] = 450;
animation = 0;
image_alpha = 0;
menuY = 0;

global.clock.variable_interpolate("animation", "animation_smooth");
global.clock.variable_interpolate("image_alpha", "image_alpha_smooth");
global.clock.variable_interpolate("menuY", "menuY_smooth");
global.clock.add_cycle_method(function ()
{
	if (menu[0] > eMenu.intro) image_alpha -= 0.015;
	if (timer_tick(1)) leaveTitle();
	if (instance_exists(objTransition) || timer[1] >= 0) exit
	
	switch (menu[0])
	{
		case (eMenu.intro):
			if (timer[0] <= 270) animation = lerp(animation, 1, 0.02);
			image_alpha = clamp(image_alpha + (timer[0] <= 200 ? -0.01 : 0.01), 0, 1);
			if (timer_tick(0) || pn_input_pressed_any())
			{
				image_alpha = 1;
				image_alpha_smooth = 1;
				timer[0] = -65536;
				animation = 0;
				animation_smooth = 0;
				menu[0] = eMenu.start;
			}
		break
		
		case (eMenu.start):
			if (timer[0] == -65536 && pn_input_pressed_any())
			{
				audio_play_sound(global.sounds[? "sndStart"][0], 1, false);
				image_alpha = 0.25;
				timer[0] = 80;
			}
			if (timer_tick(0)) menu[0] = eMenu.main;
		break

	}
	
	if (menu[0] != eMenu.intro && menu[0] != eMenu.start)
	{
		var getMenu = options[menu[0]], menuSize = array_length(getMenu), getOption = getMenu[option[0]];
		
		if (input_check_pressed(eBind.up) || input_check_pressed(eBind.down))
		{
			audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
			var changing = true;
			while (changing || getOption.isDisabled)
			{
				option[0] = (option[0] + input_check_pressed(eBind.down) - input_check_pressed(eBind.up)) mod (menuSize);
				if (option[0] < 0) option[0] += menuSize;
				changing = false;
				getOption = getMenu[option[0]];
			}
		}
		
		if (input_check_pressed(eBind.jump)) getOption.activate();
		
		animation = lerp(animation, 1, 0.045);
		
		var i = 0;
		repeat (array_length(options))
		{
			if (i >= eMenu.main)
			{
				var j = 0;
				repeat (array_length(options[i]))
				{
					options[i][j].xOffset = lerp(options[i][j].xOffset, (menu[0] == i && option[0] == j) * 32, 0.1);
					j++;
				}
			}
			i++;
		}
		
		menuY = lerp(menuY, -(option[0] + 0.5) / menuSize, 0.1);
	}
});