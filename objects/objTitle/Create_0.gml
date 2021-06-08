//Title variables

enum eMenu {intro, start, main, play, options}
enum eSubmenu {controls, gfx, sfx}

menu = [eMenu.intro, eSubmenu.controls]; //menu, submenu

function pn_option(_name, _disabled, _function) constructor
{
	label = _name;
	xOffset = 0;
	isDisabled = _disabled;
	activate = _function;
}

options = 
[
	undefined,
	undefined,
	[
		new pn_option("Play", false, function()
		{
			menu[0] = eMenu.play;
			option[0] = 2;
		}),
		new pn_option("Options", false, function()
		{
			menu[0] = eMenu.options;
			option[0] = 3;
		}),
		new pn_option("Exit", false, function() { game_end(); })
	],
	[
		new pn_option("Load Game", true, undefined),
		new pn_option("New Game", true, undefined),
		new pn_option("Back", false, function()
		{
			menu[0] = eMenu.main;
			option[0] = 0;
		})
	],
	[
		new pn_option("Controls", true, undefined),
		new pn_option("Graphics", true, undefined),
		new pn_option("Sounds", true, undefined),
		new pn_option("Back", false, function()
		{
			menu[0] = eMenu.main;
			option[0] = 1;
		})
	]
];
submenuOptions = undefined;
option = [0, 0]; //menu, submenu

timer_create();
timer[0] = 510;
animation = 0;
image_alpha = 0;
menuY = 0;

global.clock.variable_interpolate("animation", "animation_smooth");
global.clock.variable_interpolate("image_alpha", "image_alpha_smooth");
global.clock.variable_interpolate("menuY", "menuY_smooth");
global.clock.add_cycle_method(function ()
{
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
			image_alpha -= 0.015;
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
		
		if (input_check_pressed(eBind.jump))
		{
			audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
			getOption.activate();
		}
		
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