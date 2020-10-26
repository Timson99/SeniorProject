shader_type canvas_item;
//render_mode skip_vertex_transform;

varying vec2 texture_coord;


uniform float texelPerPixel = 4.5;

void vertex() {
  //VERTEX = (EXTRA_MATRIX * (WORLD_MATRIX * vec4(VERTEX, 0.0, 1.0))).xy;
  //VERTEX = (PROJECTION_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
  texture_coord = UV * vec2(pow(TEXTURE_PIXEL_SIZE.x, -1), pow(TEXTURE_PIXEL_SIZE.y, -1));
}

void fragment() {
	vec2 locationWithinTexel = fract(texture_coord);
	vec2 interpolationAmount = clamp(locationWithinTexel/texelPerPixel ,0.0, 0.5) 
		+ clamp((vec2(locationWithinTexel.x - 1.0, locationWithinTexel.y - 1.0)) / texelPerPixel + 0.5, 0.0, 0.5);
	vec2 finalTextureCoords = ( floor(texture_coord) + interpolationAmount ) / vec2(pow(TEXTURE_PIXEL_SIZE.x, -1), pow(TEXTURE_PIXEL_SIZE.y, -1));
	COLOR = texture(TEXTURE, finalTextureCoords) * COLOR;
	COLOR.b = 1.0;
}

