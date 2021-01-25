shader_type canvas_item;

uniform float blue = 0.2; // you can assign a default value to uniforms
uniform float red = 0.2;
uniform float green = 0.2;

void fragment() {
	COLOR = texture(TEXTURE, UV); //read from texture
    COLOR.b = blue;
	COLOR.r = red;
	COLOR.g = COLOR.g + green;
}

