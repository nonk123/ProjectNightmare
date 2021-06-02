/*-----SPRITES-----
Commonly used by actors and HUDs. Can be a 2D image or a 3D model, static or animated.
A sprite can be a PNG, JPEG or GIF and a model is a folder containing SMF and ANI files.
-----Types-----
Sprites:
	0 - normal
	1 - 4-directional
	2 - billboard
	3 - billboard, 4-directional
Models:
	0 - static
	1 - animated
-----Array Indices-----
0 - sprite (array if model)
1 - type
2... - textures*/

#macro mDirSprites "data/gfx/sprites/"

enum eSpriteType {normal, rotate, billboard, billboardRotate}
enum eModelType {_static, animated}

function pn_sprite_queue(_name)
{
	if (ds_map_exists(global.sprites, _name)) exit
	
	var queueSprite, getSprite = file_find_first(mDirSprites + _name + ".*", 0);
	if (getSprite == "")
	{
		show_debug_message("!!! PNSprite: " + _name + " not found");
		exit
	}
	else
	{
		var getExt = string_lower(filename_ext(getSprite));
		switch (getExt)
		{
			case (".png"):
			case (".gif"):
			case (".jpg"):
				//Look in sprites.txt for sprite data before loading
				var _sprite, _frames = 1, _type = eSpriteType.normal, _xOffset = 0, _yOffset = 0;
				
				dataTable = file_text_open_read(mDirSprites + "sprites.txt");
				while !(file_text_eof(dataTable))
				{
					var data = string_parse(file_text_read_string(dataTable));
					if (data[0] == _name)
					{
						_frames = real(data[1]);
						_type = real(data[2]);
						_xOffset = real(data[3]);
						_yOffset = real(data[4]);
						break
					}
					file_text_readln(dataTable);
				}
				file_text_close(dataTable);
				
				_sprite = sprite_add(mDirSprites + getSprite, _frames, false, false, 0, 0);
				sprite_set_offset(_sprite, _xOffset * sprite_get_width(_sprite), _yOffset * sprite_get_height(_sprite));
				
				queueSprite[0] = _sprite;
				queueSprite[1] = _type;
				
				for (var i = 0; i < sprite_get_number(_sprite); i++) queueSprite[@ 2 + i] = sprite_get_texture(_sprite, i);
				
				ds_map_add(global.sprites, _name, queueSprite);
				show_debug_message("PNSprite: Added " + _name + " (" + string(queueSprite) + ")");
			break
			
			default:
				show_debug_message("!!! PNSprite: " + _name + " is not an image file");
				exit
		}
	}
	file_find_close();
}

function pn_sprite_get_sprite(_name)
{
	var getSprite = global.sprites[? _name];
	return ((is_undefined(getSprite) || is_array(getSprite[0])) ? -1 : getSprite[0])
}

/*-----MATERIALS-----
Textures used by levels and models.
A material can be a PNG, JPEG or GIF.*/

#macro mDirMaterials ""

function PNMaterial(_name) constructor
{
	/*new PNMaterial(name)
	--------------------
	Loads a material from the data folder.*/
	
	sprite = undefined;
	textures = undefined;
	frames = undefined;
	_speed = undefined;
	xScroll = undefined;
	yScroll = undefined;
	specular = undefined;
	crystal = undefined;
	
	var getMaterial = file_find_first(mDirMaterials + _name + ".*", 0);
	if (getMaterial == "") show_debug_message("!!! PNMaterial: " + _name + " not found");
	else
	{
		var getExt = string_lower(filename_ext(getMaterial));
		switch (getExt)
		{
			case (".png"):
			case (".gif"):
			case (".jpg"):
				sprite = sprite_add(mDirMaterials + getMaterial + filename_ext(getMaterial), 1, false, false, 0, 0);
				textures = [sprite_get_texture(sprite, 0)];
				frames = 1;
			break
			default: show_debug_message("!!! PNMaterial: " + _name + " is not an image file");
		}
	}
	file_find_close();

	show_debug_message("PNMaterial: Added " + _name + " (" + string(self) + ")");
	
	/*Texture()
	-----------
	Returns the material's current texture.*/
	Texture = function() {return (textures[frames > 1 ? (current_time * _speed) mod (frames) : 0])}
	
	/*PNMaterial.Find(name)
	-----------------------
	Returns a material with the corresponding name, or undefined if none is found.*/
	
	static Find = function(_name) {return (global.materials[? _name])}
	
	/*PNMaterial.FindTexture(name)
	------------------------------
	Finds a material with the corresponding name and returns its current texture, or -1 if none is found.*/
	
	static FindTexture = function(_name)
	{
		var getMaterial = PNMaterial.Find(_name);
		return (is_undefined(getMaterial) ? -1 : getMaterial.Texture())
	}
}

/*-----SOUNDS-----
Used by actors and anything otherwise. Distance falloff can be toggled.
A sound must be an OGG.
-----Array Indices-----
0 - sound
1 - falloff*/

#macro mDirSounds "data/sfx/sounds/"

function pn_sound_load(_name)
{
	if (ds_map_exists(global.sounds, _name)) exit
	
	var loadSound, getSound = file_find_first(mDirSounds + _name + ".ogg", 0);
	if (getSound == "")
	{
		show_debug_message("!!! PNSound: " + _name + " not found or isn't an OGG");
		exit
	}
	else
	{
		//Look in sounds.txt for sound data before loading
		var _falloff = true;
				
		dataTable = file_text_open_read(mDirSounds + "sounds.txt");
		while !(file_text_eof(dataTable))
		{
			var data = string_parse(file_text_read_string(dataTable));
			if (data[0] == _name)
			{
				_falloff = real(data[1]);
				break
			}
			file_text_readln(dataTable);
		}
		file_text_close(dataTable);
		
		loadSound[0] = audio_create_stream(mDirSounds + getSound);
		loadSound[1] = _falloff;
		
		ds_map_add(global.sounds, _name, loadSound);
		show_debug_message("PNSound: Added " + _name + " (" + string(loadSound) + ")");
	}
	file_find_close();
}