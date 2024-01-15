shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_front : source_color,filter_nearest,repeat_enable;
uniform sampler2D texture_face : source_color,filter_nearest,repeat_enable;
uniform sampler2D texture_background : source_color,filter_linear,repeat_enable;
uniform vec2 cell;
uniform vec2 ratio;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	vec2 c1 = vec2(0, 00);
	vec2 c2 = vec2(1./3., 0);
	vec2 c3 = vec2(2./3., 0);
	
	vec4 albedo_tex;
	
	if (UV.x < c2.x && UV.y < 0.5) {
		base_uv = base_uv * vec2(3, 2) + vec2(0.0, 0.0);
		albedo_tex = texture(texture_front, base_uv);
	} else if (UV.x < 1. && UV.x > c3.x && UV.y < 0.5) {
		vec2 local_cell = cell;
		local_cell.x = 7. - local_cell.x;
		base_uv = -((base_uv + -c3) * vec2(3, 2) + local_cell) / vec2(8, 8);
		base_uv = base_uv * ratio - (vec2(1, 1) - ratio) / 2.;
		albedo_tex = texture(texture_background, base_uv);
	}
	else {
		base_uv = base_uv * vec2(3, 2) + vec2(0.0, 0.0);
		albedo_tex = texture(texture_face, base_uv);
	}
	ALBEDO = albedo.rgb * albedo_tex.rgb;
}
