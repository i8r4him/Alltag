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

// MARK: Bubble (the companion)

/// One wisp of silk: a thin, soft band along a gentle wave, turned by `angle`,
/// fading in and out along its length like smoke.
static float wisp(float2 uv, float angle, float offset, float amplitude, float frequency,
                  float phase, float width, float seed) {
    float c = cos(angle), s = sin(angle);
    float2 p = float2(c * uv.x + s * uv.y, -s * uv.x + c * uv.y);
    float centre = offset + amplitude * sin(p.x * frequency + phase);
    float d = (p.y - centre) / width;
    float band = exp(-d * d);
    // Brighter along one edge, like light catching a folded ribbon.
    float edge = exp(-pow((p.y - centre - width * 0.6) / (width * 0.3), 2.0)) * 0.3;
    float fade = smoothstep(0.15, 0.75, noise(float3(p.x * 1.3, seed, 0.5)));
    return (band * 0.5 + edge) * fade;
}

/// A dark glass bubble with a bright golden rim, a curved reflection at the
/// top left and thin wisps of golden silk drifting inside.
///
/// - size: the view's size in points.
/// - time: seconds, already multiplied by the speed.
/// - energy: 0 calm … 1 excited (brighter silk and rim).
/// - wobble: 0 round … 1 the edge ripples, as when the companion speaks.
/// - rimAmount, silkAmount, haloAmount: 1 is the default look, 0 off, 2 double.
/// - deep, mid, light, rim: the palette.
[[ stitchable ]] half4 bubbleOrb(float2 position, half4 color, float2 size, float time, float energy,
                                float wobble, float rimAmount, float silkAmount, float haloAmount,
                                half4 deep, half4 mid, half4 light, half4 rim) {
    float radius = min(size.x, size.y) * 0.5;
    float2 uv = (position - size * 0.5) / (radius * 0.86);
    // A voice ripples the edge: two waves running round it in opposite directions.
    float around = atan2(uv.y, uv.x);
    uv /= 1.0 + wobble * 0.04 * (0.6 * sin(around * 5.0 + time * 7.0) + 0.4 * sin(around * 3.0 - time * 5.0));
    float r = length(uv);
    float pixel = 1.0 / (radius * 0.86);

    // Outside: a warm halo around the rim.
    float halo = exp(-max(r - 1.0, 0.0) * 9.0) * smoothstep(1.16, 1.0, r) * (0.45 + energy * 0.3) * haloAmount;
    if (r > 1.0 + pixel * 1.5) {
        return half4(half3(float3(rim.rgb) * halo), half(halo));
    }

    float z = sqrt(max(0.0, 1.0 - r * r));
    float a = atan2(uv.y, uv.x);

    // Dark glass, faintly warm, a little lighter towards the edge.
    float3 col = float3(deep.rgb) * (0.05 + 0.12 * (1.0 - z));

    // Silk: wisps sweeping through, most of them in the lower half.
    float t = time * 0.4;
    float silk = 0.0;
    silk += wisp(uv, 0.45, 0.42, 0.10, 2.2, t, 0.17, 1.0);
    silk += wisp(uv, -0.55, 0.50, 0.12, 2.6, t * 0.8 + 1.7, 0.15, 4.0);
    silk += wisp(uv, 0.15, 0.68, 0.08, 3.0, -t + 3.1, 0.12, 9.0) * 0.8;
    silk += wisp(uv, 2.6, 0.38, 0.10, 2.0, t * 0.6 + 0.4, 0.14, 12.0) * 0.6;
    silk += wisp(uv, -2.3, 0.55, 0.09, 2.4, -t * 0.7 + 2.2, 0.12, 15.0) * 0.5;
    silk *= (0.85 + energy * 0.5) * silkAmount;
    // Mostly in the lower half; the face area stays dark.
    silk *= smoothstep(-0.9, 0.5, uv.y) * (1.0 - 0.65 * exp(-dot(uv, uv) * 5.0));
    // Seen through curved glass: softer near the rim.
    silk *= 0.45 + 0.55 * smoothstep(0.0, 0.5, z);
    col += mix(float3(rim.rgb) * 0.85, float3(light.rgb), saturate(silk - 0.6)) * silk;

    // Rim: a bright, thin golden edge with light bleeding inwards.
    float fresnel = pow(1.0 - z, 5.0);
    float line = exp(-pow((r - 0.99) / (pixel * 1.5 + 0.004), 2.0));
    float3 rimTone = mix(float3(rim.rgb), float3(light.rgb), 0.35);
    col += rimTone * (fresnel * 0.55 + line * 0.7) * (1.0 + energy * 0.4) * rimAmount;

    // A curved reflection along the top left, inside the rim.
    float arc = exp(-pow((r - 0.9) / 0.025, 2.0));
    float side = exp(-pow((a + 2.3) / 0.45, 2.0));   // centred at the top left
    col += float3(light.rgb) * arc * side * 0.55 * min(rimAmount, 1.5);

    col = 1.0 - exp(-col * 1.5);
    float alpha = 1.0 - smoothstep(1.0, 1.0 + pixel * 1.5, r);
    col = mix(float3(rim.rgb) * halo, col, alpha);
    return half4(half3(col), half(max(alpha, halo)));
}
