#pragma language glsl3

extern number time;
extern number amp = 14.0;
extern number speed = 1.1;
extern number stripes = 13;
extern number starRadius = 10.0;
extern vec2 resolution = vec2(1560, 1440);

vec2 waveOffset(vec2 p) {
    float nx = p.x / resolution.x;
    float w1 = sin((nx * 10.0 + time * speed) * 1.0);
    float w2 = sin((nx * 20.0 + time * speed * 1.5) * 1.4);
    float w3 = sin((nx * 6.0 - time * speed * 0.7) * 0.6);
    float total = (w1 * 0.6 + w2 * 0.3 + w3 * 0.1);
    return vec2(0.0, total*amp * (0.5 + 0.5 * sin((p.y/resolution.y)*6.2831)));
}

float roundbox(vec2 p, vec2 size, float r) {
    vec2 d = abs(p) - size + vec2(r);
    return length(max(d, vec2(0.0))) - r;
}

float starSDF(vec2 p, float spikes, float innerRadius, float outerRadius) {
    float r = length(p);
    float a = atan(p.x, p.y);
    float k = cos(spikes * a) * 0.5 + 0.5;
    float t = r / outerRadius;
    float shape = mix(innerRadius / outerRadius, 1.0, k);
    return t - shape;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec2 p = screen_coords;
    vec2 off = waveOffset(p);
    p += off;
    vec3 bg = vec3(0.02, 0.02, 0.02);
    float h = resolution.y;
    float w = resolution.x;
    float stripeH = h / stripes;
    float stripIndex = floor(p.y/stripeH);
    bool red = mod(stripIndex, 2.0) < 0.5;
    vec3 colRED = vec3(0.7, 0.06, 0.16);
    vec3 colWHITE = vec3(1.0, 1.0, 1.0);
    vec3 colBLUE = vec3(0.06, 0.16, 0.58);
    float cantonH = stripeH * 4.0;
    float cantonW = w * 0.45;
    vec3 col = bg;
    if (p.x <= cantonW && p.y <= cantonH) {
        float grad = smoothstep(0.0, cantonH, p.y) *0.12;
        col = colBLUE + grad;

        int rows = 9;
        int cols = 11;
        float padX = cantonW * 0.07;
        float padY = cantonH * 0.07;
        float areaW = cantonW - 2.0 * padX;
        float areaH = cantonH - 2.0 * padY;
        vec2 inner = vec2((screen_coords.x - padX) / areaW, (screen_coords.y - padY) / areaH);
        float fx = inner.x * float(cols);
        float fy = inner.y * float(rows);
        float cx = floor(fx);
        float cy = floor(fy);

        vec2 cellCenter = vec2(padX + (cx + 0.5) * (areaW / float(cols)),
                                padY + (cy + 0.5) * (areaH / float(rows)));
        float row = cy;
        bool star;
        if (int(row) % 2 == 0) {
            star = mod(cx, 2.0) < 0.5;
        } else {
            star = mod(cx, 2.0) >= 0.5;
        }

        if (star) {
            vec2 starP = screen_coords - cellCenter + waveOffset(cellCenter);
            float sr = starRadius;
            float sdf = starSDF(starP / sr, 5.0, 0.25, 1.0);
            float s = smoothstep(0.02, -0.02, sdf);
            float tw = 0.85 + 0.25 * sin(dot(cellCenter, vec2(12.9898, 78.233)) + time*3.0);
            col = mix(col, colWHITE * tw, s);
        }
    } else {
        if (red)
            col = colRED;
        else
            col = colWHITE;
        float fabric = 0.02 * sin((screen_coords.x + screen_coords.y) * 0.12 + time * 0.6);
        col += fabric;
    }

    vec4 pixel = Texel(tex, texture_coords) * color;
    float brightness = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
    vec3 flagMod = col * brightness;
    vec3 finalRGB = mix(pixel.rgb, flagMod, 0.30);

    return vec4(finalRGB, pixel.a);
}
