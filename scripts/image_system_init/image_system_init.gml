/// @description image_system_init()
function image_system_init() {
	global.m_ex_image = ds_map_create();
	global.ex_image_cache_version = "1.1";




	enum __IS {
	    TYPE_STRIP,
	    TYPE_SHEET,
	    TYPE_LIST,
	    TYPE_3D
	}

	enum __IS_STREAM_IMAGE {
	    ID,
	    TYPE,
	    FPATH,
	    SPRITES,
	    SUBIMG_COUNT,
	    WIDTH,
	    HEIGHT,
	    XORIG,
	    YORIG,
	    CLAMP_LEFT,
	    CLAMP_TOP,
	    SUBIMG_ROWS
	}

	enum __ISG_IMG { // Grid structure
	    ID,
	    SUBIMAGES,
	    WIDTH,
	    HEIGHT,
	    XORIGIN,
	    YORIGIN,
	    BBOX_LEFT,
	    BBOX_TOP,
	    BBOX_RIGHT,
	    BBOX_BOTTOM,
	    COUNT
	}

	enum __ISG_SUBIMG { // Grid structure for subimages
	    BACK,
	    X,
	    Y,
	    COUNT
	}





}
