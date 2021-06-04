/// @description  @description smf_rotate_vector(x, y, z, angle, axisX, axisY, axisZ)
/// @param x
/// @param  y
/// @param  z
/// @param  angle
/// @param  axisX
/// @param  axisY
/// @param  axisZ
/// @param x
/// @param y
/// @param z
/// @param angle
/// @param axisX
/// @param axisY
/// @param axisZ
function smf_rotate_vector(argument0, argument1, argument2, argument3, argument4, argument5, argument6)
{
	//Rotates the point (x,y,z) around the vector [a,b,c]
	var c, s, d;
	c = cos(argument3);
	s = sin(argument3);
	d = (1 - c) * (argument4 * argument0 + argument5 * argument1 + argument6 * argument2);
	returnX = argument0 * c + argument4 * d + (argument5 * argument2 - argument6 * argument1) * s;
	returnY = argument1 * c + argument5 * d + (argument6 * argument0 - argument4 * argument2) * s;
	returnZ = argument2 * c + argument6 * d + (argument4 * argument1 - argument5 * argument0) * s;
}