uniform sampler2D Texture0;
uniform sampler2D Texture1;
uniform float screen_width;
uniform float screen_height;

float stepx = 1/screen_width;
float stepy = 1/screen_height;


float LinearizeDepth(float z)
{
	float n = 0.5; // camera z near
  	float f = 10000.0; // camera z far
  	return (2.0 * n) / (f + n - z * (f - n));
}


// 
void oil(float radius){
	vec2 src_size = vec2(screen_width, screen_height);
    vec2 uv = gl_TexCoord[0].xy;
    float n = float((radius + 1) * (radius + 1));

    vec3 m[4];
    vec3 s[4];
    for (int k = 0; k < 4; ++k) {
        m[k] = vec3(0.0);
        s[k] = vec3(0.0);
    }

    for (int j = -radius; j <= 0; ++j)  {
        for (int i = -radius; i <= 0; ++i)  {
            vec3 c = texture2D(Texture0, uv + vec2(i,j) / src_size).rgb;
            m[0] += c;
            s[0] += c * c;
        }
    }

    for (int j = -radius; j <= 0; ++j)  {
        for (int i = 0; i <= radius; ++i)  {
            vec3 c = texture2D(Texture0, uv + vec2(i,j) / src_size).rgb;
            m[1] += c;
            s[1] += c * c;
        }
    }

    for (int j = 0; j <= radius; ++j)  {
        for (int i = 0; i <= radius; ++i)  {
            vec3 c = texture2D(Texture0, uv + vec2(i,j) / src_size).rgb;
            m[2] += c;
            s[2] += c * c;
        }
    }

    for (int j = 0; j <= radius; ++j)  {
        for (int i = -radius; i <= 0; ++i)  {
            vec3 c = texture2D(Texture0, uv + vec2(i,j) / src_size).rgb;
            m[3] += c;
            s[3] += c * c;
        }
    }


    float min_sigma2 = 1e+2;
    for (int k = 0; k < 4; ++k) {
        m[k] /= n;
        s[k] = abs(s[k] / n - m[k] * m[k]);

        float sigma2 = s[k].r + s[k].g + s[k].b;
        if (sigma2 < min_sigma2) {
            min_sigma2 = sigma2;
            gl_FragColor = vec4(m[k], 1.0);
        }
    }
}

void main (void)
{

	vec2 pos = gl_TexCoord[0];
	bool outline = false;

	// On check si le pixel est a la ligne d'horizon
	for(int i=0;i<3;i++){
		for(int j=0;j<3;j++){
			 if(LinearizeDepth(texture2D( Texture1, vec2(gl_TexCoord[0])+vec2(i*stepx,j*stepy)).r) - LinearizeDepth(texture2D( Texture1, vec2(gl_TexCoord[0])).r) > 0.3)
			 {
				 outline = true;
			 }

		}
	}


	// on bloom l'image, intensité en fonction de la distance.
	vec4 bloom;
	if ( LinearizeDepth(texture2D( Texture1, vec2(gl_TexCoord[0])).r) > 0.6)
	{

	for(int i=0;i<5;i++){
		for(int j=0;j<5;j++){ 
			 
				 bloom += texture2D( Texture0, vec2(gl_TexCoord[0])+vec2(i*stepx,j*stepy));
			 

		}
	}
	bloom = bloom / 25;
	} else 
	{
	for(int i=0;i<2;i++){
		for(int j=0;j<2;j++){
			 
			 
				 bloom += texture2D( Texture0, vec2(gl_TexCoord[0])+vec2(i*stepx,j*stepy));
			 

			 }
		}
		bloom = bloom / 4;

	}

	






	vec4 color = texture2D( Texture0 , vec2( gl_TexCoord[0] ) );

	// On applique l'outline si le pixel est a la ligne d'horizon
	if(outline)
	{
		bloom = vec4( 60.0/255.0 , 60.0/255.0 , 230.0/255.0 ,1.0);
	}

	
	gl_FragColor = bloom;
		if(texture2D(Texture0, vec2( gl_TexCoord[0])).b >0.5f && texture2D(Texture0, vec2( gl_TexCoord[0])).r <0.5f)
		{
			oil(5);
		}
	
}