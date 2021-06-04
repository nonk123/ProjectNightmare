/// @description  @description smf_animation_load(filename)
/// @param filename
/// @param filename
function smf_animation_load(argument0)
{
	/*Script made by TheSnidr
	www.TheSnidr.com*/
	
	var i, f, k, file, boneNum, frameNum, animationBuffer, animationIndex, frameGrid, Q;
	
	file = argument0;
	animationBuffer = buffer_load(file);
	boneNum = buffer_read(animationBuffer, buffer_u8);
	frameNum = buffer_read(animationBuffer, buffer_u8);
	animationIndex = ds_list_size(SMF_bindList);

	bindPose = ds_list_create();
	bindPoseLocal = ds_list_create();
	SMF_bindList[| animationIndex] = bindPose;
	ds_list_mark_as_list(SMF_bindList, animationIndex);
	SMF_bindLocalList[| animationIndex] = bindPoseLocal;
	ds_list_mark_as_list(SMF_bindLocalList, animationIndex);
	for (i = 0; i < boneNum; i ++)
	{
		Q = -1;
		//The first 8 indices store the dual quaternion
		for (var k = 0; k < 8; k ++){Q[k] = buffer_read(animationBuffer, buffer_f32);}
		//The 8th index stores the bone's parent
		Q[8] = buffer_read(animationBuffer, buffer_u8);
		//The 9th index stores whether or not the bone is attached to its parent
		Q[9] = buffer_read(animationBuffer, buffer_u8);
		bindPose[| i] = Q;
	}

	frameGrid = ds_grid_create(frameNum, boneNum + 1);
	SMF_frameList[| animationIndex] = frameGrid;
	for (var f = 0; f < frameNum; f ++)
	{
		//Load the time of the frame
		frameGrid[# f, 0] = buffer_read(animationBuffer, buffer_f32);
		for (var i = 0; i < boneNum; i ++)
		{
			Q = -1;
			//Load the local delta dual quaternion of the frame
			for (var k = 0; k < 8; k ++) Q[k] = buffer_read(animationBuffer, buffer_f32);
			frameGrid[# f, i + 1] = Q;
		}
	}
	buffer_delete(animationBuffer);

	return (animationIndex)
}
