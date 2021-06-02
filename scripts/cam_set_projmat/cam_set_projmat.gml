/// @description cam_set_projmat(camera, FOV, aspect, near, far)
/// @param camera
/// @param FOV
/// @param aspect
/// @param near
/// @param far
function cam_set_projmat(argument0, argument1, argument2, argument3, argument4) {
	/*
	Creates a camera for the given view

	Script created by TheSnidr
	www.thesnidr.com
	*/
	var camera = argument0;

	var FOV = argument1;
	var aspect = argument2;
	var near = argument3;
	var far = argument4;
	camera_set_proj_mat(camera, matrix_build_projection_perspective_fov(-FOV, -aspect, near, far));


}
