/// @description Update Video
if (video_exists(v))
{
	if (video_is_playing(v))
	{
		if (pn_input_pressed_any()) pn_level_goto(eLevel.title);
		video_grab_frame_buffer(v, buffer_get_address(buff));
		isPlaying = true;
	}
	else if (isPlaying) pn_level_goto(eLevel.title);
}
else if (isPlaying) pn_level_goto(eLevel.title);