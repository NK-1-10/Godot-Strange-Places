shader_type canvas_item;

void fragment() {
    vec2 shifted_uv = UV;
    shifted_uv.x += TIME * 0.1; // 0.1 ir ātrums, vari to mainīt
    
	