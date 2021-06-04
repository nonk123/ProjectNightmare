/// @description __isf_subimg_to_area( session, sprite, subimg, area_id);
/// @param  session
/// @param  sprite
/// @param  subimg
/// @param  area_id
///__isf_subimg_to_area(l_texpage, l_img, subimage_count, spr, subimg, l_areas, area_id, g_image, pos_in_grid)
function __isf_subimg_to_area(argument0, argument1, argument2, argument3) {

	var _l_texpage = argument0[ __IS_FINISH.TEXPAGES ];
	var _l_data   = argument0[ __IS_FINISH.IMG_DATA ];
	var _spr_number = _l_data[| __IS_STREAM_IMAGE.SUBIMG_COUNT ];
	var _l_areas = argument0[ __IS_FINISH.AREAS ];
	var _g_image = argument0[ __IS_FINISH.IMG_GRID ];
	var _pos = argument0[ __IS_FINISH.IMG_GRID_POS ];
	var _m_stream = argument0[ __IS_FINISH.STREAM ];

	var _clamp = argument0[ __IS_FINISH.CLAMP ];

	var _spr     = argument1;
	var _subimg  = argument2;
	var _area_id = argument3;

	var _sep = _m_stream[? "sep" ];

	var _subimg_w = _l_data[| __IS_STREAM_IMAGE.WIDTH ];
	var _subimg_h = _l_data[| __IS_STREAM_IMAGE.HEIGHT ];



	draw_sprite_part( 
	    _spr, _subimg, 
	    _l_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ], _l_data[| __IS_STREAM_IMAGE.CLAMP_TOP ], 
	    _subimg_w, _subimg_h, 
	    _l_areas[| _area_id ], _l_areas[| _area_id + 1 ] 
	);
	_image_drawn = true;

	if( _pos == 0){
	    // ADD THE MAIN DATA OF THE SPRITE TO THE SPRITE DATA STRUCTURE
	    _g_image[# __ISG_IMG.ID, 0 ]          = _l_data[| __IS_STREAM_IMAGE.ID ];
	    _g_image[# __ISG_IMG.SUBIMAGES, 0 ]   = _spr_number;
	    _g_image[# __ISG_IMG.WIDTH, 0 ]       = _subimg_w;
	    _g_image[# __ISG_IMG.HEIGHT, 0 ]      = _subimg_h;
	    _g_image[# __ISG_IMG.XORIGIN, 0 ]     = _l_data[| __IS_STREAM_IMAGE.XORIG ] - _l_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ];
	    _g_image[# __ISG_IMG.YORIGIN, 0 ]     = _l_data[| __IS_STREAM_IMAGE.YORIG ] - _l_data[| __IS_STREAM_IMAGE.CLAMP_TOP ];
	    _g_image[# __ISG_IMG.BBOX_LEFT, 0 ]   = sprite_get_bbox_left( _spr ) - _l_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ];
	    _g_image[# __ISG_IMG.BBOX_TOP, 0 ]    = sprite_get_bbox_top( _spr ) - _l_data[| __IS_STREAM_IMAGE.CLAMP_TOP ];
	    _g_image[# __ISG_IMG.BBOX_RIGHT, 0 ]  = sprite_get_bbox_right( _spr ) - _l_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ];
	    _g_image[# __ISG_IMG.BBOX_BOTTOM, 0 ] = sprite_get_bbox_bottom( _spr ) - _l_data[| __IS_STREAM_IMAGE.CLAMP_TOP ];
	    _pos += __ISG_IMG.COUNT;
	}

	// ADD THE SUBIMAGE OF THE SPRITE TO THE SPRITE DATA STRUCTURE
	_g_image[# _pos + __ISG_SUBIMG.BACK, 0 ] = _l_texpage[| ds_list_size( _l_texpage ) - 1 ];
	_g_image[# _pos + __ISG_SUBIMG.X, 0 ]    = _l_areas[| _area_id ];
	_g_image[# _pos + __ISG_SUBIMG.Y, 0 ]    = _l_areas[| _area_id + 1 ];

	_pos += __ISG_SUBIMG.COUNT;

	if( argument0[@ __IS_FINISH.IMG_SUBIMG ] == _spr_number - 1 ){
	    _g_image[# _pos, 0 ] = _l_data[| __IS_STREAM_IMAGE.FPATH ]; // FNAME
	    _pos += 1;
	}

	// ADD THE NEW EMPTY AREAS TO THE AREA LIST


	if( _subimg_h < _l_areas[| _area_id + 3 ] ){
	    ds_list_add( _l_areas, 
	        _l_areas[| _area_id ],                        // X
	        _l_areas[| _area_id + 1 ] + _subimg_h + _sep, // Y
	        _l_areas[| _area_id + 2 ],                    // W
	        _l_areas[| _area_id + 3 ] - _subimg_h - _sep  // H
	    );
	    /*var p = ds_list_size( _l_areas ) - 4; // Area debugging for texpages
	    draw_set_colour( irandom( c_white ) );
	    draw_rectangle(
	        _l_areas[| p ], _l_areas[| p + 1 ],
	        _l_areas[| p ] + _l_areas[| p + 2 ] - 1, 
	        _l_areas[| p + 1 ] + _l_areas[| p + 3 ] - 1,
	        false
	    );*/
	}
	if( _subimg_w < _l_areas[| _area_id + 2 ] ){
	    ds_list_add( _l_areas, 
	        _l_areas[| _area_id ] + _subimg_w + _sep,     // X
	        _l_areas[| _area_id + 1 ],                    // Y
	        _l_areas[| _area_id + 2 ] - _subimg_w - _sep, // W
	        _subimg_h                                     // H
	    );
	    /*var p = ds_list_size( _l_areas ) - 4; // Area debugging for texpages
	    draw_set_colour( irandom( c_white ) );
	    draw_rectangle(
	        _l_areas[| p ], _l_areas[| p + 1 ],
	        _l_areas[| p ] + _l_areas[| p + 2 ] - 1, 
	        _l_areas[| p + 1 ] + _l_areas[| p + 3 ] - 1,
	        false
	    );*/
	}


	/*Don't uncomment. This is just the vertical version of the above

	if( _subimg_w < _l_areas[| _area_id + 2 ] ){
	    ds_list_add( _l_areas, 
	        _l_areas[| _area_id ] + _subimg_w + _sep,     // X
	        _l_areas[| _area_id + 1 ],                    // Y
	        _l_areas[| _area_id + 2 ] - _subimg_w - _sep, // W
	        _l_areas[| _area_id + 3 ]
	    );
	    var p = ds_list_size( _l_areas ) - 4;
	    draw_set_colour( irandom( c_white ) );
	    draw_rectangle(
	        _l_areas[| p ], _l_areas[| p + 1 ],
	        _l_areas[| p ] + _l_areas[| p + 2 ] - 1, 
	        _l_areas[| p + 1 ] + _l_areas[| p + 3 ] - 1,
	        false
	    );
	}

	if( _subimg_h < _l_areas[| _area_id + 3 ] ){
	    ds_list_add( _l_areas, 
	        _l_areas[| _area_id ],     // X
	        _l_areas[| _area_id + 1 ] + _subimg_h + _sep, // Y
	        _subimg_w + _sep, // W
	        _l_areas[| _area_id + 3 ] - _subimg_h - _sep  // H
	    );
	    var p = ds_list_size( _l_areas ) - 4;
	    draw_set_colour( irandom( c_white ) );
	    draw_rectangle(
	        _l_areas[| p ], _l_areas[| p + 1 ],
	        _l_areas[| p ] + _l_areas[| p + 2 ] - 1, 
	        _l_areas[| p + 1 ] + _l_areas[| p + 3 ] - 1,
	        false
	    );
	}*/


	// REMOVE THE CURRENT AREA FROM THE AREA LIST
	repeat( 4 )
	    ds_list_delete( _l_areas, _area_id );

	argument0[@ __IS_FINISH.IMG_GRID_POS ] = _pos;
	argument0[@ __IS_FINISH.IMG_SUBIMG ] += 1;




}
