/// @description  @description smf_frame_lerp_bone(targetFrame, sourceFrame, boneIndex, amount)
/// @param targetFrame
/// @param  sourceFrame
/// @param  boneIndex
/// @param  amount
/// @param targetFrame
/// @param sourceFrame
/// @param boneIndex
/// @param amount
function smf_frame_lerp_bone(argument0, argument1, argument2, argument3) {
	var targetFrame, sourceFrame, bone, amount, i, j;
	targetFrame = argument0;
	sourceFrame = argument1;
	bone = argument2;
	amount = argument3;
	i = 8;
	j = bone * 8;
	while i--{targetFrame[@ j + i] = lerp(targetFrame[j + i], sourceFrame[j + i], amount);}





}
