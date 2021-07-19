/// @description Create Actor

//Level
tag = 0;
roomID = 0; //Spawning room ID
uID = -1; //Unique ID in own room to prevent duplication via room changing

//General
hp = 0;

//Visual
sprite = undefined;
animation = 0;
animationFinished = false;
frame = 0;
framePrevious = -1;
frameSpeed = 0;
frameSample = undefined;
submodel = undefined;
bodygroup = undefined;
yaw = 0;
pitch = 0;
roll = 0;
angle = 0;
scale = 1;
xScale = 1;
yScale = 1;
zScale = 1;
alpha = 1;
emitter = audio_emitter_create();

//Physics
z = 0;
zPrevious = 0;
radius = 4;
height = 12;
xSpeed = 0;
ySpeed = 0;
zSpeed = 0;
faceDirection = 0;
moveDirection = 0;
bounciness = 0;
surface = eSurface.none;

//Flags
fCollision = true;
fOnGround = true;
fEnemy = false; //Make game detect actor as an enemy
fGravity = true;
fPersistent = false; //If enabled, won't re-appear in its starting room once destroyed
fShadow = true;
fSmooth = true; //Smooth movement in framerates higher than 60
fVisible = true; //Enable actor drawing

//Post-initialize actor (automatically called by pn_room_goto)
basePostInitialize = function()
{
	//Setup submodel & bodygroup variables if the sprite is a model
	var getSprite = global.sprites[? sprite];
	if !(is_undefined(getSprite))
	{
		var spriteData = getSprite[0];
		if (is_array(spriteData))
		{
			var submodels = spriteData[0], bodygroups = spriteData[1];
			if !(is_undefined(submodels)) submodel = array_create(array_length(submodels), 0);
			if !(is_undefined(bodygroups)) bodygroup = array_create(array_length(bodygroups), 0);
		}
	}
}
postInitialize = function() { basePostInitialize(); }

//Update Actor (automatically called by objControl)
baseTick = function()
{
	//Update sprite
	if !(is_undefined(sprite))
	{
		var n = 0, getSprite = global.sprites[? sprite];
		if !(is_undefined(getSprite))
		{
			var spriteData = getSprite[0], spriteType = getSprite[1];
		
			switch (spriteType)
			{
				case (eSpriteType.normal):
				case (eSpriteType.billboard): n = sprite_get_number(spriteData) - 1; break
				case (eSpriteType.rotate):
				case (eSpriteType.billboardRotate): n = sprite_get_number(spriteData) * 0.25; break
				case (eModelType.animated): n = array_length(spriteData[2 + animation]) - 2; break
			}
		
			if (n) if (spriteType == eModelType.animated)
			{
				animationFinished = false;
				
				var getAnimation = spriteData[2 + animation], frameCycleType = getAnimation[1];
				if (frameCycleType == 1 || frameCycleType == 3) frame = (frame + frameSpeed) mod (n); //Looping animation
				else //Animation plays only once
				{
					var frames = n - 1;
					frame = min(frame + frameSpeed, frames);
					animationFinished = frame == frames;
				}
			}
			else frame = (frame + frameSpeed) mod (n);
		}
	}
	
	//Movement & collision
	zPrevious = z;
	
	x += xSpeed;
	y += ySpeed;
	if (fGravity && !fOnGround) zSpeed -= 0.1;
	z += zSpeed;
	
	if (fCollision)
	{
		var getRoom = global.levelData[? global.levelRoom];
		if (!is_undefined(getRoom) && !is_undefined(getRoom[eRoomData.collision]))
		{
			var half = height * 0.5, i = 0;
			repeat (array_length(getRoom[eRoomData.collision]))
			{
				var collision = getRoom[eRoomData.collision][i];
				if !(collision[eCollisionData.active]) continue
			
				var mesh = collision[eCollisionData.mesh];
			
				//Top
				var collision = mesh.castRay(xprevious, yprevious, zPrevious + half, x, y, z + height);
				if (is_array(collision))
				{
					z = collision[2] - height;
					zSpeed = 0;
				}
			
				//X-axis
				collision = mesh.castRay(xprevious - radius, yprevious, zPrevious + half, x + radius, y, z + half);
				if (is_array(collision))
				{
					x = collision[0] + collision[3] * radius;
					xSpeed = 0;
				}
			
				//Y-axis
				collision = mesh.castRay(xprevious, yprevious - radius, zPrevious + half, x, y + radius, z + half);
				if (is_array(collision))
				{
					y = collision[1] + collision[4] * radius;
					ySpeed = 0;
				}
			
				//Bottom
				collision = mesh.castRay(xprevious, yprevious, zPrevious + half, x, y, z);
				if (is_array(collision))
				{
					z = collision[2];
					zSpeed = 0;
					fOnGround = true;
					surface = collision[eCollisionData.surface];
				}
				else
				{
					fOnGround = false;
					surface = eSurface.none;
				}
			
				i++;
			}
		}
		else
		{
			fOnGround = false;
			surface = eSurface.none;
		}
	}
	else
	{
		fOnGround = false;
		surface = eSurface.none;
	}
}
tick = function() { baseTick(); }

//Draw Actor (automatically called by objCamera)
//global.clock.variable_interpolate("frame", "frame_smooth");
global.clock.variable_interpolate("scale", "scale_smooth");
global.clock.variable_interpolate("xScale", "xScale_smooth");
global.clock.variable_interpolate("yScale", "yScale_smooth");
global.clock.variable_interpolate("zScale", "zScale_smooth");
global.clock.variable_interpolate("yaw", "yaw_smooth");
global.clock.variable_interpolate("pitch", "pitch_smooth");
global.clock.variable_interpolate("roll", "roll_smooth");
global.clock.variable_interpolate("x", "x_smooth");
global.clock.variable_interpolate("y", "y_smooth");
global.clock.variable_interpolate("z", "z_smooth");
baseDraw = function()
{
	if (is_undefined(sprite)) exit
	
	var _frame, _scale, _xScale, _yScale, _zScale, _yaw, _pitch, _roll, _x, _y, _z;
	if (fSmooth)
	{
		_frame = frame;
		_scale = scale_smooth;
		_xScale = xScale_smooth;
		_yScale = yScale_smooth;
		_zScale = zScale_smooth;
		_yaw = yaw_smooth;
		_pitch = pitch_smooth;
		_roll = roll_smooth;
		_x = x_smooth;
		_y = y_smooth;
		_z = z_smooth;
	}
	else
	{
		_frame = frame;
		_scale = scale;
		_xScale = xScale;
		_yScale = yScale;
		_zScale = zScale;
		_yaw = yaw;
		_pitch = pitch;
		_roll = roll;
		_x = x;
		_y = y;
		_z = z;
	}
	
	var getSprite = global.sprites[? sprite];
	if (is_undefined(getSprite)) exit
	var spriteData = getSprite[0], spriteType = getSprite[1];
	if (spriteType > eSpriteType.billboardRotate) //Sprite is a static or animated model
	{
		if (spriteType == eModelType.animated && framePrevious != _frame)
		{
			var getAnimation = spriteData[2 + animation], n = array_length(getAnimation) - 2;
			var cycle = (getAnimation[1] == 1 || getAnimation[1] == 3) ? (_frame + 1) mod (n) : min(_frame + 1, n);
            frameSample = smf_sample_blend(getAnimation[2 + floor(_frame)], getAnimation[2 + floor(cycle)], frac(_frame));
            framePrevious = _frame;
			smf_animation_set_shader_uniforms(shWorld, frameSample);
		}
		shader_set_uniform_f(shader_get_uniform(shWorld, "animated"), spriteType == eModelType.animated);
		
		matrix_set(matrix_world, matrix_build(_x, _y, _z, _roll, _pitch, _yaw, _scale * _xScale, _scale * _yScale, _scale * _zScale));
		
		var submodels = spriteData[0], bodygroups = spriteData[1], i = 0;
		if !(is_undefined(submodels)) repeat (array_length(submodels))
		{
			var getSubmodel = submodels[i];
			smf_model_draw(getSubmodel[0], pn_material_get_texture(getSubmodel[1 + submodel[i]]));
			i++;
		}
		i = 0;
		if !(is_undefined(bodygroups)) repeat (array_length(bodygroups))
		{
			var getBodygroup = bodygroups[i], n = bodygroup[i] * 2;
			smf_model_draw(getBodygroup[n], pn_material_get_texture(getBodygroup[n + 1]));
			i++;
		}
	}
}
draw = function() { baseDraw(); }