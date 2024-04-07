#version 120

uniform float radius;
uniform float strength;
uniform vec2 imageSize;
uniform vec2 textureSize;
varying vec2 imageCoord;
varying vec2 textureCoord;
uniform sampler2D sampler0;
uniform sampler2D samplerMask;

vec2 img2tex(vec2 v) {
	return clamp(v, 0.0, 1.0) / textureSize * imageSize;
}

float gray( vec3 c ) {
  return (min(c.r, min(c.g, c.b)) + max(c.r, max(c.g, c.b))) * 0.5;
}

float SCurve (float x) {
	x = x * 2.0 - 1.0;
	return -x * abs(x) * 0.5 + x + 0.5;
}

vec4 BlurV (sampler2D source, vec2 size, vec2 uv, float radius) {
	if (radius >= 1.0) {
		vec4 A = vec4(0.0);
		vec4 C = vec4(0.0);

		float height = 1.0 / size.y;

		float divisor = 0.0;
    float weight = 0.0;

    float radiusMultiplier = 1.0 / radius;

    for (float y = -25.0; y <= 25.0; y++) {
			A = texture2D(source, img2tex(uv + vec2(0.0, y * height)));
      float lumi = gray(A.rgb);
            	
      weight = SCurve(1.0 - (abs(y) * radiusMultiplier));
            
      C += A * weight * smoothstep(0.1, 0.2, lumi);
            
			divisor += weight;
		}

		return vec4(C.r / divisor, C.g / divisor, C.b / divisor, 1.0);
	}

	return texture2D(source, img2tex(uv));
}

void main() {
  float mult = texture2D(samplerMask, textureCoord).r;
  float amt = strength * mult;
  vec4 col = BlurV(sampler0, imageSize, imageCoord, radius * amt);
	gl_FragColor = col;
}