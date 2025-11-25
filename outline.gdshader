shader_type spatial;
render_mode unshaded, cull_front; // Cull front faces, only backfaces rendered

uniform vec4 outline_color : source_color = vec4(0.1, 1.0, 0.1, 1.0);
uniform float outline_thickness : hint_range(0.0, 0.1) = 0.03;

void vertex() {
    VERTEX += NORMAL * outline_thickness;
}

void fragment() {
    ALBEDO = outline_color.rgb;
    ALPHA = outline_color.a;
}