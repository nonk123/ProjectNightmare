/// @description Draw Message Box
draw_set_color(c_black);
draw_set_alpha(0.51);
draw_rectangle(16, 540 - (144 * scale_smooth), 944, 540 - (16 * scale_smooth), false);
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(pn_font_get_font("fntMessage"));
draw_text_ext_transformed(20, 540 - (140 * scale_smooth), _message, -1, 460, 2, 2 * scale_smooth, 0);
draw_set_font(fntInternal);