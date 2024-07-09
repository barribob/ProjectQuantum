shader_type canvas_item;

uniform vec2 fragment_number = vec2(12, 12);
uniform float dissolve_state : hint_range(0.0, 1.0) = 1.0f;

void fragment() {
    vec2 pixel_fract = fract(UV * fragment_number);
    float pixel_dist = distance(pixel_fract, vec2(0.5, 0.5));
    COLOR = texture(TEXTURE, UV);
    COLOR.a *= step(pixel_dist, dissolve_state);
}
