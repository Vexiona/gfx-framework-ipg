#version 330

// Input
in vec2 texture_coord;

// Uniform properties
uniform sampler2D texture_1;
// TODO(student): Declare various other uniforms
uniform float Time;

// Output
layout(location = 0) out vec4 out_color;


void main()
{
    // TODO(student): Calculate the out_color using the texture() function.
    out_color = texture(texture_1, texture_coord + vec2(Time / 3.0, 0));
}
