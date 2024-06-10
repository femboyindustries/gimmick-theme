#version 120

#define PI 3.14159
#define FORWARD vec2(0.0, 1.0)

varying vec2 imageCoord;
varying vec4 color;

// 1 means a solid circle, 0.5 means there's a gap between the middle and the pie as large as the pie
uniform float width;
// 0.0 = nothing, 1.0 = full circle
uniform float fill;

void main() {
  // normalize uv [-1.0 - 1.0]
  vec2 uv = imageCoord * 2.0 - 1.0;
  vec2 normalized = normalize(uv);
  float uvDot = dot(normalized, FORWARD);
  float uvDot90 = dot(vec2(normalized.y, -normalized.x), FORWARD); // rotated 90deg
  // get the angle between this pixel and the slice
  float angle = acos(uvDot) / PI;
  // lefthand side
  float angle1 = (1.0 - angle) * 0.5;
  // righthand side
  float angle2 = angle * 0.5 + 0.5;
  // mix between the two based on which side of the spiral we're on
  // unsure if this is the best way to do this
  float spiral = mix(angle1, angle2, floor(uvDot90) + 1.0);
  float dist = length(uv);
  
  float bri = 1.0;
  if (dist > 1.0) bri = 0.0;
  if (dist < (1.0 - width)) bri = 0.0;
  if (spiral > fill) bri = 0.0;

  gl_FragColor = vec4(vec3(1.0), bri) * color;
}