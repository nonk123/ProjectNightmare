/// @description image_get_number(ind)
/// @param ind
function image_get_number(argument0) {
	gml_pragma("forceinline"); 
	return( argument0[# __ISG_IMG.SUBIMAGES, 0 ] );



}
