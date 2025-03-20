//
//  FilterManager.swift
//  AuthFirebaseUser
//
//  Created by Николай Гринько on 19.03.2025.
//

import UIKit
import CoreImage

/// Класс который добавляет применение фильтров к изображению.
class FilterManager {
    static func applyFilter(to image: UIImage, filterName: String) -> UIImage? {
        let ciImage = CIImage(image: image)
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputImage = filter?.outputImage else { return nil }
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}
