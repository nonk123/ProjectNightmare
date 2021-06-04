/// @description  @description smf_model_save(index, fname)
/// @param index
/// @param  fname
/// @param index
/// @param fname
function smf_model_save(argument0, argument1) {
	/*
	Save an SMF model

	Script made by TheSnidr
	www.TheSnidr.com
	*/
	var vertBuffer = buffer_create_from_vertex_buffer(argument0, buffer_fixed, 1);
	buffer_save(vertBuffer, argument1);
	buffer_delete(vertBuffer);





}
