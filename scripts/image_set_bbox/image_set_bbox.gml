/// @description image_set_bbox(image,left,top,right,bottom)
/// @param image
/// @param left
/// @param top
/// @param right
/// @param bottom
function image_set_bbox(argument0, argument1, argument2, argument3, argument4) {
	gml_pragma("forceinline"); 
	argument0[# __ISG_IMG.BBOX_LEFT, 0 ] = argument1;
	argument0[# __ISG_IMG.BBOX_TOP, 0 ] = argument2;
	argument0[# __ISG_IMG.BBOX_RIGHT, 0 ] = argument3;
	argument0[# __ISG_IMG.BBOX_BOTTOM, 0 ] = argument4;




}
