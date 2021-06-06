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
frame = 0;
frameSpeed = 0;
frameSample = undefined;
yaw = 0;
pitch = 0;
roll = 0;
angle = 0;
scale = 1;
xScale = 1;
yScale = 1;
zScale = 1;
emitter = audio_emitter_create();

//Physics
z = 0;
radius = 4;
height = 12;
xSpeed = 0;
ySpeed = 0;
zSpeed = 0;
faceDirection = 0;
moveDirection = 0;
bounciness = 0;

//Flags
fCollision = true;
fEnemy = false; //Make game detect actor as an enemy
fGravity = true;
fPersistent = false; //If enabled, won't re-appear in its starting room once destroyed
fShadow = true;
fSmooth = true; //Smooth movement in framerates higher than 60
fVisible = true; //Enable actor drawing

//Update Actor (automatically called by global.clock, but has to be added first)

tick = function()
{
	x += xSpeed;
	y += ySpeed;
	if (fGravity) zSpeed -= 0.1;
	z += zSpeed;
}

//Draw Actor (automatically called by objCamera)

global.clock.variable_interpolate("frame", "frame_smooth");
global.clock.variable_interpolate("yaw", "yaw_smooth");
global.clock.variable_interpolate("pitch", "pitch_smooth");
global.clock.variable_interpolate("roll", "roll_smooth");
global.clock.variable_interpolate("x", "x_smooth");
global.clock.variable_interpolate("y", "y_smooth");
global.clock.variable_interpolate("z", "z_smooth");
draw = function()
{
	if !(fVisible) exit
	
	var _frame, _yaw, _pitch, _roll, _x, _y, _z;
	if (fSmooth)
	{
		_frame = frame_smooth;
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
		_yaw = yaw;
		_pitch = pitch;
		_roll = roll;
		_x = x;
		_y = y;
		_z = z;
	}
}