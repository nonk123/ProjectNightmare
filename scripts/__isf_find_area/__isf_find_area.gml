/// @description __isf_find_area(session,image_data)
/// @param session
/// @param image_data
function __isf_find_area(argument0, argument1) {
	var _l_areas = argument0[ __IS_FINISH.AREAS ];
	var _min_area_size = $10000000000000;
	var _min_area_id   = -1;
	var _w = argument1[| __IS_STREAM_IMAGE.WIDTH ];
	var _h = argument1[| __IS_STREAM_IMAGE.HEIGHT ];


	for( var n = 0; n < ds_list_size( _l_areas ); n += 4 ){
	    if( _w <= _l_areas[| n + 2 ] and _h <= _l_areas[| n + 3 ] ){
	        if( ( ( _l_areas[| n + 2 ] + _l_areas[| n + 3 ] ) / 2 ) < _min_area_size ){
	            _min_area_size = ( _l_areas[| n + 2 ] + _l_areas[| n + 3 ] ) / 2;
	            _min_area_id = n;
	        }
	    }
	}

	return _min_area_id;




}
