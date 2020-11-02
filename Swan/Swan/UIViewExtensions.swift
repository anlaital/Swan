//
//  UIViewExtensions.swift
//  Swan
//
//  Created by Antti Laitala on 22/05/15.
//
//

import Foundation
import UIKit

public extension UIView {
    
    final func snapshotAfterScreenUpdates(_ afterScreenUpdates: Bool) -> UIImage {
        guard !bounds.isEmpty else {
            return UIImage()
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
}
