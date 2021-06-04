/// @description  @description smf_frame_rotate_bone_global(frame, boneIndex, ax, ay, az, angle)
/// @param frame
/// @param  boneIndex
/// @param  ax
/// @param  ay
/// @param  az
/// @param  angle
/// @param frame
/// @param boneIndex
/// @param ax
/// @param ay
/// @param az
/// @param angle
function smf_frame_rotate_bone_global(argument0, argument1, argument2, argument3, argument4, argument5) {
	//This script can be optimized a lot
	var frame, bone, ax, ay, az, angle, i, R, bind, animationIndex;
	frame = argument0;
	bone = argument1;
	ax = argument2;
	ay = argument3;
	az = argument4;
	angle = argument5;
	animationIndex = SMF_bindList[| frame[array_length_1d(frame) - 1]];

	bind = animationIndex[| bone];
	pBind = animationIndex[| bind[8]];

	i = 8;
	while i--{R[i] = frame[bone * 8 + i];}

	rotationDQ = dq_create(angle, ax, ay, az, 0, 0, 0);

	worldDQ = dq_multiply(pBind, R);
	T = dq_get_translation(worldDQ);
	pT = dq_get_translation(pBind);
	worldDQ = dq_set_translation(worldDQ, T[0] - pT[0], T[1] - pT[1], T[2] - pT[2]);
	worldDQ = dq_multiply(rotationDQ, worldDQ);
	T = dq_get_translation(worldDQ);
	worldDQ = dq_set_translation(worldDQ, T[0] + pT[0], T[1] + pT[1], T[2] + pT[2]);
	worldDQ = dq_normalize(worldDQ);
	Q = dq_multiply(dq_get_conjugate(pBind), worldDQ);

	i = 8;
	while i--{frame[@ bone * 8 + i] = Q[i];}





}
