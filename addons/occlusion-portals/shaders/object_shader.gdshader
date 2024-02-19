shader_type spatial;

#include "portal_functions.gdshaderinc"

void fragment() {
	vec3 PixelWS = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	ALPHA = float(PortalOcclusion(PixelWS, CAMERA_POSITION_WORLD));
}