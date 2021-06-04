/// @description __isf_texpage_create(session)
/// @param session
function __isf_texpage_create(argument0) {

	var _l_areas = argument0[ __IS_FINISH.AREAS ];
	var _l_texpage = argument0[ __IS_FINISH.TEXPAGES ];
	var _m_stream = argument0[ __IS_FINISH.STREAM ];

	var _w = _m_stream[? "w" ];
	var _h = _m_stream[? "h" ];
	var _sep = _m_stream[? "sep" ];

	ds_list_clear( _l_areas );
	ds_list_add( _l_areas, _sep, _sep, _w - _sep, _h - _sep );

	var _back = background_create_colour( _w, _h, c_black );
	ds_list_add( _l_texpage, surface_create( _w, _h ), _back);
	surface_reset_target();
	surface_set_target( _l_texpage[| ds_list_size( _l_texpage ) - 2 ] );
	draw_clear_alpha( 0,0 );






}
