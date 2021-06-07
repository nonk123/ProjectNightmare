/// @description Update Game
if (global.levelStart) global.levelStart = false;
else
{
	input_player_source_set(gamepad_is_connected(0) ? INPUT_SOURCE.GAMEPAD : INPUT_SOURCE.KEYBOARD_AND_MOUSE);
	input_tick();
	global.clock.tick();
}