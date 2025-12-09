#version 430

// Input and output topologies
layout(triangles) in;
layout(triangle_strip, max_vertices = 170) out;

// Uniform properties
uniform mat4 View;
uniform mat4 Projection;
// TODO(student): Declare other uniforms here

// Output
layout(location = 0) out vec3 color;

void EmitPoint(vec4 position, vec3 c)
{
    color = c;
    gl_Position = Projection * View * position;
    EmitVertex();
}

void main()
{
    vec4 p1 = gl_in[0].gl_Position;
    vec4 p2 = gl_in[1].gl_Position;
    vec4 p3 = gl_in[2].gl_Position;
    // TODO(student): Emit the vertices of the triangle for which
    // information is received in the input attributes. Use EmitPoint()
    // and set a color information associated with each vertex.
    EmitPoint(p1, vec3(1, 0, 0));
    EmitPoint((p1+p2)/2, vec3(1, 1, 0));
    EmitPoint((p1+p3)/2, vec3(1, 1, 0));
    EmitPoint((p2+p3)/2, vec3(1, 1, 0));
    EmitPoint(p3, vec3(1, 0, 0));
    EndPrimitive();
    EmitPoint(p2, vec3(1, 0, 0));
    EmitPoint((p2+p3)/2, vec3(1, 1, 0));
    EmitPoint((p2+p1)/2, vec3(1, 1, 0));
}
