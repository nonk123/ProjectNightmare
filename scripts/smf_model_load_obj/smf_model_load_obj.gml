/// @description  @description smf_model_load_obj(fname)
/// @param fname
/// @param fname
function smf_model_load_obj(argument0)
{
	/*Loads a .obj model into SMF

	No guarantees it works with all .obj models! I've only tested it with Lightwave 3D*/
	
	var modelBuffer, filename, n_index, t_index, v_index, file, i, j, str, type, vertString, triNum;
	filename = argument0;
	if !file_exists(argument0){show_debug_message("Failed to load model " + string(filename)); exit;}
	show_debug_message("Loading obj file " + string(filename) + " into SMF");

	modelBuffer = smf_create_vertex_buffer();
	vertex_begin(modelBuffer, SMF_format);

	var vx, vy, vz, nx, ny, nz, tx, ty, fl, v, n, t, f;
	vx = ds_list_create(); vx[| 0] = 0;
	vy = ds_list_create(); vy[| 0] = 0;
	vz = ds_list_create(); vz[| 0] = 0;
	nx = ds_list_create(); nx[| 0] = 0;
	ny = ds_list_create(); ny[| 0] = 0;
	nz = ds_list_create(); nz[| 0] = 0;
	tx = ds_list_create(); tx[| 0] = 0;
	ty = ds_list_create(); ty[| 0] = 0;
	fl = ds_list_create();

	file = file_text_open_read(filename);
	while !file_text_eof(file)
	{
	str = string_replace_all(file_text_read_string(file),"  "," ");
	type = string_copy(str, 1, 2);
	str = string_delete(str, 1, string_pos(" ", str));
	switch type
	{
	case "v ":
	ds_list_add(vx, real(string_copy(str, 1, string_pos(" ", str))));
	        str = string_delete(str, 1, string_pos(" ", str));     
	ds_list_add(vy, real(string_copy(str, 1, string_pos(" ", str))));  
	ds_list_add(vz, real(string_delete(str, 1, string_pos(" ", str))));
	break;
	case "vn":
	ds_list_add(nx, real(string_copy(str, 1, string_pos(" ", str))));
	        str = string_delete(str, 1, string_pos(" ", str)); 
	ds_list_add(ny, real(string_copy(str, 1, string_pos(" ", str))));
	ds_list_add(nz, real(string_delete(str, 1, string_pos(" ", str))));
	break;
	case "vt":
	ds_list_add(tx, real(string_copy(str, 1, string_pos(" ", str))));
	ds_list_add(ty, real(string_delete(str, 1, string_pos(" ", str))));
	break;
	case "f ":
	        if (string_char_at(str, string_length(str)) == " "){str = string_copy(str, 0, string_length(str) - 1);}
	        triNum = string_count(" ", str);
	        for (i = 0; i < triNum; i ++){
	            vertString[i] = string_copy(str, 1, string_pos(" ", str));
	            str = string_delete(str, 1, string_pos(" ", str));}
	vertString[i--] = str;
	        while i--{for (j = 2; j >= 0; j --){ds_list_add(fl, vertString[(i + j) * (j > 0)]);}}
	break;
	}
	    file_text_readln(file);
	}
	for (var f = 0; f < ds_list_size(fl); f ++)
	{
	vertString = fl[| f];
	v = 0; n = 0; t = 0;
	if string_count("/", vertString) == 2 and string_count("//", vertString) == 0{
	v = real(string_copy(vertString, 1, string_pos("/", vertString) - 1));
	vertString = string_delete(vertString, 1, string_pos("/", vertString));
	t = real(string_copy(vertString, 1, string_pos("/", vertString) - 1));
	n = real(string_delete(vertString, 1, string_pos("/", vertString)));}
	else if string_count("/", vertString) == 1{
	v = real(string_copy(vertString, 1, string_pos("/", vertString) - 1));
	t = real(string_delete(vertString, 1, string_pos("/", vertString)));}
	else if (string_count("/", vertString) == 0){
	v = real(vertString);}
	else if string_count("/",vertString) == 2 and string_count("//", vertString) == 1{
	vertString = string_replace(vertString, "//", "/");
	v = real(string_copy(vertString, 1, string_pos("/", vertString) - 1));
	n = real(string_delete(vertString, 1, string_pos("/", vertString)));}
	smf_add_vertex(modelBuffer, vx[| v], vz[| v], vy[| v], nx[| n], nz[| n], ny[| n], tx[| t], 1 - ty[| t], 0, 0, c_white, 1);
	}
	file_text_close(file); 
	vertex_end(modelBuffer);

	ds_list_destroy(vx);
	ds_list_destroy(vy);
	ds_list_destroy(vz);
	ds_list_destroy(nx);
	ds_list_destroy(ny);
	ds_list_destroy(nz);
	ds_list_destroy(tx);
	ds_list_destroy(ty);
	ds_list_destroy(fl);

	show_debug_message("Successfully loaded obj " + string(filename));
	return modelBuffer;
}
