/// @description draw_image_part(sprite,subimg,left,top,width,height,x,y)
/// @param sprite
/// @param subimg
/// @param left
/// @param top
/// @param width
/// @param height
/// @param x
/// @param y
function draw_image_part(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {
	gml_pragma("forceinline"); // YYC performance boost but it inflates the final exe size

	var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;
	draw_background_part(
	    argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ],  
	    argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.X, 0 ] + argument2,
	    argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.Y, 0 ] + argument3,
	    argument4,
	    argument5,
	    argument6,
	    argument7
	);



}
