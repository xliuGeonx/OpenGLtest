#version 330 core

// Ouput data
out vec3 color;

uniform vec3 VertexColor;

void main()
{

	// Output color = red 
	color = VertexColor;

}