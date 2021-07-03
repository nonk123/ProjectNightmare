/// @description Draw Exclamation

var camSize = [camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0])];
draw_sprite_ext(pn_sprite_get_sprite("sprExclamation"), image_index, shake_smooth + camSize[0] * 0.5, shake_smooth + camSize[1] * 0.5, 3, 3, 0, c_white, image_alpha);
if (shakeFactor_smooth > 50)
{
	draw_set_alpha(((shakeFactor_smooth - 50) / 10) * 0.5);
	draw_rectangle(0, 0, camSize[0], camSize[1], false);
	draw_set_alpha(1);
}