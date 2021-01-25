shader_type canvas_item;
uniform vec4 blue_tint : hint_color;
uniform vec2 sprite_scale;
uniform float scale_x=0.67;
uniform float alpha = 0.5;
float rand(vec2 coord){
	return fract(sin(dot(coord,vec2(11.515301,5.156161)))* 42098.30819038);
}

float noise (vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	
	float a = rand(i);
	float b = rand(i + vec2(1.0,0.0));
	float c = rand(i + vec2(0.0,1.0));
	float d = rand(i + vec2(1.0,1.0));
	vec2 cubic = f* f*(3.0-2.0*f);
	
//	return mix(a,b,cubic.x) + (c-a)*cubic.y *(1.0 - cubic.x) +(d-b)*cubic.x *cubic.y;
	return mix(a,b,cubic.x) + (c-a)+cubic.y *(1.0 - cubic.x) +(d-b)*cubic.x *cubic.y;
}
void fragment(){
	
	vec2 noisecoord1 = UV*sprite_scale*scale_x;
	vec2 noisecoord2 = UV* sprite_scale*scale_x+ 4.0;
//
//	vec2 noisecoord1 = UV*4.0;
//	vec2 noisecoord2 = UV*4.0+ 4.0;
	
	vec2 motion1 =vec2(TIME*-0.3,TIME* 0.4);
	vec2 motion2= vec2(TIME*0.1,TIME*0.5);
	
	vec2 distort1 = vec2(noise(noisecoord1+motion1),noise(noisecoord2+motion1))-vec2(0.5);
	vec2 distort2 = vec2(noise(noisecoord1+motion2),noise(noisecoord2+motion2))-vec2(0.5);
	
	vec2 distort_sum = (distort1 + distort2)/20.0;
	
	vec4 color = textureLod(SCREEN_TEXTURE,SCREEN_UV+distort_sum,0.0);
	color = mix(color, blue_tint,0.3);
//	color.rgb = mix(color.rgb,vec3(0.5),1.4);
	color.rgb = mix(vec3(0.5),color.rgb,1.4);
	color.a = alpha;
	COLOR= color;
}