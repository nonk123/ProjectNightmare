/// @description  @description smf_model_load(fname)
/// @param fname
function smf_model_load(argument0)
{
	/*Load an SMF model

	Script made by TheSnidr
	www.TheSnidr.com*/
	
	var path, loadBuff, header, version, size, vertBuff, vBuff;
	
	path = argument0;
	if !(file_exists(path)) return (-1)
	
	loadBuff = buffer_load(path);
	header = buffer_read(loadBuff, buffer_u16);
	version = buffer_read(loadBuff, buffer_string);

	if !(string_count("SnidrsModelFormat", version)) vBuff = vertex_create_buffer_from_buffer(loadBuff, SMF_format); //This is an old version of the format
	else if (string_count("1.0", version))
	{
	    //This is the most recent version of the format this importer can read
	    size = buffer_read(loadBuff, buffer_u32);
	    vertBuff = buffer_create(10, buffer_grow, 1);
	    buffer_copy(loadBuff, buffer_tell(loadBuff), size, vertBuff, 0);
	    repeat (size / SMF_format_bytes)
	    {
	        buffer_seek(vertBuff, buffer_seek_relative, SMF_format_bytes);
	        var pos = buffer_tell(vertBuff), tempBuff = buffer_create(10, buffer_grow, 1);
	        buffer_copy(vertBuff, pos, size, tempBuff, 0);
	        buffer_copy(tempBuff, 0, size, vertBuff, pos + 4);
	        buffer_delete(tempBuff);
	        repeat (4) buffer_write(vertBuff, buffer_u8, 255);
	    }
	    vBuff = vertex_create_buffer_from_buffer(vertBuff, SMF_format);
	    buffer_delete(vertBuff);
	}
	else show_message(path + " was made with a newer version of the SMF format and is not supported");
	buffer_delete(loadBuff);
	vertex_freeze(vBuff);
	
	return (vBuff)
}
