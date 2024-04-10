#version 120

varying vec2 textureCoord;
uniform sampler2D sampler0;
varying vec4 color;

uniform float thres;
uniform float fuzz;

void main() {
  vec4 tex = texture2D(sampler0, textureCoord);
  float alpha = smoothstep(thres - fuzz * 0.5, thres + fuzz * 0.5, tex.r);
  gl_FragColor = vec4(color.rgb, color.a * alpha);
}