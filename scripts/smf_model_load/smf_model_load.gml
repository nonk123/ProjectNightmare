/// @description  @description smf_model_load(fname)
/// @param fname
function smf_model_load(argument0)
{
	/*Load an SMF model

	Script made by TheSnidr
	www.TheSnidr.com*/
	
	var path, loadBuff, header, version, size, vBuff;
	
	path = argument0;
	if !(file_exists(path)) return (-1)
	
	loadBuff = buffer_load(path);
	header = buffer_read(loadBuff, buffer_u16);
	version = buffer_read(loadBuff, buffer_string);

	if (version == "SnidrsModelFormat 1.0")
	{
	    //This is the most recent version of the format this importer can read
	    size = buffer_read(loadBuff, buffer_u32);
		show_debug_message(string(size));
	    vBuff = vertex_create_buffer();
		vertex_begin(vBuff, SMF_format);
	    repeat (size / 40)
	    {
			var xx = buffer_read(loadBuff, buffer_f32);
			var yy = buffer_read(loadBuff, buffer_f32);
			var zz = buffer_read(loadBuff, buffer_f32);
			var nx = buffer_read(loadBuff, buffer_f32);
			var ny = buffer_read(loadBuff, buffer_f32);
			var nz = buffer_read(loadBuff, buffer_f32);
			var u = buffer_read(loadBuff, buffer_f32);
			var v = buffer_read(loadBuff, buffer_f32);
			var r1 = buffer_read(loadBuff, buffer_u8);
			var g1 = buffer_read(loadBuff, buffer_u8);
			var b1 = buffer_read(loadBuff, buffer_u8);
			var a1 = buffer_read(loadBuff, buffer_u8);
			var r2 = buffer_read(loadBuff, buffer_u8);
			var g2 = buffer_read(loadBuff, buffer_u8);
			var b2 = buffer_read(loadBuff, buffer_u8);
			var a2 = buffer_read(loadBuff, buffer_u8);
	        vertex_position_3d(vBuff, xx, yy, zz);
			vertex_normal(vBuff, nx, ny, nz);
			vertex_texcoord(vBuff, u, v);
			vertex_color(vBuff, c_white, 1);
			vertex_color(vBuff, make_color_rgb(r1, g1, b1), a1 / 255);
			vertex_color(vBuff, make_color_rgb(r2, g2, b2), a2 / 255);
	    }
		vertex_end(vBuff);
	}
	buffer_delete(loadBuff);
	vertex_freeze(vBuff);
	
	return (vBuff)
}