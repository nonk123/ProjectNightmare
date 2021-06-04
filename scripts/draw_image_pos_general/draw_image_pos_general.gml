/// @description draw_image_pos_general(sprite,subimg,x1,y1,x2,y2,x3,y3,x4,y4,rot,c1,c2,c3,c4,alpha)
/// @param sprite
/// @param subimg
/// @param x1
/// @param y1
/// @param x2
/// @param y2
/// @param x3
/// @param y3
/// @param x4
/// @param y4
/// @param rot
/// @param c1
/// @param c2
/// @param c3
/// @param c4
/// @param alpha
function draw_image_pos_general(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8, argument9, argument10, argument11, argument12, argument13, argument14, argument15) {
	gml_pragma("forceinline"); // YYC performance boost


	var _c_subimg = ( floor(argument1) mod argument0[# __ISG_IMG.SUBIMAGES, 0 ] ) * __ISG_SUBIMG.COUNT;
	var _bck = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.BACK, 0 ];

	var _u_x = argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.X, 0 ] / background_get_width( _bck );
	var _u_y =  argument0[# __ISG_IMG.COUNT + _c_subimg + __ISG_SUBIMG.Y, 0 ] / background_get_height( _bck );
	var _u_w = argument0[# __ISG_IMG.WIDTH, 0 ] / background_get_width( _bck );
	var _u_h = argument0[# __ISG_IMG.HEIGHT, 0 ] / background_get_height( _bck );

	var _x1 = argument2;
	var _y1 = argument3;
	var _dis1 = point_distance(  _x1, _y1, argument4, argument5 );
	var _dir1 = point_direction( _x1, _y1, argument4, argument5 ) + argument10;
	var _dis2 = point_distance(  _x1, _y1, argument6, argument7 );
	var _dir2 = point_direction( _x1, _y1, argument6, argument7 ) + argument10;
	var _dis3 = point_distance(  _x1, _y1, argument8, argument9 );
	var _dir3 = point_direction( _x1, _y1, argument8, argument9 ) + argument10;

	draw_primitive_begin_texture( pr_trianglelist, background_get_texture( _bck ) );
	    draw_vertex_texture_colour( _x1, _y1, _u_x, _u_y, argument11, argument15 );
	    draw_vertex_texture_colour( _x1 + lengthdir_x( _dis1, _dir1 ), _y1 + lengthdir_y( _dis1, _dir1 ), _u_x+_u_w, _u_y, argument12, argument15 );
	    draw_vertex_texture_colour( _x1 + lengthdir_x( _dis2, _dir2 ), _y1 + lengthdir_y( _dis2, _dir2 ), _u_x+_u_w, _u_y+_u_h, argument13, argument15 );
    
	    draw_vertex_texture_colour( _x1 + lengthdir_x( _dis3, _dir3 ), _y1 + lengthdir_y( _dis3, _dir3 ), _u_x, _u_y+_u_h, argument14, argument15 );
	    draw_vertex_texture_colour( _x1, _y1, _u_x, _u_y, argument11, argument15 );
	    draw_vertex_texture_colour( _x1 + lengthdir_x( _dis2, _dir2 ), _y1 + lengthdir_y( _dis2, _dir2 ), _u_x+_u_w, _u_y+_u_h, argument13, argument15 );
	draw_primitive_end();




}
