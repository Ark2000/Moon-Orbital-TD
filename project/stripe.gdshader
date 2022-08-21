shader_type canvas_item;
const float PI = 3.1415926535;
uniform float sz = 64.0;
uniform float angle = 0.7853;
uniform float speed = 0.1;
uniform vec4 color :hint_color = vec4(1.0, 0.0, 0.0, 0.5);

void fragment() {
	vec2 st=UV+vec2(TIME*speed,0);
	st=mat2(vec2(cos(angle),-sin(angle)),vec2(sin(angle),cos(angle)))*st;
	vec2 px=1.0/SCREEN_PIXEL_SIZE * st;
	float val=ceil(sin(PI*px.x/sz));
	vec4 col=color*val;
	COLOR=col;
}