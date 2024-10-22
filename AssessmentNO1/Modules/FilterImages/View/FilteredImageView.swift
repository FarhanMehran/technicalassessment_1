//  FilteredImageView.swift
//  AssessmentNO1
//
//  Created by Muhammad Farhan Akram on 22/10/2024.
//

import SwiftUI

struct FilteredImageView: View {
    @StateObject private var viewModel = FilteredImageViewModel() // ViewModel instance

    var body: some View {
        VStack {
            // Main filtered image display
            ZStack {
                Rectangle()
                    .fill(Color(UIColor.systemGray5)) // Use a light gray background for better contrast
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)

                // Show the filtered image
                if let filteredImage = viewModel.filteredMainImage {
                    Image(uiImage: filteredImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .padding()
                } else {
                    Image(uiImage: viewModel.mainImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .padding()
                }
            }
            .frame(maxHeight: 400)
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
                                    viewModel.applySelectedFilter(viewModel.filters[index])
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
        }
        .navigationTitle("Filter Preview")
        .padding(.horizontal)
        .background(Color(UIColor.gray)) // Set a background color for the view
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
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
