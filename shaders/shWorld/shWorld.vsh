//SMF vertex übershader
attribute vec3 in_Position;                // (x,y,z)
attribute vec3 in_Normal;                  // (x,y,z)
attribute vec2 in_TextureCoord;            // (u,v)
attribute vec4 in_Colour;                 // (r, g, b, a)
attribute vec4 in_Colour2;                  // (bone1, bone2, weight1, weight2)
attribute vec4 in_Colour3;                 // (bone1, bone2, weight1, weight2)

varying vec3 v_worldPosition;
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

//Lighting
uniform vec3 lightDirection;
uniform vec4 lightColor;
uniform vec4 lightAmbientColor;

//Visual
uniform float time;
uniform vec2 scroll;

//Animation
uniform bool animated;
const int maxBones = 64;
uniform vec4 boneDQ[2 * maxBones];

void main()
{
    v_vTexcoord = in_TextureCoord + (time * scroll);
    vec3 objectSpaceNormal = in_Normal;
    if (animated)
    {
        //Get bone indices and bone weights
        int bone1 = int(in_Colour2.r * 510.);
        int bone2 = int(in_Colour2.g * 510.);
        int bone3 = int(in_Colour2.b * 510.);
        int bone4 = int(in_Colour2.a * 510.);
        float weight1 = in_Colour3.r;
        float weight2 = in_Colour3.g;
        float weight3 = in_Colour3.b;
        float weight4 = in_Colour3.a;
		
        //Blend bones
        vec4 blendReal = 
        boneDQ[bone1] * weight1 + 
        boneDQ[bone2] * weight2 + 
        boneDQ[bone3] * weight3 + 
        boneDQ[bone4] * weight4;
        vec4 blendDual = 
        boneDQ[bone1 + 1] * weight1 + 
        boneDQ[bone2 + 1] * weight2 + 
        boneDQ[bone3 + 1] * weight3 + 
        boneDQ[bone4 + 1] * weight4;
        
		//Normalize resulting dual quaternion
        float blendNormReal = 1. / length(blendReal);
        blendReal *= blendNormReal;
        blendDual = (blendDual - blendReal * dot(blendReal, blendDual)) * blendNormReal;
        
		//Vertex Transformation, Rotation & Translation
        gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position + 2. * cross(blendReal.xyz, cross(blendReal.xyz, in_Position) + blendReal.w * in_Position) + 2. * (blendReal.w * blendDual.xyz - blendDual.w * blendReal.xyz + cross(blendReal.xyz, blendDual.xyz)), 1.);
        
		//Transform normal vector
        objectSpaceNormal += 2. * cross(blendReal.xyz, cross(blendReal.xyz, in_Normal) + blendReal.w * in_Normal);
    }
    else gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.);
    
	//Vertex Transformation, Rotation & Translation
    v_worldPosition = gl_Position.xyz;
    v_vColour = in_Colour * vec4(min(lightAmbientColor + lightColor * max(dot(normalize(mat3(gm_Matrices[MATRIX_WORLD]) * objectSpaceNormal), normalize(-lightDirection)), 0.), vec4(1.)).rgb, in_Colour.a);
}