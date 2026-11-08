//
//  Orb.metal
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: Noise

static float hash(float3 p) {
    p = fract(p * 0.3183099 + 0.1);
    p *= 17.0;
    return fract(p.x * p.y * p.z * (p.x + p.y + p.z));
}

/// Smooth value noise in 3D, 0…1.
static float noise(float3 x) {
    float3 i = floor(x);
    float3 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(mix(hash(i + float3(0, 0, 0)), hash(i + float3(1, 0, 0)), f.x),
                   mix(hash(i + float3(0, 1, 0)), hash(i + float3(1, 1, 0)), f.x), f.y),
               mix(mix(hash(i + float3(0, 0, 1)), hash(i + float3(1, 0, 1)), f.x),
                   mix(hash(i + float3(0, 1, 1)), hash(i + float3(1, 1, 1)), f.x), f.y), f.z);
}

/// Four octaves of noise: soft, cloudy detail.
static float fbm(float3 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        value += amplitude * noise(p);
        p = p * 2.02 + float3(1.7, 9.2, 3.1);
        amplitude *= 0.5;
    }
    return value;
}

/// Two octaves: smooth, broad shapes.
static float smoothNoise(float3 p) {
    return noise(p) * 0.65 + noise(p * 2.03 + float3(5.2, 1.3, 7.7)) * 0.35;
}

static float3 rotateY(float3 p, float angle) {
    float c = cos(angle), s = sin(angle);
    return float3(c * p.x + s * p.z, p.y, -s * p.x + c * p.z);
}

// MARK: Orb

/// A glowing sphere with colour flowing inside, lit from the top left.
///
/// - size: the view's size in points.
/// - time: seconds, already multiplied by the speed.
/// - energy: 0 calm … 1 excited (brighter, busier colour).
/// - deep, mid, light: the palette, darkest to brightest.
/// - rim: the colour of the light wrapping around the edge.
[[ stitchable ]] half4 orb(float2 position, half4 color, float2 size, float time, float energy,
                          half4 deep, half4 mid, half4 light, half4 rim) {
    float radius = min(size.x, size.y) * 0.5;
    float2 uv = (position - size * 0.5) / radius;   // -1…1, y points down
    float r = length(uv);
    if (r > 1.0) { return half4(0); }

    // The sphere's surface normal (z towards the viewer).
    float z = sqrt(max(0.0, 1.0 - r * r));
    float3 n = float3(uv.x, -uv.y, z);

    // Colour flowing inside: silky ribbons from domain-warped noise, seen through
    // a lens (pulled towards the centre), so they look deep rather than painted on.
    float3 inside = rotateY(float3(uv / (z + 0.8), z * 0.6), time * 0.3);
    float3 p = inside * (1.0 + energy * 0.35) + float3(0.0, time * 0.12, time * 0.08);
    float warp = smoothNoise(p * 0.7 + float3(time * 0.15));
    float flow = smoothNoise(p + warp * (1.8 + energy * 0.9));
    float ribbons = 0.5 + 0.5 * sin(flow * 7.0 + time * 0.6);

    float3 base = mix(float3(deep.rgb), float3(mid.rgb), ribbons);
    base = mix(base, float3(light.rgb), pow(ribbons, 4.0) * (0.35 + energy * 0.25));

    // Lit from inside: brightest in the middle, deeper towards the edge.
    float3 col = base * (0.55 + 0.6 * pow(z, 0.8));
    // A warm core glow.
    col += float3(light.rgb) * pow(z, 4.0) * (0.12 + energy * 0.12);

    // Glass: light wrapping around the edge (fresnel), strongest at the bottom right…
    float fresnel = pow(1.0 - z, 3.0);
    float rimSide = 0.5 + 0.5 * saturate(dot(normalize(n.xy + 0.0001), normalize(float2(0.6, -0.8))));
    col += float3(rim.rgb) * fresnel * (0.6 + rimSide * 0.9) * (1.0 + energy * 0.3);

    // …and a soft window reflection at the top left, with a small bright point.
    float3 lightDir = normalize(float3(-0.5, 0.65, 0.6));
    float3 halfway = normalize(lightDir + float3(0, 0, 1));
    float facing = max(dot(n, halfway), 0.0);
    col += pow(facing, 12.0) * 0.16 + pow(facing, 300.0) * 0.7;

    // A soft tone curve, so bright moments glow instead of clipping to white.
    // Scales the whole colour down above 1, which keeps its saturation.
    col /= max(1.0, max(col.r, max(col.g, col.b)) * 0.9 + 0.1);

    // Smooth edge, one point wide.
    float edge = 1.0 - smoothstep(1.0 - 1.5 / radius, 1.0, r);
    return half4(half3(col) * edge, edge);
}

// MARK: Ribbon ring

/// One translucent ribbon around the ring: its outer edge hugs the circle, its
/// inner edge swings in and out three times, like a band twisting in light.
/// Returns its brightness at radius `r` and angle `a`.
static float ribbon(float r, float a, float outer, float phase, float energy, float pixel) {
    float swing = 0.5 + 0.5 * sin(3.0 * a + phase);
    float width = mix(0.04, 0.27 + energy * 0.05, swing);
    float inner = outer - width;
    if (r < inner - 0.08 || r > outer + 0.08) { return 0.0; }

    float soft = pixel * 1.5;
    float inside = smoothstep(inner - soft, inner + soft, r) * (1.0 - smoothstep(outer - soft, outer + soft, r));
    // Brighter towards the outer edge, like light through a curved band.
    float t = saturate((r - inner) / max(width, 0.001));
    float fill = inside * (0.3 + 0.45 * t);
    // Thin bright lines along both edges: the folds.
    float innerLine = exp(-pow((r - inner) / (pixel * 2.5 + 0.006), 2.0)) * (0.25 + 0.35 * (1.0 - swing));
    float outerLine = exp(-pow((r - outer) / (pixel * 2.5 + 0.01), 2.0)) * 0.45;
    return fill + innerLine + outerLine;
}

/// A glowing golden ring of twisting ribbons.
///
/// - size: the view's size in points.
/// - time: seconds, already multiplied by the speed.
/// - energy: 0 calm … 1 excited (wider ribbons, brighter).
/// - deep, mid, light, rim: the palette (rim colours the glow).
[[ stitchable ]] half4 ribbonOrb(float2 position, half4 color, float2 size, float time, float energy,
                                half4 deep, half4 mid, half4 light, half4 rim) {
    float radius = min(size.x, size.y) * 0.5;
    float2 uv = (position - size * 0.5) / radius;   // -1…1
    float r = length(uv);
    float a = atan2(uv.y, uv.x) + time * 0.25;
    float pixel = 1.0 / radius;
    float outer = 0.74;

    // Two ribbons, out of step, drifting against each other.
    float bright = 0.0;
    bright += ribbon(r, a, outer, time * 0.5, energy, pixel);
    bright += ribbon(r, a, outer - 0.01, 2.4 - time * 0.35, energy, pixel) * 0.8;
    bright *= 1.0 + energy * 0.4;

    // Inside the opening: a smaller, fainter ring turned against the outer one…
    float scale = 0.68;
    float innerRing = ribbon(r / scale, -a + 1.1, outer, 0.9 - time * 0.3, energy, pixel / scale)
                    + ribbon(r / scale, -a + 1.1, outer - 0.01, 3.3 + time * 0.2, energy, pixel / scale) * 0.8;
    bright += innerRing * 0.42;

    // …fine curved filaments spiralling into the centre, like an iris…
    float spiral = 9.0 * a + 6.5 * log(r + 0.04);
    float filaments = pow(1.0 - abs(sin(spiral)), 22.0)
                    + pow(1.0 - abs(sin(-9.0 * a + 6.5 * log(r + 0.04) + 0.8)), 22.0) * 0.6;
    float core = smoothstep(0.46, 0.1, r) * smoothstep(0.02, 0.12, r);
    bright += filaments * core * 0.7;

    // …a warm haze in the middle…
    bright += exp(-r * r * 9.0) * 0.26;

    // …and a few tiny sparkles.
    float2 cell = floor(uv * 14.0);
    float2 local = fract(uv * 14.0) - 0.5;
    float seed = hash(float3(cell, 4.2));
    float sparkle = step(0.86, seed) * exp(-dot(local, local) / (0.004 + pixel * pixel * 40.0));
    bright += sparkle * smoothstep(0.62, 0.2, r) * 0.6;

    // Glow: around the outside of the ring, and faintly inside it.
    float glowOut = exp(-max(r - outer, 0.0) * 13.0) * step(outer, r) * smoothstep(1.0, 0.85, r);
    float glowIn = exp(-max(outer - r, 0.0) * 7.0) * (1.0 - step(outer, r)) * 0.35;
    float glow = (glowOut + glowIn) * (0.45 + energy * 0.35);

    // Colour by brightness: deep amber where faint, honey to near-white where bright.
    float3 col = mix(float3(deep.rgb), float3(mid.rgb), saturate(bright * 1.4));
    col = mix(col, float3(light.rgb), saturate((bright - 0.9) * 1.5));
    col *= bright;
    col += float3(rim.rgb) * glow;

    float alpha = saturate(max(col.r, max(col.g, col.b)));
    col /= max(1.0, max(col.r, max(col.g, col.b)));
    return half4(half3(col), half(alpha));
}

// MARK: Glow orb

/// A soft cloud of light: an elongated glow at `center`, turned by `angle`,
/// with edges made organic by noise.
static float lobe(float2 uv, float2 center, float angle, float2 stretch, float softness, float seed, float time) {
    float2 d = uv - center;
    float c = cos(angle), s = sin(angle);
    d = float2(c * d.x + s * d.y, -s * d.x + c * d.y) / stretch;
    // Wobble the shape so it never looks drawn.
    float wobble = noise(float3(uv * 2.4, seed + time * 0.2)) - 0.5;
    float dist = length(d) + wobble * 0.35;
    return exp(-dist * dist / softness);
}

/// Clouds of warm light floating inside a dark glass sphere, blending into each
/// other and turning near-white where they meet, with a thin glowing edge.
///
/// - size: the view's size in points.
/// - time: seconds, already multiplied by the speed.
/// - energy: 0 calm … 1 excited (brighter, bigger clouds).
/// - deep, mid, light, rim: the palette.
[[ stitchable ]] half4 glowOrb(float2 position, half4 color, float2 size, float time, float energy,
                              half4 deep, half4 mid, half4 light, half4 rim) {
    float radius = min(size.x, size.y) * 0.5;
    float2 uv = (position - size * 0.5) / (radius * 0.86);   // the sphere fills 86% of the view
    float r = length(uv);
    float pixel = 1.0 / (radius * 0.86);

    // Outside the sphere: only a soft halo.
    float halo = exp(-max(r - 1.0, 0.0) * 7.0) * smoothstep(1.16, 1.0, r) * (0.35 + energy * 0.3);
    if (r > 1.0) {
        float3 h = float3(rim.rgb) * halo;
        return half4(half3(h), half(halo));
    }

    float z = sqrt(max(0.0, 1.0 - r * r));
    float grow = 1.0 + energy * 0.35;

    // Bend space with a slow swirl, so the light curves like silk instead of sitting in blobs.
    float twist = (1.0 - r) * 1.6 + sin(time * 0.2) * 0.3;
    float ct = cos(twist), st = sin(twist);
    float2 w = float2(ct * uv.x - st * uv.y, st * uv.x + ct * uv.y);
    w += 0.22 * float2(noise(float3(uv * 1.6, 2.0 + time * 0.15)) - 0.5,
                       noise(float3(uv * 1.6, 9.0 + time * 0.15)) - 0.5);

    // Four large clouds of light, each its own warm colour, overlapping.
    float3 gold = float3(mid.rgb);
    float3 honey = float3(light.rgb);
    float3 amber = float3(rim.rgb);
    float3 ember = float3(deep.rgb) * 1.5;
    float3 col = float3(0.0);
    col += gold  * lobe(w, float2(0.32 + cos(time * 0.31) * 0.08, -0.22), 0.5,
                        float2(1.05, 0.38) * grow, 0.42, 1.0, time) * 1.0;
    col += amber * lobe(w, float2(-0.30, 0.18 + sin(time * 0.27) * 0.08), -0.7,
                        float2(0.95, 0.36) * grow, 0.42, 7.0, time) * 1.0;
    col += ember * lobe(w, float2(0.18, 0.42), 2.4,
                        float2(0.85, 0.34) * grow, 0.4, 13.0, time) * 0.9;
    col += honey * lobe(w, float2(-0.05, -0.02), 0.2,
                        float2(0.42, 0.36) * grow, 0.3, 19.0, time) * (0.5 + energy * 0.4);

    // Glass: deep inside, a thin glowing edge, a soft reflection at the top.
    float3 glass = float3(deep.rgb) * 0.08 * (0.5 + z);
    float fresnel = pow(1.0 - z, 4.0);
    float3 edge = float3(rim.rgb) * fresnel * 1.2;
    float3 halfway = normalize(normalize(float3(-0.4, 0.7, 0.6)) + float3(0, 0, 1));
    float reflection = pow(max(dot(float3(uv.x, -uv.y, z), halfway), 0.0), 260.0) * 0.3;

    // More contrast: deep shadows, bright light, warm in between.
    col = pow(col, float3(1.35, 1.45, 1.7)) * 1.7;
    // Clouds fade slightly towards the edge, as if seen through curved glass.
    col *= 0.55 + 0.45 * z;
    col = glass + col + edge + reflection;

    // Soft shoulder: overlaps turn warm white instead of clipping.
    col = 1.0 - exp(-col * 1.4);

    float alpha = 1.0 - smoothstep(1.0 - pixel * 1.5, 1.0, r);
    col = mix(float3(rim.rgb) * halo, col, alpha);
    return half4(half3(col), half(max(alpha, halo)));
}
