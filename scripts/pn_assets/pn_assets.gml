/*-----SPRITES-----
Commonly used by actors and HUDs. Can be a 2D image or a 3D model, static or animated.
A sprite can be a PNG, JPEG or GIF and a model is a folder containing SMF, ANI and model.txt files.
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
2... - textures
-----Model Array Indices-----
0 - submodels (submodel: model|skins...)
1 - bodygroups (bodygroup: model0|material0|model1|material1...)
2... - animation: index|frameCycle|samples...
-----sprites.txt Format-----
name|frames|type|xOffset|yOffset
Types: 0 = normal
	   1 = 4-directional
	   2 = billboard
	   3 = 4-directional billboard
-----model.txt Format-----
Submodel: 0|submodelID|skin 0 material ID...
Bodygroup: 1|bodygroupID|model 0 material ID...
Animation: 2|animationID|frameCycle|frames
Frame cycles: 0 = linear
			  1 = linear, loop
			  2 = quadratic
			  3 = quadratic, loop
NOTE: Loading a model will also load the materials used by it.*/

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
			//Models (WIP)
			case (""):
				//Look in model.txt for model data before loading
				var _model = [], _submodels = undefined, _bodygroups = undefined, _type = eModelType._static;
				
				//Submodels
				dataTable = file_text_open_read(mDirSprites + _name + "/model.txt");
				while !(file_text_eof(dataTable))
				{
					var data = string_parse(file_text_read_string(dataTable));
					if (real(data[0]) == 0)
					{
						var _getSubmodel = smf_model_load(mDirSprites + _name + "/" + data[1] + ".smf"), i = 0;
						if (_getSubmodel != -1)
						{
							if (is_undefined(_submodels)) _submodels = [];
							var _submodel = [_getSubmodel];
							repeat (array_length(data) - 1)
							{
								var _material = data[i + 1];
								pn_material_queue(_material);
								_submodel[@ i + 1] = _material;
								i++;
							}
							_submodels[@ array_length(_submodels)] = _submodel;
						}
						else
						{
							show_debug_message("!!! PNSprite: Submodel " + data[1] + " does not exist in " + _name);
							file_text_close(dataTable);
							exit
						}
					}
					file_text_readln(dataTable);
				}
				file_text_close(dataTable);
				
				_model[@ 0] = _submodels;
				
				//Bodygroups
				dataTable = file_text_open_read(mDirSprites + _name + "/model.txt");
				while !(file_text_eof(dataTable))
				{
					var data = string_parse(file_text_read_string(dataTable));
					if (real(data[0]) == 1)
					{
						if (is_undefined(_bodygroups)) _bodygroups = [];
						var i = 2;
						repeat (array_length(data) - 2)
						{
							var _bodygroup = [], _bodygroupModel = smf_model_load(mDirSprites + _name + "/" + data[1] + "/" + string(i) + ".smf");
							if (_bodygroupModel == -1)
							{
								show_debug_message("!!! PNSprite: Model " + data[i] + " does not exist in bodygroup " + data[1] + " in " + _name);
								exit
							}
							pn_material_queue(data[i]);
							_bodygroup[@ array_length(_bodygroup)] = _bodygroupModel;
							_bodygroup[@ array_length(_bodygroup)] = data[i];
							i++;
						}
						_bodygroups[@ array_length(_bodygroups)] = _bodygroup;
					}
					file_text_readln(dataTable);
				}
				file_text_close(dataTable);
				
				_model[@ 1] = _bodygroups;
				
				//Animations
				dataTable = file_text_open_read(mDirSprites + _name + "/model.txt");
				while !(file_text_eof(dataTable))
				{
					var data = string_parse(file_text_read_string(dataTable));
					if (real(data[0]) == 2)
					{
						_type = eModelType.animated;
						var _animationIndex = smf_animation_load(mDirSprites + _name + "/" + data[1] + ".ani");
						if (_animationIndex == -1)
						{
							show_debug_message("!!! PNSprite: Animation " + data[i] + " does not exist in " + _name);
							exit
						}
						var _animation = [_animationIndex, real(data[2])];
						for (var i = 0, n = real(data[3]); i < n; i++) _animation[@ 2 + i] = smf_sample_create(_animationIndex, _animation[1], i / n);
						if ((_animation[1] == SMF_play_linear || _animation[1] == SMF_play_quadratic) && n > 1) _animation[@ 2 + n] = smf_sample_create(_animationIndex, _animation[1], 1);
						_model[@ array_length(_model)] = _animation;
					}
					file_text_readln(dataTable);
				}
				file_text_close(dataTable);

				var queueSprite = [_model, _type];

				ds_map_add(global.sprites, _name, queueSprite);
				show_debug_message("PNSprite: Added " + _name + " (" + string(queueSprite) + ")");
			break
			
			//Sprites
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
				
				queueSprite = [_sprite, _type];
				
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
A material can be a PNG, JPEG or GIF.
-----Array Indices-----
0 - sprite
1 - frames
2 - speed
3 - x scroll
4 - y scroll
5 - specular
6 - crystal
7... - textures
-----materials.txt Format-----
name|frames|speed|xScroll|yScroll|specular|crystal*/

#macro mDirMaterials "data/gfx/materials/"

function pn_material_queue(_name)
{
	if (ds_map_exists(global.materials, _name)) exit
	
	var queueMaterial, getMaterial = file_find_first(mDirMaterials + _name + ".*", 0);
	if (getMaterial == "")
	{
		show_debug_message("!!! PNMaterial: " + _name + " not found");
		exit
	}
	else
	{
		var getExt = string_lower(filename_ext(getMaterial));
		switch (getExt)
		{
			case (".png"):
			case (".gif"):
			case (".jpg"):
				//Look in materials.txt for material data before loading
				var _sprite, _frames = 1, _speed = undefined, _xScroll = 0, _yScroll = 0, _specular = 0, _crystal = 0;
				
				dataTable = file_text_open_read(mDirMaterials + "materials.txt");
				while !(file_text_eof(dataTable))
				{
					var data = string_parse(file_text_read_string(dataTable));
					if (data[0] == _name)
					{
						_frames = real(data[1]);
						_speed = real(data[2]);
						_xScroll = real(data[3]);
						_yScroll = real(data[4]);
						_specular = real(data[5]);
						_crystal = real(data[6]);
						break
					}
					file_text_readln(dataTable);
				}
				file_text_close(dataTable);
				
				_sprite = sprite_add(mDirMaterials + getMaterial, _frames, false, false, 0, 0);
				
				queueMaterial = [_sprite, _frames, _speed, _xScroll, _yScroll, _specular, _crystal];
				
				for (var i = 0; i < sprite_get_number(_sprite); i++) queueMaterial[@ 7 + i] = sprite_get_texture(_sprite, i);
				
				ds_map_add(global.materials, _name, queueMaterial);
				show_debug_message("PNMaterial: Added " + _name + " (" + string(queueMaterial) + ")");
			break
			
			default:
				show_debug_message("!!! PNMaterial: " + _name + " is not an image file");
				exit
		}
	}
	file_find_close();
}

function pn_material_get_texture(_name)
{
	var getMaterial = global.materials[? _name];
	return (is_undefined(getMaterial) ? -1 : getMaterial[getMaterial[1] > 1 ? 7 + (current_time * getMaterial[2]) mod (getMaterial[1]) : 7])
}

/*-----FONTS-----
Sprite fonts have to have a defined amount of frames in fonts.txt and have the character frames laid out like the UTF8 map.
A font can be a TTF, PNG, JPEG or GIF.
-----Array Indices (for sprite fonts, regular fonts point directly to their pointers)-----
0 - font
1 - sprite (undefined if TTF font)
-----fonts.txt Format-----
TTF: name|size|bold|italics|first|last
PNG/JPEG/GIF: name|frames|first|proportional|space

Refer to GML documentation on font_add and font_add_sprite for info on fonts.txt parameters:
https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Fonts/font_add.htm
https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Fonts/font_add_sprite.htm*/

#macro mDirFonts "data/gfx/fonts/"

function pn_font_queue(_name)
{
	if (ds_map_exists(global.fonts, _name)) exit
	
	var queueFont, getFont = file_find_first(mDirFonts + _name + ".*", 0);
	if (getFont == "")
	{
		show_debug_message("!!! PNFont: " + _name + " not found");
		exit
	}
	else
	{
		var getExt = string_lower(filename_ext(getFont));
		switch (getExt)
		{
			case (".ttf"):
				//Look in fonts.txt for font data before loading
				var _size = 8, _bold = false, _italics = false, _first = 32, _last = 128;
				
				dataTable = file_text_open_read(mDirFonts + "fonts.txt");
				while !(file_text_eof(dataTable))
				{
					var data = string_parse(file_text_read_string(dataTable));
					if (data[0] == _name)
					{
						_size = real(data[1]);
						_bold = real(data[2]);
						_italics = real(data[3]);
						_first = ord(data[4]);
						_last = ord(data[5]);
						break
					}
					file_text_readln(dataTable);
				}
				file_text_close(dataTable);
				
				queueFont = font_add(mDirFonts + getFont, _size, _bold, _italics, _first, _last);
				
				ds_map_add(global.fonts, _name, queueFont);
				show_debug_message("PNFont: Added " + _name + " (" + string(queueFont) + ")");
			break
			
			case (".png"):
			case (".gif"):
			case (".jpg"):
				//Look in fonts.txt for font data before loading
				var _sprite, _frames = 1, _first = ord("!"), _proportional = true, _space = 1;
				
				dataTable = file_text_open_read(mDirFonts + "fonts.txt");
				while !(file_text_eof(dataTable))
				{
					var data = string_parse(file_text_read_string(dataTable));
					if (data[0] == _name)
					{
						_frames = real(data[1]);
						_first = ord(data[2]);
						_proportional = real(data[3]);
						_space = real(data[4]);
						break
					}
					file_text_readln(dataTable);
				}
				file_text_close(dataTable);
				
				_sprite = sprite_add(mDirFonts + getFont, _frames, false, false, 0, 0);
				
				queueFont = [font_add_sprite(_sprite, _first, _proportional, _space), _sprite];
				
				ds_map_add(global.fonts, _name, queueFont);
				show_debug_message("PNFont: Added " + _name + " (" + string(queueFont) + ")");
			break
			
			default:
				show_debug_message("!!! PNFont: " + _name + " is not a font or image file");
				exit
		}
	}
	file_find_close();
}

function pn_font_get_font(_name)
{
	var getFont = global.fonts[? _name];
	return (is_array(getFont) ? getFont[0] : getFont)
}

/*-----SOUNDS-----
Used by actors and anything otherwise. Distance falloff can be toggled.
A sound must be an OGG.
-----Array Indices-----
0 - sound
1 - falloff
-----sounds.txt Format-----
name|falloff*/

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

/*-----MUSIC-----
Played in the background. Can be played once or looped.
A music track can be any sound file that can be loaded by FMOD.
-----music.txt Format-----
name|start|end

[NOTE]
Exclude the music track from music.txt in order for it to play only once.
Start and end points must be in samples (seconds * sample rate).
Set start point to -1 in order to loop from start to finish (end point can be left out)*/

#macro mDirMusic "data/sfx/music/"

function pn_music_load(_name)
{
	if (ds_map_exists(global.music, _name)) exit
	
	var loadMusic, getMusic = file_find_first(mDirMusic + _name + ".*", 0);
	if (getMusic == "")
	{
		show_debug_message("!!! PNMusic: " + _name + " not found");
		exit
	}
	else
	{
		var getExt = string_lower(filename_ext(getMusic));
		switch (getExt)
		{
			case (".aiff"):
			case (".asf"):
			case (".asx"):
			case (".dls"):
			case (".flac"):
			case (".fsb"):
			case (".it"):
			case (".m3u"):
			case (".mid"):
			case (".mod"):
			case (".mp2"):
			case (".mp3"):
			case (".ogg"):
			case (".pls"):
			case (".s3m"):
			case (".vag"):
			case (".wav"):
			case (".wax"):
			case (".wma"):
			case (".xm"):
			case (".xma"):
				loadMusic = FMODGMS_Snd_LoadSound(mDirMusic + getMusic);
		
				ds_map_add(global.music, _name, loadMusic);
				show_debug_message("PNMusic: Added " + _name + " (" + string(loadMusic) + ")");
				
				//Look in music.txt for music data
				
				dataTable = file_text_open_read(mDirMusic + "music.txt");
				while !(file_text_eof(dataTable))
				{
					var data = string_parse(file_text_read_string(dataTable));
					if (data[0] == _name)
					{
						var _start = real(data[1]);
						FMODGMS_Snd_Set_LoopPoints(loadMusic, _start == -1 ? 0 : _start, _start == -1 ? FMODGMS_Snd_Get_Length(loadMusic) : real(data[2]));
						break
					}
					file_text_readln(dataTable);
				}
				file_text_close(dataTable);
			break
			
			default:
				show_debug_message("!!! PNMusic: " + _name + " is not an audio file");
				exit
		}
	}
	file_find_close();
}