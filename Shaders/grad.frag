#version 120

varying vec2 textureCoord;
uniform sampler2D sampler0;
uniform vec2 res;
varying vec4 color;

uniform float top = 0.0;
uniform float left = 0.0;
uniform float bottom = 0.0;
uniform float right = 0.0;

uniform float vert = 0.0;

uniform float a = 1.0;

uniform vec4 col1;
uniform vec4 col2;

void main() {
  vec2 uv = gl_FragCoord.xy / res;

  vec4 col = mix(col1, col2, mix(smoothstep(left, right, uv.x), smoothstep(top, bottom, 1.0 - uv.y), vert));
  //vec4 col = vec4(vec3(smoothstep(top, bottom, 1.0 - uv.y)), 1.0);

  gl_FragColor = mix(vec4(1.0), col, color.a * a) * texture2D(sampler0, textureCoord) * vec4(color.rgb, 1.0);
}