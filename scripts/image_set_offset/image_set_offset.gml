/// @description image_set_offset(ind,xoffset,yoffset)
/// @param ind
/// @param xoffset
/// @param yoffset
function image_set_offset(argument0, argument1, argument2) {
	gml_pragma("forceinline");
	argument0[# __ISG_IMG.XORIGIN, 0 ] = argument1;
	argument0[# __ISG_IMG.YORIGIN, 0 ] = argument2;



}
