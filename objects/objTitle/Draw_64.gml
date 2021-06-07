/// @description Draw Menu

var mtlVoid = global.materials[? "mtlVoid"][0];
for (var i = 0; i < camera_get_view_width(view_camera[0]) / 128; i++) for (var j = 0; j < camera_get_view_height(view_camera[0]) / 128; j++) draw_sprite_stretched(mtlVoid, (current_time * 0.001 + power(i, j) + i + j) mod (global.materials[? "mtlVoid"][1]), i * 128, j * 128, 128, 128);