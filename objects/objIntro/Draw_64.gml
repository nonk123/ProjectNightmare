/// @description Draw Intro
if (state < 7)
{
	var dir = get_timer() / 900, w = wobble * 0.04;
	if (image_xscale > 0) draw_sprite_ext(pn_sprite_get_sprite("sprLogo"), 0, 480, 270, 2 * (image_xscale + lengthdir_x(w, dir)), 2 * (image_xscale + lengthdir_y(w, dir)), 0, c_white, 1);
	draw_set_halign(fa_center);
	draw_set_alpha(image_alpha);
	draw_set_color(c_white);
	draw_text(480, 398, "EARLY DEMO");
	draw_set_alpha(1);
	draw_set_halign(fa_left);
}
else
{
	draw_set_halign(fa_center);
	draw_set_alpha(image_alpha);
	draw_set_color(c_white);
	draw_text_transformed(480, 64, "DISCLAIMER", 2, 2, 0);
	draw_set_valign(fa_center);
	draw_text(480, 284, "This is an UNOFFICIAL NON-PROFIT fan game. It is open-sourced and freeware, and will always be.\nWe do not hold any licenses nor copyrights. This game must NOT be sold.\n\n\"If somebody sold you that game, please call the nearest government police station,\nand pray they dont work for Bill Gates\" (sic)\n\nMario, Link & other related characters (c) Nintendo\nFMOD (c) Firelight Technologies\n\nPowered by PN Engine\n\nThank you for playing Project Nightmare!\n-Team Nightmare");
	draw_set_alpha(1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}