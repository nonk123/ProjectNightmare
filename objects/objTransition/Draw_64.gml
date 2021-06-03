/// @description Draw Transition

draw_set_font(fntInternal);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_center);
draw_text(480, 270, transition == eTransition.loading ? "Loading" : "Transition");
draw_set_halign(fa_left);
draw_set_valign(fa_top);