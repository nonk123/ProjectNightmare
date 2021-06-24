//SMF fragment übershader
varying vec3 v_worldPosition;
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

//Fog
uniform float fogStart;
uniform float fogEnd;
uniform vec4 fogColor;

//Texture scroll
uniform float specular;
uniform float crystal;

void main()
{
    vec4 starting_color = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
    if (starting_color.a == 0.) discard; //Ignore transparent texture pixels
    vec4 final_color = mix(starting_color, fogColor, clamp((length(v_worldPosition) - fogStart) / (fogEnd - fogStart), 0.0, 1.0));
    gl_FragColor = final_color;
}