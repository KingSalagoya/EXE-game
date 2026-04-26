shader_type spatial;

uniform vec4 water_color: source_color;
uniform sampler2D normal_tex;
uniform sampler2D color_tex;
uniform vec2 normal_speed = vec2(-0.03, 0.02);

uniform sampler2D noise_img;      
uniform float wave_height = 0.5;
uniform float wave_speed = 0.8;

void fragment() {
	vec2 normal_uv = UV + (normal_speed/10.0f * TIME);
	vec3 normal_map = texture(normal_tex, normal_uv).rgb;

	vec2 color_uv = UV + (normal_speed/4.0f * TIME);
	vec3 color_map = texture(color_tex, color_uv).rgb;
    
	ALBEDO = color_map.rgb;
	NORMAL_MAP = normal_map;
    
	ROUGHNESS = 0.1;
	METALLIC = 0.0;
}

void vertex() {
	vec2 moving_uv = UV + (TIME * wave_speed * 0.05);
	float height = texture(noise_img, moving_uv).r;

	VERTEX.y += (height - 0.5) * wave_height;
}