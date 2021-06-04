/// @description image_get_filename(ind)
/// @param ind
function image_get_filename(argument0) {
	gml_pragma("forceinline"); 
	return( argument0[# ds_grid_width( argument0 ) - 1, 0 ] );



}
