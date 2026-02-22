shader_type sky;

uniform vec3 top_color : source_color = vec3(1.0);
uniform vec3 bottom_color : source_color = vec3(1.0);
uniform sampler2D gradient_curve : repeat_disable, filter_linear;
uniform sampler2D noise_texture : source_color;





void sky() {
	vec3 color_gradient = mix(top_color.rgb, bottom_color.rgb, texture(gradient_curve, vec2(SKY_COORDS.y, 0.0)).x);

	float stars_mask = 1.0-smoothstep(0.36, 0.52, SKY_COORDS.y);
	float stars = texture(noise_texture, SKY_COORDS).r;
	stars = smoothstep(stars, 1.0, 0.6);
	stars *= stars_mask;
	stars *= 20.0;
	COLOR = color_gradient + vec3(stars);
}
