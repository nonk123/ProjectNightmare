/// @description  @description smf_init()
function smf_init()
{
	/*Initializes Snidrs Model Format.
	THIS SCRIPT NEEDS TO BE RUN ONCE AT THE START OF THE GAME

	Script made by TheSnidr
	www.TheSnidr.com*/

	//---------------Random macros-------------------\\
	globalvar SMF_MATIDENTITY;
	SMF_MATIDENTITY = matrix_build_identity();

	//---------------SMF settings------------------\\
	globalvar SMF_format, SMF_format_bytes;
	SMF_format_bytes = 0;
	vertex_format_begin();
	vertex_format_add_position_3d();    SMF_format_bytes += 3 * 4; //Adds three f32
	vertex_format_add_normal();         SMF_format_bytes += 3 * 4; //Adds three f32
	vertex_format_add_texcoord();       SMF_format_bytes += 2 * 4; //Adds two f32
	vertex_format_add_colour();          SMF_format_bytes += 1 * 4; //Adds four u8
	vertex_format_add_colour();          SMF_format_bytes += 1 * 4; //Adds four u8
	vertex_format_add_colour(); //World model vertex color (not in vanilla SMF)
	SMF_format = vertex_format_end();

	//---------------Animation module------------------\\
	globalvar SMF_play_linear;      SMF_play_linear = 0
	globalvar SMF_loop_linear;      SMF_loop_linear = 1
	globalvar SMF_play_quadratic;   SMF_play_quadratic = 2
	globalvar SMF_loop_quadratic;   SMF_loop_quadratic = 3
	globalvar SMF_bindList, SMF_bindLocalList, SMF_frameList;
	SMF_bindList = ds_list_create();
	SMF_frameList = ds_list_create();
	SMF_bindLocalList = ds_list_create();
}
