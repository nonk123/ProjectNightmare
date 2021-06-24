/// @description Create Camera
event_inherited();
audio_emitter_free(emitter);

fCollision = false;
fGravity = false;
fVisible = false;

fov = 45;
renderPriority = ds_priority_create();

cam_3d_enable();
camera_destroy(view_camera[0]);
camera = cam_create(0, fov, 16/9, 0, 65536);
show_debug_message("Camera: " + string(camera_get_active()) + ", " + string(view_camera[0]));

tick = function ()
{
	x += (keyboard_check(vk_up) - keyboard_check(vk_down));
	baseTick();
}