#version 430

// Input and output topologies
layout(points) in;
layout(line_strip, max_vertices = 2) out;

// Input
layout(location = 0) in vec3 v_normal[];

// Uniform properties
uniform mat4 View;
uniform mat4 Projection;
// TODO(student): Declare other uniforms here

// Output

void main()
{
    gl_Position = Projection * View * gl_in[0].gl_Position;
    EmitVertex();
    gl_Position = Projection * View  * (gl_in[0].gl_Position + 3 * vec4(v_normal[0], 0));
    EmitVertex();
}
