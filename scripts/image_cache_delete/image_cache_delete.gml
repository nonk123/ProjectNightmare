/// @description image_cache_delete(cache)
/// @param cache
function image_cache_delete(argument0) {
	gml_pragma( "forceinline" );
	/*
	    Deletes the image cache
    
	    -------------------------
	        cache - The buffer that image_cache_create() or image_cache_load() returned.
	    -------------------------
	*/
	buffer_delete( argument0 );



}
