//
//  Vibe.swift
//  AssessmentNO1
//
//  Created by Muhammad  Farhan Akram on 22/10/2024.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

float2 distort(float2 uv, float strength) {
    float2 dist = 0.5 - uv;
    uv.x = (uv.x - dist.y * dist.y * dist.x * strength);
    uv.y = (uv.y - dist.x * dist.x * dist.y * strength);
    return uv;
}

[[stitchable]]
half4 crtEffect(float2 position, SwiftUI::Layer layer, float time, float2 size, float strength) {
    float2 uv = position / size;

    // Apply distortion based on the provided strength
    uv = distort(uv, strength);
    
    // Render color
    half4 col = layer.sample(uv * size);
    
    // Brighten image
    col *= half4(0.95, 1.05, 0.95, 1);
    col *= 2.8;

    // Add scan lines
    float scans = clamp(0.35 + 0.35 * sin(3.5 * time + uv.y * size.y * 1.5), 0.0, 1.0);
    float s = pow(scans, 1.7);
    float sn = 0.4 + 0.7 * s;
    col = col * half4(sn, sn, sn, 1);

    // Normalize color
    col *= 1.0 + 0.01 * sin(110.0 * time);
    float c = clamp((fmod(position.x, 2.0) - 1.0) * 2.0, 0.0, 1.0);
    col *= 1.0 - 0.65 * half4(c, c, c, 1);

    return col;
}
