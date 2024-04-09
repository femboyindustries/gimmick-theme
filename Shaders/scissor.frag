#version 120

varying vec2 textureCoord;
uniform sampler2D sampler0;
uniform vec2 res;
varying vec4 color;

uniform float top = 0.0;
uniform float left = 0.0;
uniform float bottom = 0.0;
uniform float right = 0.0;

void main() {
  vec2 uv = gl_FragCoord.xy / res;

  if (
    uv.y         < bottom ||
    uv.x         < left   ||
    (1.0 - uv.y) < top    ||
    (1.0 - uv.x) < right
  )
    discard;

  gl_FragColor = texture2D(sampler0, textureCoord) * color;
  //gl_FragColor = vec4(vec3(0.0, 0.0, 0.0), texture2D(sampler0, textureCoord).a);
}