/// @description Draw Video
// rembember to check if video exists when interacting with video.
// if you get a crash it is likely because you a trying to interact
// with memory that no longer exists or doesn't exist yet (video).
if (video_exists(v))
{
	if !(surface_exists(surf)) surf = surface_create(w, h); // create a squeaky clean totally empty surface for our needs.

	// then we just slap the video frame on that surf.
	buffer_set_surface(buff, surf, 0);
	draw_surface_stretched(surf, 0, 0, surface_get_width(application_surface), surface_get_height(application_surface));
}