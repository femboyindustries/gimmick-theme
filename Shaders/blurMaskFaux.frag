#version 120

varying vec2 textureCoord;
uniform sampler2D sampler0;
uniform sampler2D samplerBack;

void main() {
	vec3 mask = texture2D(sampler0, textureCoord).rgb;
  vec4 back = texture2D(samplerBack, textureCoord);
  float bri = mask.g;
  gl_FragColor = vec4(mix(back.rgb, vec3(bri), clamp(mask.r * 0.75 + (mask.b - 0.5), 0.0, 1.0)), 1.0);
}