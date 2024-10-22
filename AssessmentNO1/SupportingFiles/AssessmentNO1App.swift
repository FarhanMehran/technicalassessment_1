//
//  AssessmentNO1App.swift
//  AssessmentNO1
//
//  Created by Muhammad  Farhan Akram on 22/10/2024.
//

import SwiftUI

@main
struct AssessmentNO1App: App {
    var body: some Scene {
        WindowGroup {
            FilteredImageView()
        }
    }
}
import SwiftUI

import SwiftUI

struct ContentView: View {
    @State private var startDate = Date()
    @State private var crtEffectStrength: Float = 0.3 // Default strength

    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    TimelineView(.animation) { _ in
                        Image("image_1") // Replace with your image name
                            .resizable()
                            .scaledToFill()
                            .blur(radius: 1.2)
                            .layerEffect(
                                ShaderLibrary.crtEffect(
                                    .float(-startDate.timeIntervalSinceNow),
                                    .float2(geo.size),
                                    .float(crtEffectStrength) // Wrap it in .float
                                ),
                                maxSampleOffset: .zero
                            )
                            .opacity(0.4)
                    }
                }
                .overlay(
                    Text("Some content")
                        .fontWidth(.expanded)
                        .fontWeight(.heavy)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(24)
                        .layerEffect(
                            ShaderLibrary.crtEffect(
                                .float(-startDate.timeIntervalSinceNow),
                                .float2(geo.size),
                                .float(crtEffectStrength) // Wrap it in .float
                            ),
                            maxSampleOffset: .zero
                        )
                )
            }
            .aspectRatio(1, contentMode: .fit)

            // Slider to adjust CRT effect strength
            Slider(value: $crtEffectStrength, in: 0...1, step: 0.01) {
                Text("CRT Effect Strength")
            }
            .padding()

            Spacer()
        }
        .background(
            RadialGradient(stops: [
                .init(color: .white.opacity(0.2), location: 0),
                .init(color: .black, location: 1)
            ], center: .center, startRadius: 10, endRadius: 1000)
        )
    }
}
