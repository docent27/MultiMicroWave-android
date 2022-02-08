#version 120
precision highp float;
    
varying vec3  screenCoordsPassthrough;
varying vec4  position;
varying float linearDepth;

#include "shadows_vertex.glsl"

void main(void)
{
	vec3 cameraPos = (gl_ModelViewMatrixInverse * vec4(0.0,0.0,0.0,1.0)).xyz;
	float zbias = 0.0;
		
	if(cameraPos.z > 0.0)
		zbias = mix(0.0, -35.0, clamp(cameraPos.z, 0.0, 1000.0)/1000.0);
	
    gl_Position = gl_ModelViewProjectionMatrix * (gl_Vertex + vec4(0.0, 0.0, zbias,0.0));

    mat4 scalemat = mat4(0.5, 0.0, 0.0, 0.0,
                         0.0, -0.5, 0.0, 0.0,
                         0.0, 0.0, 0.5, 0.0,
                         0.5, 0.5, 0.5, 1.0);

    vec4 texcoordProj = ((scalemat) * ( gl_Position));
    screenCoordsPassthrough = texcoordProj.xyw;

    position = gl_Vertex + vec4(0.0, 0.0, zbias, 0.0);

    linearDepth = gl_Position.z;

    setupShadowCoords(gl_ModelViewMatrix * gl_Vertex, normalize((gl_NormalMatrix * gl_Normal).xyz));
}
