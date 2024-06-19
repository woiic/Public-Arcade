shader_type canvas_item;


void fragment() {
	//NODE_POSITION_WORLD.x
	//float uv = UV.x;  ><
	
		//COLOR = vec4(0.0 ,0.0,100.0 * UV.x / 100.0,1.0);
	if(SCREEN_UV.x < 0.33){
		COLOR = texture(TEXTURE, UV);
	}
	else if(SCREEN_UV.x < 0.66){
		float variable = (SCREEN_UV.x*2.0) - 0.33;
		vec4 rojo = vec4(1.0 - variable, 0.0, 0.0, 1.0);
		vec4 azul = vec4(0.0, 0.0, variable*1.1, 1.0);
		COLOR = (azul + rojo) * texture(TEXTURE, UV);
	}
	else{
		COLOR = texture(TEXTURE, UV);
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
