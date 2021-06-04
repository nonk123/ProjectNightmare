/// @description draw_image_tiled(image,subimg,x,y)
/// @param image
/// @param subimg
/// @param x
/// @param y
function draw_image_tiled(argument0, argument1, argument2, argument3) {
	gml_pragma("forceinline"); // YYC performance boost

	var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;

	var _w = argument0[# __ISG_IMG.WIDTH, 0 ];
	var _h = argument0[# __ISG_IMG.HEIGHT, 0 ];
	var _bck  = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ];
	var _left = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.X, 0 ];
	var _top  = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.Y, 0 ];
	var _xo = ( argument2 mod _w );
	var _yo = ( argument3 mod _h );

	for( var _x = -_w; _x <= __view_get( e__VW.WView, view_current ); _x += _w ){
	    for( var _y = -_h; _y <= __view_get( e__VW.HView, view_current ); _y += _h ){
	        draw_background_part(
	            _bck, 
	            _left,
	            _top,
	            _w,
	            _h,
	            _xo + _x,
	            _yo + _y
	        );
	    }
	}



}
