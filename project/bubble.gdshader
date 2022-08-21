shader_type canvas_item;

void fragment() {
	float d=length(UV-vec2(.5));
	float a=smoothstep(.3, .4, d)-smoothstep(.4,.42,d);
	COLOR=vec4(vec3(1.),a);
}