shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_lambert, specular_schlick_ggx;

uniform float Radius = 0.0010000000475;
uniform bool Apply_X = true;
uniform bool Apply_Z = true;



void vertex() {
// Input:2
	vec3 n_out2p0 = VERTEX;


// FloatParameter:20
	float n_out20p0 = Radius;


// Input:3
	vec3 n_out3p0 = CAMERA_POSITION_WORLD;


// VectorDecompose:7
	float n_out7p0 = n_out3p0.x;
	float n_out7p1 = n_out3p0.y;
	float n_out7p2 = n_out3p0.z;


// VectorDecompose:9
	float n_out9p0 = n_out2p0.x;
	float n_out9p1 = n_out2p0.y;
	float n_out9p2 = n_out2p0.z;


// VectorCompose:8
	vec3 n_out8p0 = vec3(n_out7p0, n_out9p1, n_out7p2);


// VectorOp:4
	vec3 n_out4p0 = n_out2p0 - n_out8p0;


// VectorDecompose:18
	float n_out18p0 = n_out4p0.x;
	float n_out18p1 = n_out4p0.y;
	float n_out18p2 = n_out4p0.z;


// FloatFunc:17
	float n_out17p0 = abs(n_out18p0);


// FloatOp:11
	float n_in11p1 = 2.00000;
	float n_out11p0 = pow(n_out17p0, n_in11p1);


// FloatOp:12
	float n_out12p0 = n_out20p0 * n_out11p0;


// BooleanParameter:22
	bool n_out22p0 = Apply_Z;


// FloatOp:24
	float n_out24p0 = n_out12p0 * (n_out22p0 ? 1.0 : 0.0);


// FloatFunc:19
	float n_out19p0 = abs(n_out18p2);


// FloatOp:10
	float n_in10p1 = 2.00000;
	float n_out10p0 = pow(n_out19p0, n_in10p1);


// FloatOp:13
	float n_out13p0 = n_out20p0 * n_out10p0;


// BooleanParameter:21
	bool n_out21p0 = Apply_X;


// FloatOp:23
	float n_out23p0 = n_out13p0 * (n_out21p0 ? 1.0 : 0.0);


// FloatOp:14
	float n_out14p0 = n_out24p0 + n_out23p0;


// VectorCompose:15
	float n_in15p0 = 0.00000;
	float n_in15p2 = 0.00000;
	vec3 n_out15p0 = vec3(n_in15p0, n_out14p0, n_in15p2);


// VectorOp:6
	vec3 n_out6p0 = n_out2p0 - n_out15p0;


// Output:0
	VERTEX = n_out6p0;


}
