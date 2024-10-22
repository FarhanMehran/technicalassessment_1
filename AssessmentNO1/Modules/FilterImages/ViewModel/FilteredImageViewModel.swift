//
//  FilteredImageViewModel.swift
//  AssessmentNO1
//
//  Created by Muhammad  Farhan Akram on 22/10/2024.
//


import Foundation
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class FilteredImageViewModel: ObservableObject {
    @Published var mainImage: UIImage = UIImage(named: "image_1") ?? UIImage() // Main image
    @Published var filteredMainImage: UIImage? // Filtered main image
    @Published var filteredImages: [UIImage?] = [] // To hold filtered images for previews

    let filters: [CIFilter] = [
        CIFilter.sepiaTone(),
        CIFilter.crystallize(),
        CIFilter.pixellate(),
        CIFilter.vignette(),
        CIFilter.edges(),
        CIFilter.gaussianBlur(),
        CIFilter.unsharpMask()
    ]
    
    let imageFilter = ImageFilter() // Combined filter class instance
    
    init() {
        // Initialize filteredImages array
        filteredImages = Array(repeating: nil, count: filters.count)
        generateFilteredImages()
    }

    // Generate filtered images for each filter
    private func generateFilteredImages() {
        for (index, filter) in filters.enumerated() {
            imageFilter.applyFilter(to: mainImage, brightness: 0.0, filter: filter) { result in
                if let resultImage = result {
                    DispatchQueue.main.async {
                        self.filteredImages[index] = resultImage
                    }
                }
            }
        }
    }

    // Apply selected Core Image filter to main image with strength
    func applySelectedFilter(_ filter: CIFilter, strength: Float) {
        imageFilter.applyFilter(to: mainImage, brightness: Float(strength), filter: filter) { filteredImage in
            DispatchQueue.main.async {
                self.filteredMainImage = filteredImage
            }
        }
    }
}

