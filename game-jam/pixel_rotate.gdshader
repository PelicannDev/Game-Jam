shader_type canvas_item;
uniform float angle;

void fragment() {
    // Get centered UV coordinates
    vec2 uv = UV - vec2(0.5);
    
    // Create rotation matrix using proper vector syntax
    mat2 rot = mat2(
        vec2(cos(angle), -sin(angle)),
        vec2(sin(angle), cos(angle))
    );
    
    // Apply rotation and recenter
    uv = rot * uv;
    uv += vec2(0.5);
    
    // Sample texture with rotation
    COLOR = texture(TEXTURE, uv);
}
