function pn_input_pressed_any()
{
	var bind = input_check_press_most_recent();
	return (!is_undefined(bind) && input_check_pressed(bind))
}