varying vec3 normal;
varying vec3 vertex_to_light_vector;
varying vec4 color;
varying float Watercolor;
varying vec4 WorldPosition;
varying bool water;


uniform float elapsed;
uniform mat4 View;
uniform mat4 InvertView;


float PositionVague(vec4 VertexPosition)
{
	return sin( VertexPosition.x + elapsed*3);//+cos( VertexPosition.y + elapsed*2);	
}

void main()
{
	gl_Position = gl_ModelViewMatrix * gl_Vertex;

	//position dans le monde
	gl_Position = InvertView * gl_Position;
	
	vec3 norm = gl_Normal;

	WorldPosition = gl_Position;
	water = false;
	if (gl_Color.b > 0.0f && gl_Color.r == 0.0f )
	{
		water = true;
		Watercolor = PositionVague(gl_Position) * 2;
		gl_Position.z += Watercolor; 
		norm.x = PositionVague(gl_Position+vec4(-0.1,0,0,0))-PositionVague(gl_Position+vec4(0.1,0,0,0));
		norm.y = PositionVague(gl_Position+vec4(0,-0.1,0,0))-PositionVague(gl_Position+vec4(0,0.1,0,0));
		norm.x *=1;
		norm.y *=1;
		//gl_Color = gl_Color + Watercolor;



	}
	
// on repasse en modèle view
gl_Position = View * gl_Position;
gl_Position = gl_ProjectionMatrix * gl_Position;
	// Transforming The Vertex


	// Transforming The Normal To ModelView-Space
	normal = norm;//gl_Normal; 

	//Direction lumiere
	vertex_to_light_vector = vec3(InvertView*gl_LightSource[0].position);
	
	//Couleur
	color = gl_Color ;
}