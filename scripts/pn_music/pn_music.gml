function pn_music_gain(_channel, _volume, _time)
{
	var slot = _channel * 5;
	global.levelMusic[slot + 2] = global.levelMusic[slot + 1];
	global.levelMusic[slot + 3] = _volume;
	global.levelMusic[slot + 4] = _time;
	objControl.timer[_channel] = _time;
}