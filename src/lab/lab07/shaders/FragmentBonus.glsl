#version 330

// Input
// TODO(student): Get color value from vertex shader
in vec3 world_position;
in vec3 world_normal;
in vec2 texture_coord;

// Uniforms for light properties
uniform float point_lights_count;
uniform vec3 point_light_positions[10];
uniform vec3 point_light_colors[10];
uniform vec3 spot_light_positions[10];
uniform vec3 spot_light_colors[10];
uniform vec3 spot_light_directions[10];
uniform float spot_light_angles[10];
uniform vec3 eye_position;
uniform vec3 material_ka;
uniform vec3 material_kd;
uniform vec3 material_ks;
uniform int material_shininess;
// Uniform for bonus animation
uniform float animationThreshold;

// Output
layout(location = 0) out vec4 out_color;

// Globals
vec3 N;
vec3 V;
// Globals for bonus
vec3 bonus_material_ka;
vec3 bonus_material_kd;
vec3 bonus_material_ks;

vec3 ComputePhongIllumination(vec3 light_position)
{
    vec3 L = normalize(light_position - world_position);
    vec3 R = reflect(-L, N);

    // TODO(student): Compute the diffuse component of the Lambert illumination model
    vec3 diffuse_component = bonus_material_kd * max(dot(N, L), 0);

    // TODO(student): Compute the specular component of the Phong illumination model
    vec3 specular_component = vec3(0);

    if (length(diffuse_component) > 0)
    {
        specular_component = bonus_material_ks * pow(max(dot(V, R), 0), material_shininess);
    }

    // TODO(student): Compute the final illumination as the sum of the diffuse and specular components
    vec3 illumination = diffuse_component + specular_component;

    return illumination;
}

float ComputeDistanceAttenuation(vec3 light_position, vec3 point_position)
{
    // TODO(student): Compute the light attenuation factor based on the distance
    // between the position of the illuminated point and the position of the light source.
    vec3 diff = light_position - point_position;
    return 1/(1+dot(diff, diff));
}

vec3 ComputePointLightSourcesIllumination()
{
    vec3 lights_illumination = vec3(0);

    for (int i=0;i<10;i++) {
        vec3 light_position = point_light_positions[i];
        vec3 light_color = point_light_colors[i];

        vec3 light_illumination = ComputePhongIllumination(light_position);
        float illumination_attenuation = ComputeDistanceAttenuation(light_position, world_position);

        // TODO(student): Add to the illumination of all light sources the result
        // of multiplying the illumination of the light source from the current iteration
        // with the attenuation of the illumination and the color of the illumination.
        lights_illumination += illumination_attenuation * light_illumination * light_color;
    }

    return lights_illumination;
}

vec3 ComputeSpotLightSourcesIllumination()
{
    vec3 lights_illumination = vec3(0);

    for (int i=0;i<10;i++) {
        vec3 light_position = spot_light_positions[i];
        vec3 light_color = spot_light_colors[i];
        vec3 light_direction = spot_light_directions[i];
        float cut_off_angle = spot_light_angles[i];

        vec3 L = normalize(light_position-world_position);
        float cos_theta_angle = dot(-L, light_direction);
        float cos_phi_angle = cos(cut_off_angle);
        if (cos_theta_angle > cos_phi_angle)
        {
            vec3 light_illumination = ComputePhongIllumination(light_position);
            float illumination_attenuation = ComputeDistanceAttenuation(light_position, world_position);

            // TODO(student): Compute the attenuation factor specific to the spot light source
            float spot_linear_att_factor = (cos_theta_angle - cos_phi_angle) / (1.0f - cos_phi_angle);
            float quadratic_spot_light_att_factor = pow(spot_linear_att_factor, 2);

            // TODO(student): Add to the illumination of all light sources the result
            // of multiplying the illumination of the light source from the current iteration
            // with the attenuation of the illumination, the attenuation factor specific
            // to the light spot source and the color of the illumination.
            lights_illumination += quadratic_spot_light_att_factor * illumination_attenuation * light_illumination * light_color;
        }
    }

    return lights_illumination;
}

vec3 ComputeAmbientComponent()
{
    vec3 global_ambient_color = vec3(0.25f);

    // TODO(student): Compute the ambient component of global illumination
    vec3 ambient_component = bonus_material_ka * global_ambient_color;

    return ambient_component;
}

void main()
{
    N = normalize(world_normal);
    V = normalize(eye_position - world_position);

    vec2 center_offset = texture_coord - vec2(0.5);
    if(dot(center_offset, center_offset) > animationThreshold)
    {
        bonus_material_ka = material_ka;
        bonus_material_kd = material_kd;
        bonus_material_ks = material_ks;
    }
    else
    {
        bonus_material_ka = vec3(1) - material_ka;
        bonus_material_kd = vec3(1) - material_kd;
        bonus_material_ks = vec3(1) - material_ks;
    }

    vec3 illumination = ComputePointLightSourcesIllumination()
        + ComputeSpotLightSourcesIllumination ()
        + ComputeAmbientComponent();

    out_color = vec4 (illumination, 1);
}
