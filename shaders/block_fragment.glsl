#version 120

uniform sampler2D sampler;
uniform sampler2D sky_sampler;
uniform float timer;
uniform float daylight;

varying vec2 fragment_uv;
varying float fragment_ao;
varying float fog_factor;
varying float fog_height;
varying float diffuse;

const float pi = 3.14159265;

void main() {
    vec3 color = vec3(texture2D(sampler, fragment_uv));
    if (color == vec3(1.0, 0.0, 1.0)) {
        discard;
    }
    bool cloud = color == vec3(1.0, 1.0, 1.0);
    vec3 light_color = vec3(daylight * 0.6 - fragment_ao * 0.2);
    vec3 ambient = vec3(daylight * 0.2 + 0.2 - fragment_ao * 0.1);
    vec3 light = ambient + light_color * (cloud ? 1.0 - diffuse : diffuse);
    color = min(color * light, vec3(1.0));
    vec3 sky_color = vec3(texture2D(sky_sampler, vec2(timer, fog_height)));
    color = mix(color, sky_color, fog_factor);
    gl_FragColor = vec4(color, 1.0);
}
