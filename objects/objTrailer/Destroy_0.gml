/// @description Unload Video
buffer_delete(buff);
surface_free(surf);
video_stop(v);
video_delete(v);
draw_clear_alpha(c_black, 1);
game_set_speed(global.maxFPS, gamespeed_fps);