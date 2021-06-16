/// @description Load Video
game_set_speed(30, gamespeed_fps);
isPlaying = false;
v = video_add("data/trailer.webm");
video_play(v);
w = video_get_width(v);
h = video_get_height(v);
chan = buffer_sizeof(buffer_u64); // size of one pixel
buff = buffer_create(chan * w * h, buffer_fixed, chan);
surf = -1; // surfaces should be created in Draw events only!
// a hackfix for GM's internal 'used bytes' counter:
buffer_poke(buff, buffer_get_size(buff) - 1, buffer_u8, 0);
// just poke 0 at the very end, so we ensure everything is allocated properly.
// probably not needed since GMS2.3+?

// fixes window close button on unix-likes with kwin/kde.
window_set_size(window_get_width(), window_get_height());