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
