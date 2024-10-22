//
//  Vibe.swift
//  AssessmentNO1
//
//  Created by Muhammad  Farhan Akram on 22/10/2024.
//

#include <metal_stdlib>
using namespace metal;

kernel void leather(texture2d<float, access::read> inTexture [[ texture(0) ]],
                    texture2d<float, access::write> outTexture [[ texture(1) ]],
                    constant float &brightness [[ buffer(2) ]],
                    uint2 gid [[ thread_position_in_grid ]]) {
    float4 pixel = inTexture.read(gid);
    
    // Adjust brightness
    pixel.rgb += float3(brightness, brightness, brightness);
    
    // Clamp values to [0, 1] range
    pixel.rgb = clamp(pixel.rgb, 0.0, 1.0);
    
    outTexture.write(pixel, gid);
}
