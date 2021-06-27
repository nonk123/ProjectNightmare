/// @description Draw Pause
draw_sprite(background, 0, 0, 0);

var character = "sprPauseMario", font = "fntMario", color = c_pn_red;
if (global.PAUSEDEBUG)
{
	character = "sprPauseLink";
	font = "fntZelda";
	color = c_pn_green;
}

var animationFactor = (463 + animation_smooth) / 926;

draw_set_color(c_black);
draw_set_alpha(animationFactor);
draw_rectangle(0, 0, sprite_get_width(background), sprite_get_height(background), false);
draw_set_alpha(1);
draw_set_color(c_white);

var sprSidebar = pn_sprite_get_sprite("sprSidebar");
draw_sprite_ext(sprSidebar, ((current_time * 0.01) + (sprite_get_number(sprSidebar) * dsin(current_time * 0.002))) mod (sprite_get_number(sprSidebar)), animation_smooth, 0, 1, 1, 0, color, 1);
var characterSprite = pn_sprite_get_sprite(character);
draw_sprite_ext(characterSprite, 0, animation_smooth + 96, 64, 0.9, 0.9, 0, c_black, 0.5);
draw_sprite(characterSprite, 0, animation_smooth + 64, 32);

var animationRight = lerp(camera_get_view_width(view_camera[0]) + 240, camera_get_view_width(view_camera[0]) - 580, animationFactor);
draw_sprite_ext(pn_sprite_get_sprite("sprLogo"), global.PAUSEDEBUG, animationRight, 80, 0.5, 0.5, 0, c_white, 1);
draw_set_font(pn_font_get_font(font));
draw_set_halign(fa_center);
draw_set_valign(fa_center);
draw_text_transformed(animationRight + 36, 170.5 - dsin(current_time * 0.09) * 12, "Paused", 2, 2, dsin(current_time * 0.18) * 6);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
for (var i = 0; i < 3; i++)
{
	draw_set_color(option == i ? merge_color(c_pn_red, c_white, abs(dsin(current_time * 0.2))) : c_pn_red);
	var label = i == 2 ? "Quit" : (i ? "Options" : "Inventory");
	draw_text_transformed(animationRight + 96 + optionX[i], 384 + i * 36, label, 2, 2, 0);
}
draw_set_color(c_white);
if (confirmAnimation > 0)
{
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	draw_set_color(c_black);
	draw_set_alpha(0.8);
	var centerX = camera_get_view_width(view_camera[0]) * 0.5, centerY = camera_get_view_height(view_camera[0]) * 0.5;
	var boxScaleX = 336 * confirmAnimation, boxScaleY = 144 * confirmAnimation;
	draw_rectangle(centerX - boxScaleX, centerY - boxScaleY, centerX + boxScaleX, centerY + boxScaleY, false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	var textScale = 2 * confirmAnimation;
	draw_text_transformed(centerX, centerY - 32, "Are you sure you want to quit?\n\nAll unsaved progress up to\nthis point will be lost.", textScale, textScale, 0);
	if (confirmAnimation == 1) for (i = 0; i < 2; i++)
	{
		if (i && timer[0] != -65536 && (current_time) mod (100) < 50) break
		draw_set_color(confirmOption == i ? merge_color(c_pn_red, c_white, abs(dsin(current_time * 0.2))) : c_pn_red);
		draw_text_transformed(centerX + (i ? -128 : 128), centerY + 96 - (confirmOption == i) * 8, i ? "Yes" : "No", 3, 3, 0);
	}
	draw_set_color(c_white);
	draw_set_valign(fa_top);
}
draw_set_halign(fa_left);
draw_set_font(fntInternal);