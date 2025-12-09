#version 330

// Input
// TODO(student): Get vertex attributes from each location
layout(location = 0) in vec3 v_position;
layout(location = 1) in vec3 v_normal;
layout(location = 2) in vec3 v_tex_coord;
layout(location = 3) in vec3 v_color;


// Uniform properties
uniform mat4 Model;
uniform mat4 View;
uniform mat4 Projection;
uniform float Time;

// Output
// TODO(student): Output values to fragment shader
out vec3 color;

vec3 rand(vec3 co)
{
    return fract(sin(vec3(
        dot(co, vec3(12.989, 78.233, 45.164)),
        dot(co, vec3(93.989, 67.345, 12.345)),
        dot(co, vec3(45.332, 83.155, 24.623))
    )) * 43758.5453) - 0.5;
}

void main()
{
    // TODO(student): Send output to fragment shader
    color = v_position * 1.7;

    // TODO(student): Compute gl_Position
    gl_Position = Projection * View * Model * vec4(v_position + rand(v_position) * (sin(Time + rand(v_position).x) * 0.3), 1.0);
}