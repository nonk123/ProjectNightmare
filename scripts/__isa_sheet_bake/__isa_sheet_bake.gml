/// @description __isa_sheet_bake(load_data, clamp)
/// @param load_data
/// @param  clamp
function __isa_sheet_bake(argument0, argument1) {

	var _load_data = argument0;

	var _bck = _load_data[| __IS_STREAM_IMAGE.SPRITES ];


	var _subimg_ver = _load_data[| __IS_STREAM_IMAGE.SUBIMG_ROWS ];
	var _subimg_hor = _load_data[| __IS_STREAM_IMAGE.SUBIMG_COUNT ] / _subimg_ver;

	var _spr_w_raw = background_get_width( _bck ) / _subimg_hor;
	var _spr_h_raw = background_get_height( _bck ) / _subimg_ver;
	var _spr_w = floor( _spr_w_raw );
	var _spr_h = floor( _spr_h_raw );
	_load_data[| __IS_STREAM_IMAGE.XORIG ] *= _spr_w;
	_load_data[| __IS_STREAM_IMAGE.YORIG ] *= _spr_h;


	// Make sure that the user didn't enter the wrong subimage count
	if( _spr_w_raw != _spr_w ){
	    __is_log( "IMAGE STREAM WARNING: Image '" + string( _load_data[| __IS_STREAM_IMAGE.ID ] ) + 
	        "' may have wrong amount of subimages per row. Width " + string( background_get_width( _bck ) ) + " / " + string( _subimg_hor ) + " = " + string( _spr_w_raw ) );
	}
	if( _spr_h_raw != _spr_h ){
	    __is_log( "IMAGE STREAM WARNING: Image '" + string( _load_data[| __IS_STREAM_IMAGE.ID ] ) + 
	        "' may have wrong amount of subimages per column. Height " + string( background_get_height( _bck ) ) + " / " + string( _subimg_ver ) + " = " + string( _spr_h_raw ) );
	}
	// Bake into sprite

	var _surf = surface_create( background_get_width( _bck ), background_get_height( _bck ) );
	surface_set_target( _surf );
	draw_clear_alpha( c_black, 0 );
	draw_background( _bck, 0, 0 );
	var _spr = sprite_create_from_surface( _surf, 
	    0, 0, 
	    _spr_w, _spr_h, 
	    false, false, 
	    0, 0 );
	var i = 1; // i = x + width * y
	repeat( _subimg_hor * _subimg_ver - 1 ){
	    var _x = i mod _subimg_hor;
	    var _y = i div _subimg_hor;
    
	    sprite_add_from_surface( _spr, _surf, _x * _spr_w, _y * _spr_h, _spr_w, _spr_h, false, false );
	    i++;
	}
	surface_reset_target();
	surface_free( _surf);
	background_delete( _bck );

	if( argument1 == false ){
	    _load_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ] = 0;
	    _load_data[| __IS_STREAM_IMAGE.CLAMP_TOP ] = 0;
	    _load_data[| __IS_STREAM_IMAGE.WIDTH ] = _spr_w;
	    _load_data[| __IS_STREAM_IMAGE.HEIGHT ] = _spr_h;
	} else {
	    _load_data[| __IS_STREAM_IMAGE.CLAMP_LEFT ] = sprite_get_bbox_left( _spr );
	    _load_data[| __IS_STREAM_IMAGE.CLAMP_TOP ] = sprite_get_bbox_top( _spr );
	    _load_data[| __IS_STREAM_IMAGE.WIDTH ] = sprite_get_bbox_right( _spr ) - sprite_get_bbox_left( _spr ) + 1;
	    _load_data[| __IS_STREAM_IMAGE.HEIGHT ] = sprite_get_bbox_bottom( _spr ) - sprite_get_bbox_top( _spr ) + 1;
	}

	_load_data[| __IS_STREAM_IMAGE.SPRITES ] = _spr;




}
