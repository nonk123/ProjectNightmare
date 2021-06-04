/// @description image_get_texturepage(sprite,subimg)
/// @param sprite
/// @param subimg
function image_get_texturepage(argument0, argument1) {
	gml_pragma("forceinline"); 

	var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;
	return( argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ] );



}
