//
//  ImageFilter.swift
//  AssessmentNO1
//
//  Created by Muhammad  Farhan Akram on 22/10/2024.
//

import UIKit
import CoreImage

class ImageFilter {
    let context = CIContext()

    // Apply brightness and filter to an image
    func applyFilter(to inputImage: UIImage, brightness: Float, filter: CIFilter?, completion: @escaping (UIImage?) -> Void) {
        // Ensure we are on a background thread for processing
        DispatchQueue.global(qos: .userInitiated).async {
            // Make sure to handle the memory correctly
            guard let ciImage = CIImage(image: inputImage) else {
                DispatchQueue.main.async { completion(nil) } // Return on main thread if failed
                return
            }
            
            var filteredImage: UIImage?

            // Apply Core Image filter if provided
            if let filter = filter {
                filteredImage = self.applyCoreImageFilter(filter, to: ciImage)
            } else {
                filteredImage = inputImage // No filter, keep original
            }

            // Adjust brightness
            if let image = filteredImage {
                filteredImage = self.applyBrightness(to: image, brightness: brightness)
            }

            // Ensure we return to the main thread for UI updates
            DispatchQueue.main.async {
                completion(filteredImage)
            }
        }
    }

    // Apply brightness adjustment using Core Image
    func applyBrightness(to inputImage: UIImage, brightness: Float) -> UIImage? {
        guard let ciImage = CIImage(image: inputImage) else { return nil }
        
        let brightnessFilter = CIFilter(name: "CIColorControls")
        brightnessFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        brightnessFilter?.setValue(brightness, forKey: kCIInputBrightnessKey)

        if let outputImage = brightnessFilter?.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }

    // Apply Core Image filter
    func applyCoreImageFilter(_ filter: CIFilter, to inputImage: CIImage) -> UIImage? {
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}

extension UIImage {
    func correctedOrientation() -> UIImage? {
        guard imageOrientation != .up else { return self }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}
