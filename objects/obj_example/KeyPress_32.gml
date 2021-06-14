/// @description Pause toggle

if (video_exists(v)) {
  if (video_is_paused(v)) {
    video_play(v);
  } else {
    video_pause(v);	
  }
}