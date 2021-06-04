/// @description  @description smf_create_vertex_buffer()
function smf_create_vertex_buffer() {
	/*
	Creates a vertex buffer with Snidrs Model Format

	Script made by TheSnidr
	www.TheSnidr.com
	*/
	var modelBuffer = vertex_create_buffer();

	//Create a model with one vertex so that it doesn't return an error if you try to draw it
	//(PFFFF.... that's for WUSSIES! Learn to fix this yourself! Learn to NOT create empty vertex buffers!)
	vertex_begin(modelBuffer, SMF_format)
	/*smf_add_vertex(modelBuffer, 0, 0, 0, 0, 0, 0, 0, 0, c_white, 1, c_white, 1)
	smf_add_vertex(modelBuffer, 0, 0, 0, 0, 0, 0, 0, 0, c_white, 1, c_white, 1)
	smf_add_vertex(modelBuffer, 0, 0, 0, 0, 0, 0, 0, 0, c_white, 1, c_white, 1)*/
	vertex_end(modelBuffer)

	return modelBuffer;






}
