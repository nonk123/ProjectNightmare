/// @description Draw Intro
var dir = get_timer() / 900, w = wobble * 0.04;
if (image_xscale > 0) draw_sprite_ext(pn_sprite_get_sprite("sprLogo"), 0, 480, 270, 2 * (image_xscale + lengthdir_x(w, dir)), 2 * (image_xscale + lengthdir_y(w, dir)), 0, c_white, 1);
draw_set_halign(fa_center);
draw_set_alpha(image_alpha);
draw_set_color(c_white);
draw_text(480, 398, "Mario (c) Nintendo");
draw_set_alpha(1);
draw_set_halign(fa_left);