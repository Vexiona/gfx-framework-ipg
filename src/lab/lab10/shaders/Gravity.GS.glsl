#version 430

// Input and output topologies
layout(triangles) in;
layout(triangle_strip, max_vertices = 170) out;

// Input
layout(location = 0) in vec3 v_normal[];
layout(location = 1) in vec2 v_texture_coord[];

// Uniform properties
uniform mat4 View;
uniform mat4 Projection;
// TODO(student): Declare other uniforms here
uniform double AnimationTime;

// Output
layout(location = 0) out vec2 texture_coord;

void main()
{
	// TODO(student): Emit the vertices of the triangle for which
	// information is received in the input attributes. Set the
	// following information for each vertex:
	//   - The coordinate of the vertex in clip space, transformed
	//     from world space, as received from the vertex shader
	//   - Texture coordinate received from the vertex shader.
    vec3 f_normal = (v_normal[0] + v_normal[1] + v_normal[2])/3;
    for(int i=0; i<3; i++)
    {
        gl_Position = gl_in[i].gl_Position + vec4(500 * AnimationTime * f_normal + 5 * AnimationTime * AnimationTime * vec3(0, -1, 0), 0);
        gl_Position.y = max(gl_Position.y, 0);
        gl_Position = Projection * View * gl_Position;
        texture_coord = v_texture_coord[i];
        EmitVertex();
    }
}
