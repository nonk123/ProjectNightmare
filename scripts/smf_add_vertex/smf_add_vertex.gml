/// @description smf_add_vertex(buffer, x, y, z, nx, ny, nz, u, v, color, alpha, vColor, vAlpha)
/// @param buffer
/// @param  x
/// @param  y
/// @param  z
/// @param  nx
/// @param  ny
/// @param  nz
/// @param  u
/// @param  v
/// @param  color
/// @param  alpha
/// @param  vColor
/// @param  vAlpha
function smf_add_vertex(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12) {
	/*
	Adds a vertex to a vertex buffer using Snidrs Model Format

	Script made by TheSnidr
	www.TheSnidr.com
	*/

	//vertex_position_3d
	vertex_position_3d(argument0, argument1, argument2, argument3);

	//vertex_normal_3d
	vertex_normal(argument0, argument4, argument5, argument6);

	//vertex_texcoord
	vertex_texcoord(argument0, argument7, argument8);

	//vertex_color (Colour, tangent or bone indices)
	vertex_colour(argument0, argument9, argument10);

	//vertex_color (Cotangent or bone weights)
	vertex_colour(argument0, argument9, argument10);

	//vertex_color
	vertex_colour(argument0, argument11, argument12);



}
