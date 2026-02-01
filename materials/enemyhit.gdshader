shader_type spatial;
// Remove 'depth_draw_opaque' - it causes transparency issues on sprites!
render_mode unshaded, cull_disabled, blend_mix; 

// The name MUST be 'texture_albedo' for AnimatedSprite3D to find it automatically
uniform sampler2D texture_albedo : source_color, filter_nearest;

uniform vec4 flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float flash_modifier : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 pixel_color = texture(texture_albedo, UV);
    
    // Apply the flash
    vec3 final_color = mix(pixel_color.rgb, flash_color.rgb, flash_modifier);
    
    // Apply the sprite's modulation (Vertex Color) so you can still tint it in the Inspector
    ALBEDO = final_color * COLOR.rgb;
    
    // CRITICAL: Set Alpha so the background disappears
    ALPHA = pixel_color.a * COLOR.a;
    
    // Optional: hard cut for pixel art (prevents ghostly edges)
    ALPHA_SCISSOR_THRESHOLD = 0.5;
}