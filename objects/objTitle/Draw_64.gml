/// @description Draw Menu

var camSize = [camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0])], camCenter = [camSize[0] * 0.5, camSize[1] * 0.5];
draw_set_font(pn_font_get_font("fntMario"));

if (menu[0] == eMenu.intro)
{
	var mtlVoid = global.materials[? "mtlVoid"][0];
	for (var i = 0; i < (camSize[0] / 128) + 2; i++) for (var j = 0; j < camSize[1] / 128; j++) draw_sprite_stretched_ext(mtlVoid, (current_time * 0.001 + power(i, j) + i + j) mod (global.materials[? "mtlVoid"][1]), i * 128 - animation * 128 - (current_time * 0.008) mod (128), j * 128, 128, 128, c_white, timer[0] > 200 ? 1 : image_alpha_smooth);
	
	draw_set_alpha(timer[0] > 200 ? image_alpha_smooth : 1);
	draw_set_color(timer[0] > 200 ? c_black : merge_color(c_white, c_black, image_alpha_smooth));
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	
	var scroll = animation_smooth * camSize[0], text2X = camSize[0] * 1.5 - scroll;
	draw_text_transformed(camCenter[0] - scroll, camCenter[1], "Team Nightmare presents", 2, 2, 0);
	draw_text_transformed(text2X, camCenter[1] - 64, "A reimagining of Adrien Dittrick's", 2, 2, 0);
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_set_alpha(1);
	
	draw_sprite_ext(pn_sprite_get_sprite("sprNNLogo"), 0, text2X, camCenter[1] + 32, 1.5, 1.5, 0, c_white, 1);
}
else
{
	var sprSidebar = pn_sprite_get_sprite("sprSidebar"), sidebarScale = 1.25 * (camSize[1] / sprite_get_height(sprSidebar)), sidebarScroll = menuY_smooth * (sidebarScale * sprite_get_height(sprSidebar) - sprite_get_height(sprSidebar)), logoScale = lerp(1, 0.75, animation_smooth);
	draw_sprite_ext(sprSidebar, ((current_time * 0.01) + (sprite_get_number(sprSidebar) * dsin(current_time * 0.002))) mod (sprite_get_number(sprSidebar)), lerp(-999, (sidebarScale / 1.25) * -115.75, animation_smooth) + sidebarScroll * 0.4, sidebarScroll, sidebarScale, sidebarScale, 0, c_dkgray, 0.5);
	draw_sprite_ext(pn_sprite_get_sprite("sprLogo"), 0, lerp(camCenter[0], 196, animation_smooth), lerp(camCenter[1] - 96, 139, animation_smooth), logoScale, logoScale, 0, c_white, 1);
	
	switch (menu[0])
	{
		case (eMenu.start):
			if (timer[0] == -65536 || (current_time) mod (100) > 50)
			{
				draw_set_color(merge_color(c_white, c_pn_yellow, abs(dsin(current_time * 0.15))));
				draw_set_halign(fa_center);
				draw_set_valign(fa_center);
			
				draw_text_transformed(camCenter[0], camCenter[1] + 64, "Press any button to start", 2, 2, 0);
			
				draw_set_halign(fa_left);
				draw_set_valign(fa_top);
				draw_set_color(c_white);
			}
		break
		
		default:
			var getMenu = options[menu[0]], menuSize = array_length(getMenu), i = 0;
			repeat (menuSize)
			{
				if (option[0] == i && timer[1] >= 0 && (current_time) mod (100) < 50) continue
				var getOption = getMenu[i];
				draw_set_color((option[0] == i) ? merge_color(c_pn_red, c_white, abs(dsin(current_time * 0.2))) : (getOption.isDisabled ? c_gray : c_pn_red));
				draw_text_transformed(lerp(-499.5, 64, animation_smooth) + i * 10 + getOption.xOffset, 256 + i * 36, getOption.label, 2, 2, 0);
				i++;
			}
			draw_set_color(c_white);
	}
	
	draw_set_alpha(image_alpha_smooth);
	draw_rectangle(0, 0, camSize[0], camSize[1], false);
	draw_set_alpha(1);
}

draw_set_font(fntInternal);