/// @description image_stream_add_sheet(group,identifier,fname,hor_count,ver_count,xorig,yorig)
/// @param group
/// @param identifier
/// @param fname
/// @param hor_count
/// @param ver_count
/// @param xorig
/// @param yorig
function image_stream_add_sheet(argument0, argument1, argument2, argument3, argument4, argument5, argument6) {
	var _l = global.m_ex_image[? argument0 ];

	// Error checking
	if( ds_list_size( _l ) != 3 ){
	    show_error( "Image stream not started " + chr(13) + "Group: " + string( argument0 ) + chr(13) + "Identifier " + string( argument1 ), true );
	    return false; 
	}

	var _m = _l[| 2 ];
	var _p_sprite = _m[? "sprite" ];

	var _bck = background_add( argument2, _m[? "removeback" ], false );
	var _spr_w = background_get_width( _bck ) / argument3;
	var _spr_h = background_get_height( _bck ) / argument4;
	var _priority = floor( ( _spr_w + _spr_h ) * 0.5 );

	var _load_data = ds_list_create();
	_load_data[| __IS_STREAM_IMAGE.ID ] = string( argument1 );
	_load_data[| __IS_STREAM_IMAGE.TYPE ] = __IS.TYPE_SHEET;
	_load_data[| __IS_STREAM_IMAGE.FPATH ] = argument2;
	_load_data[| __IS_STREAM_IMAGE.SUBIMG_COUNT ] = argument3 * argument4;
	_load_data[| __IS_STREAM_IMAGE.SUBIMG_ROWS ] = argument4;
	_load_data[| __IS_STREAM_IMAGE.XORIG ] = argument5;
	_load_data[| __IS_STREAM_IMAGE.YORIG ] = argument6;

	if( _priority <= 1 and !file_exists( argument2 ) ){
	    _load_data[| __IS_STREAM_IMAGE.SPRITES ] = _bck;
    
	    var _l_loading = _m[? "loading" ];
	    ds_list_add( _l_loading, _load_data );
	    _m[? "finished" ] = false;
	} else {
	    if( _spr_w <= _m[? "w" ] + _m[? "sep" ] && _spr_h <= _m[? "h" ] + _m[? "sep" ] ){
	        // The image came from a file, finish everything
	        _load_data[| __IS_STREAM_IMAGE.SPRITES ] = _bck;
	        __isa_sheet_bake( _load_data, _m[? "clamp" ] );
	        _priority = floor( ( _load_data[| __IS_STREAM_IMAGE.WIDTH ] + _load_data[| __IS_STREAM_IMAGE.HEIGHT ] ) * 0.5 );
	    } else {
	        background_delete( _bck );
	        ds_list_destroy( _load_data );
	        show_error( "Image is larger than texturepage! " + chr(13) + "Group: " + string( argument0 ) + chr(13) + "Identifier " + string( argument1 ), false );
	        return false;
	    }

	}

	ds_priority_add( _p_sprite, _load_data, _priority );
	return true;




}
