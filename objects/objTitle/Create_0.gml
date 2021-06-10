//Title variables

enum eMenu {intro, start, main, play, options}
enum eSubmenu {controls, graphics, sounds}

menu = [eMenu.intro, eSubmenu.controls]; //menu, submenu

function pn_option(_name, _disabled, _function, _unlockCondition, _state) constructor
{
	label = _name;
	xOffset = 0;
	isDisabled = _disabled;
	activate = _function;
	unlockCondition = _unlockCondition;
	state = _state;
}

//options = [menu, submenu]
options = 
[
	[
		undefined,
		undefined,
		[
			new pn_option("Play", false, function()
			{
				audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
				menu[0] = eMenu.play;
				option[0] = options[eMenu.play][0].isDisabled;
			}, undefined, false),
			new pn_option("Options", false, function()
			{
				audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
				menu[0] = eMenu.options;
				option[0] = 0;
			}, undefined, false),
			new pn_option("Exit", false, function()
			{
				audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
				pn_music_gain(0, 0, 90);
				timer[1] = 60;
				leaveTitle = function() { pn_level_transition(noone, eTransition.circle2); };
			}, undefined, false)
		],
		[
			new pn_option("Load Game", true, undefined, undefined, false),
			new pn_option("New Game", false, function()
			{
				audio_play_sound(global.sounds[? "sndStart"][0], 1, false);
				pn_music_gain(0, 0, 90);
				image_alpha = 0.25;
				timer[1] = 80;
				leaveTitle = function() { pn_level_transition(eLevel.debug, eTransition.circle2); };
			}, undefined, false),
			new pn_option("Back", false, function()
			{
				audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
				menu[0] = eMenu.main;
				option[0] = 0;
			}, undefined, false)
		],
		[
			new pn_option("Controls", false, function()
			{
				if (menu[1] != eSubmenu.controls)
				{
					audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
					menu[1] = eSubmenu.controls;
					option[1] = 2;
				}
			}, undefined, false),
			new pn_option("Graphics", false, function()
			{
				if (menu[1] != eSubmenu.graphics)
				{
					audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
					menu[1] = eSubmenu.graphics;
					option[1] = 0;
				}
			}, undefined, false),
			new pn_option("Sounds", false, function()
			{
				if (menu[1] != eSubmenu.sounds)
				{
					audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
					menu[1] = eSubmenu.sounds;
					option[1] = 0;
				}
			}, undefined, false),
			new pn_option("Back", false, function()
			{
				audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
				isInSubmenu = false;
				menu[0] = eMenu.main;
				option[0] = 1;
			}, undefined, false)
		]
	],
	[
		[
			new pn_option("Current Device", true, undefined, undefined, input_player_source_get() == INPUT_SOURCE.GAMEPAD ? "Gamepad" : "M+KB"),
			undefined,
			new pn_option("Mouselook", false, function ()
			{
				audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
				global.mouselook = !global.mouselook;
				options[1][0][2].state = global.mouselook ? "On" : "Off";
			}, function() { return (input_player_source_get() == INPUT_SOURCE.KEYBOARD_AND_MOUSE) }, global.mouselook ? "On" : "Off"),
			undefined,
			new pn_option("Apply", false, undefined, undefined, undefined),
			new pn_option("Revert", false, undefined, undefined, undefined)
		],
		[],
		[]
	]
];
option = [0, 2]; //menu, submenu
isInSubmenu = false;
checkBind = false;

leaveTitle = undefined;

timer_create();
timer[0] = 450;
animation = 0;
image_alpha = 0;
menuY = 0;
submenuX = camera_get_view_width(view_camera[0]);

global.clock.variable_interpolate("animation", "animation_smooth");
global.clock.variable_interpolate("image_alpha", "image_alpha_smooth");
global.clock.variable_interpolate("menuY", "menuY_smooth");
global.clock.variable_interpolate("submenuX", "submenuX_smooth");
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
		for (var i = 0; i < 2; i++)
		{
			if (!i && isInSubmenu) continue
			if (i && !isInSubmenu) break
			
			var getMenu = options[i][menu[i]], menuSize = array_length(getMenu), getOption = getMenu[option[i]];
		
			//Cycle options
			if (input_check_pressed(eBind.up) || input_check_pressed(eBind.down))
			{
				audio_play_sound(global.sounds[? "sndSelect"][0], 1, false);
				var changing = true;
				while (changing || is_undefined(getOption) || getOption.isDisabled)
				{
					option[i] = (option[i] + input_check_pressed(eBind.down) - input_check_pressed(eBind.up)) mod (menuSize);
					if (option[i] < 0) option[i] += menuSize;
					changing = false;
					getOption = getMenu[option[i]];
				}
			}
		
			//Activate selected option
			if (input_check_pressed(eBind.jump))
			{
				var optionFunction = getOption.activate;
				if !(is_undefined(optionFunction)) optionFunction();
			}
		}
		
		//Cycle between menu and submenu
		if (menu[0] == eMenu.options && (input_check_pressed(eBind.left) || input_check_pressed(eBind.right))) isInSubmenu = input_check_pressed(eBind.right);
		
		animation = lerp(animation, 1, 0.045);
		
		//Option select animation & unlocking
		var k = 0;
		repeat (2)
		{
			var i = 0;
			repeat (array_length(options[k]))
			{
				if (i >= eMenu.main)
				{
					var j = 0;
					repeat (array_length(options[k][i]))
					{
						if (is_undefined(options[k][i][j]))
						{
							j++;
							continue
						}
						if !(k) options[0][i][j].xOffset = lerp(options[0][i][j].xOffset, (menu[0] == i && option[0] == j) * 32, 0.1);
						var checkUnlock = options[k][i][j].unlockCondition;
						if !(is_undefined(checkUnlock)) options[k][i][j].isDisabled = !checkUnlock();
						j++;
					}
				}
				i++;
			}
			k++;
		}
		
		menuY = lerp(menuY, -(option[0] + 0.5) / menuSize, 0.1);
		submenuX = lerp(submenuX, (menu[0] != eMenu.options) * camera_get_view_width(view_camera[0]), 0.25);
		
		options[1][0][0].state = input_player_source_get() == INPUT_SOURCE.GAMEPAD ? "Gamepad" : "M+KB";
	}
});