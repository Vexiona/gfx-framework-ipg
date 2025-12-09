#version 330

// Input
in vec2 texture_coord;

// Uniform properties
uniform sampler2D texture_1;
uniform sampler2D texture_2;

// Bonus
uniform sampler2D texture_snow;
uniform sampler2D texture_water;

// Output
layout(location = 0) out vec4 out_color;


void main()
{
    // TODO(student): Calculate the out_color using the texture() function.
    float height = texture(texture_2, texture_coord).r;
    float water_factor = max(min(0.1 - height, 0.0) + 0.1, 0.0) / 0.1;
    float snow_factor = max(min(height - 0.6, 0) + 0.1, 0) / 0.1;
    vec4 color = mix(mix(texture(texture_1, texture_coord), texture(texture_snow, texture_coord), snow_factor), texture(texture_water, texture_coord), water_factor);
    out_color = mix(color, vec4(height, height, height, 1.0), 0.5);
}
