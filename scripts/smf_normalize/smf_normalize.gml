/// @description  @description smf_normalize(x, y, z)
/// @param x
/// @param  y
/// @param  z
/// @param x
/// @param y
/// @param z
function smf_normalize(argument0, argument1, argument2)
{
	//Returns the unit vector with the same direction
	var returnLength = point_distance_3d(0, 0, 0, argument0, argument1, argument2);
	if (returnLength != 0)
	{
	    returnX = argument0 / returnLength;
	    returnY = argument1 / returnLength;
	    returnZ = argument2 / returnLength;
	    return (returnLength)
	}
	returnX = 1;
	returnY = 0;
	returnZ = 0;
	return (0)
}
