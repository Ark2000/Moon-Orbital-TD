//Use as you will.
shader_type canvas_item;

const vec2 WaveCentre = vec2(0.5, 0.5);
uniform vec3 WaveParams = vec3(10.0, 0.8, 0.1 ); 
uniform float t =0.0;

void fragment()
{
	float iTime = t;
	vec2 uv = UV * 2.0 - vec2(.5);
	
    //Sawtooth function to pulse from centre.
    float offset = (iTime- floor(iTime))/iTime;
	float CurrentTime = (iTime)*(offset);    
   
	vec2 texCoord = SCREEN_UV;
	float Dist = distance(uv, WaveCentre);
	
	vec4 Color = texture(SCREEN_TEXTURE, texCoord);
    
//Only distort the pixels within the parameter distance from the centre
if ((Dist <= ((CurrentTime) + (WaveParams.z))) && 
	(Dist >= ((CurrentTime) - (WaveParams.z)))) 
	{
        //The pixel offset distance based on the input parameters
		float Diff = (Dist - CurrentTime); 
		float ScaleDiff = (1.0 - pow(abs(Diff * WaveParams.x), WaveParams.y)); 
		float DiffTime = (Diff  * ScaleDiff);
        
        //The direction of the distortion
		vec2 DiffTexCoord = normalize(texCoord - WaveCentre);         
        
        //Perform the distortion and reduce the effect over time
		texCoord += ((DiffTexCoord * DiffTime) / (CurrentTime * Dist * 40.0));
		Color = texture(SCREEN_TEXTURE, texCoord);
        
        //Blow out the color and reduce the effect over time
		Color += (Color * ScaleDiff) / (CurrentTime * Dist * 40.0);
	} 
    
	COLOR = Color; 
}