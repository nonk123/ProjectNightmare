/// @description  @description smf_cross_product(x1, y1, z1, x2, y2, z2)
/// @param x1
/// @param  y1
/// @param  z1
/// @param  x2
/// @param  y2
/// @param  z2
/// @param x
/// @param y
/// @param z
/// @param u
/// @param v
/// @param w
function smf_cross_product(argument0, argument1, argument2, argument3, argument4, argument5)
{
	returnX = argument1 * argument5 - argument2 * argument4;
	returnY = argument2 * argument3 - argument0 * argument5;
	returnZ = argument0 * argument4 - argument1 * argument3;
}