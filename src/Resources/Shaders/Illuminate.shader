shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV); //read from texture
    COLOR.b = COLOR.b + 0.2;
	COLOR.r = COLOR.r + 0.2;
	COLOR.g = COLOR.g + 0.2;
}

