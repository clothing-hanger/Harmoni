#pragma language glsl3

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 pixel = Texel(tex, texture_coords);
    vec4 px = pixel * color;
    if (
        (px.r == 1 && px.g == 0 && px.b == 0) ||
        (px.r == 1 && px.g == 1 && px.b == 1) ||
        (px.r == 0 && px.g == 0 && px.b == 0)
    ) {
        return px;
    }

    return vec4(0, 0, 0, 0);
}
