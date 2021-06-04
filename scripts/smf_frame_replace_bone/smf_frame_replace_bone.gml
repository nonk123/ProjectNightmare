// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function smf_frame_replace_bone()
{
	var targetFrame, sourceFrame, bone, i, j;
	targetFrame = argument0;
	sourceFrame = argument1;
	bone = argument2;
	i = 8;
	j = bone * 8;
	while (i--) targetFrame[@ j + i] = sourceFrame[j + i];
}