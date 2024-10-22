//  FilteredImageView.swift
//  AssessmentNO1
//
//  Created by Muhammad Farhan Akram on 22/10/2024.
//

import SwiftUI

struct FilteredImageView: View {
    @StateObject private var viewModel = FilteredImageViewModel() // ViewModel instance
    @State private var filterStrength: Float = 0.5 // Slider value for filter strength (0 = max effect, 1 = no effect)
    @State private var startDate = Date() // Assuming you want to track when the effect starts
    @State private var crtEffectStrength: Float = 0.5 // Strength for the CRT effect
    @State private var selectedFilterIndex: Int? // Track the selected filter index

    var body: some View {
        GeometryReader { geo in // Use GeometryReader to get the size of the view
            VStack {
                // Main filtered image display
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color(UIColor.systemGray5)) // Use a light gray background for better contrast
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)

                    // Show the filtered image with the applied filter strength
                    if let filteredImage = viewModel.filteredMainImage {
                        Image(uiImage: filteredImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .padding()
                            .layerEffect(
                                ShaderLibrary.crtEffect(
                                    .float(-startDate.timeIntervalSinceNow),
                                    .float2(geo.size),
                                    .float(crtEffectStrength) // Wrap it in .float
                                ),
                                maxSampleOffset: .zero
                            )
                    } else {
                        Image(uiImage: viewModel.mainImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .padding()
                    }
                }
               // .frame(maxHeight: 400)
                .padding()

                // Horizontal filter selection list
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // Core Image filters
                        ForEach(0..<viewModel.filters.count, id: \.self) { index in
                            if viewModel.filteredImages.indices.contains(index), let filteredImage = viewModel.filteredImages[index] {
                                Image(uiImage: filteredImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .background(Color(UIColor.systemGray5)) // Adapt to light/dark mode
                                    .cornerRadius(8)
                                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                    .onTapGesture {
                                        selectedFilterIndex = index // Update selected filter index
                                        viewModel.applySelectedFilter(viewModel.filters[index], strength: 1 - filterStrength) // Apply selected filter with reversed strength
                                    }
                            } else {
                                // Placeholder for loading
                                Image(uiImage: viewModel.mainImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .background(Color(UIColor.systemBackground)) // Adapt to light/dark mode
                                    .cornerRadius(8)
                                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                        }
                    }
                    .padding()
                }

                // Slider to adjust filter strength
                Slider(value: $filterStrength, in: 0...1, step: 0.01) {
                    Text("Filter Strength")
                }
                .padding()
                .onChange(of: filterStrength) { newValue in
                    // Apply the current selected filter with the reversed strength value
                    if let selectedIndex = selectedFilterIndex {
                        viewModel.applySelectedFilter(viewModel.filters[selectedIndex], strength: 1 - newValue)
                    }
                }
            }
            .navigationTitle("Filter Preview")
            .padding(.horizontal)
            .background(Color(UIColor.gray)) // Set a background color for the view
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        }
    }
}

struct FilteredImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FilteredImageView()
                .preferredColorScheme(.light) // Light mode preview
            FilteredImageView()
                .preferredColorScheme(.dark) // Dark mode preview
        }
    }
}
