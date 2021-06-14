/// @description Draw Transition

if !(surface_exists(surface)) surface = surface_create(camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]));

surface_set_target(surface);
switch (transition)
{	
	case (eTransition.circle2):
		draw_set_color(c_black);
		draw_rectangle(0, 0, surface_get_width(surface), surface_get_height(surface), false);
		draw_set_color(c_white);
		gpu_set_blendmode(bm_subtract);
		draw_circle(surface_get_width(surface) * 0.5, surface_get_height(surface) * 0.5, ((reverse ? (60 - timer[0]) : timer[0]) / 60) * surface_get_width(surface), false);
		gpu_set_blendmode(bm_normal);
	break
	
	case (eTransition.fade):
		draw_set_color(c_black);
		draw_set_alpha((reverse ? timer[0] : (120 - timer[0])) / 120);
		draw_rectangle(0, 0, surface_get_width(surface), surface_get_height(surface), false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	break
	
	default:
		draw_set_font(fntInternal);
		draw_set_color(c_white);
		draw_set_halign(fa_center);
		draw_set_valign(fa_center);
		draw_text(480, 270, transition == eTransition.loading ? "Loading" : "Transition");
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
}
surface_reset_target();

draw_surface_stretched(surface, 0, 0, surface_get_width(application_surface), surface_get_height(application_surface));