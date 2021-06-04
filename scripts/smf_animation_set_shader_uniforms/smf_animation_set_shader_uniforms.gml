/// @description smf_animation_set_shader_uniforms(shader, sample)
/// @param shader
/// @param  sample
function smf_animation_set_shader_uniforms(argument0, argument1)
{
	/*Script made by TheSnidr
	www.TheSnidr.com*/
	var shader = argument0;
	var sample = argument1;
	shader_set_uniform_f_array(shader_get_uniform(shader, "boneDQ"), sample);
}