//
//  UIImageResize.swift
//  CFBTracker
//
//  Created by Terry Wang on 11/20/20.
//  terrywangce@gmail.com
//

import Foundation
import UIKit

/// Used to resize images of UIimages
extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
