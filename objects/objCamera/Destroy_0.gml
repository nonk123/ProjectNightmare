/// @description Destroy Camera
event_inherited();
ds_priority_destroy(renderPriority);

cam_3d_disable();
camera_set_view_mat(view_camera[0], global.cameraDefaultView);
camera_set_proj_mat(view_camera[0], global.cameraDefaultProjection);
camera_apply(view_camera[0]);