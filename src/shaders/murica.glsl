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

// math from https://www.desmos.com/calculator/hzieb2nx1s
float starSDF(vec2 p, vec2 center, float rOuter, float rotation) {
    vec2 pp = p - center;

    const float PI = 3.141592653589793;
    const float TAU = 6.283185307179586;
    const float INNER_RATIO = 0.3819660112501051;
    float rInner = rOuter * INNER_RATIO;

    vec2 verts[10];
    for (int i = 0; i < 10; ++i) {
        float ang = rotation + float(i) * (TAU / 10.0);
        float rad = (mod(float(i), 2.0) == 0.0) ? rOuter : rInner;
        verts[i] = vec2(cos(ang), sin(ang)) * rad;
    }

    float minDist = 1e20;
    for (int i = 0; i < 10; ++i) {
        vec2 a = verts[i];
        vec2 b = verts[(i + 1) % 10];
        vec2 ab = b - a;
        vec2 ap = pp - a;
        float t = dot(ap, ab) / dot(ab, ab);
        t = clamp(t, 0.0, 1.0);
        vec2 proj = a + ab * t;
        float d = length(pp - proj);
        minDist = min(minDist, d);
    }

    bool inside = false;
    for (int i = 0, j = 9; i < 10; j = i++) {
        vec2 vi = verts[i];
        vec2 vj = verts[j];
        bool intersect = ((vi.y > pp.y) != (vj.y > pp.y)) &&
                         (pp.x < (vj.x - vi.x) * (pp.y - vi.y) / (vj.y - vi.y + 1e-12) + vi.x);
        if (intersect) inside = !inside;
    }

    return inside ? -minDist : minDist;
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
        vec2 inner = vec2((p.x - padX) / areaW, (p.y - padY) / areaH);
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
            const float PI = 3.141592653589793;
            vec2 starP = p - cellCenter + waveOffset(cellCenter);
            float sdf = starSDF(starP, vec2(0.0), starRadius, -PI/2.0);
            float s = smoothstep(0.02, -0.02, sdf);
            float tw = 0.85 + 0.25 * sin(dot(cellCenter, vec2(12.9898, 78.233)) + time*3.0);
            col = mix(col, colWHITE * tw, s);
        }
    } else {
        if (red)
            col = colRED;
        else
            col = colWHITE;
        float fabric = 0.02 * sin((p.x + p.y) * 0.12 + time * 0.6);
        col += fabric;
    }

    vec4 pixel = Texel(tex, texture_coords) * color;
    float brightness = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
    vec3 flagMod = col * brightness;
    vec3 finalRGB = mix(pixel.rgb, flagMod, 0.30);

    return vec4(finalRGB, pixel.a);
}
