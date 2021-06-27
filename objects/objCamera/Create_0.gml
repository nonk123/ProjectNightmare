/// @description Create Camera
event_inherited();
audio_emitter_free(emitter);

fCollision = false;
fGravity = false;
fVisible = false;

fov = 45;
renderPriority = ds_priority_create();

cam_3d_enable();
cam_set_projmat(view_camera[0], fov, 16/9, 1, 65536);
camera_apply(view_camera[0]);

tick = function ()
{
	x += (keyboard_check(vk_up) - keyboard_check(vk_down));
	baseTick();
}