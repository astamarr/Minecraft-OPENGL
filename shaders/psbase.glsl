varying vec3 normal;
varying vec3 vertex_to_light_vector;
varying vec4 color;
varying float Watercolor;
varying vec4 WorldPosition;
varying bool water;
uniform float ambientLevel;
uniform float elapsed;

float PositionVague(vec4 VertexPosition)
{
	return sin( VertexPosition.x + elapsed*3);//+cos( VertexPosition.y + elapsed*2);	
}





void main()
{
	if(water){
		normal.x = PositionVague(WorldPosition - vec4(0, 0, 0.1, 0)) -
					PositionVague(WorldPosition + vec4(0, 0, 0.1, 0));
		normal.y = PositionVague(WorldPosition - vec4(0, 0.1, 0, 0)) -
					PositionVague(WorldPosition + vec4(0, 0.1, 0, 0));
	}
	//normal.y = 0;
	//normal.z = 1;();




	// Scaling The Input Vector To Length 1	
	vec3 normalized_normal = normalize(normal);
	vec3 normalized_vertex_to_light_vector = normalize(vertex_to_light_vector);

	// Calculating The Diffuse Term And Clamping It To [0;1]
	float DiffuseTerm = clamp(dot(normalized_normal, normalized_vertex_to_light_vector), 0.0, 1.0);



	// Calculating The Final Color
	gl_FragColor = color * (DiffuseTerm*(1-ambientLevel) + ambientLevel);
	gl_FragColor.a = color.a;
}