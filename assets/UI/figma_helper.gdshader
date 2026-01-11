shader_type canvas_item;

uniform sampler2D bg_texture;
uniform vec4 base_color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 texture_color = texture(bg_texture, UV);
	COLOR = mix(base_color, texture_color, 0.5);
	COLOR.a = 1.0;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
