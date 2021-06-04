/// @description image_cache_save(cache,fname)
/// @param cache
/// @param fname
function image_cache_save(argument0, argument1) {
	gml_pragma( "forceinline" );
	/* 
	    Saves the cache as the fname.
    
	    NOTE: Sandboxing restrictions apply
    
	    -------------------------
	        cache - The buffer that image_cache_create() or image_cache_load() returned.
	        fname - The name of the file to save as. 
	    -------------------------
    
	    RETURNS boolean which shows whether the file was saved and created successfully or not
	*/

	buffer_save( argument0, argument1 );



}
