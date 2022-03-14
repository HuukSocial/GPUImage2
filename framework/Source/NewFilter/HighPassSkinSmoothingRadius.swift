//
//  HighPassSkinSmoothingRadius.swift
//  Malibu
//
//  Created by Taras Chernyshenko on 7/23/19.
//  Copyright © 2019 Salon Software. All rights reserved.
//

import Foundation

public enum HighPassSkinSmoothingRadiusUnit {
    case pixel
    case fractionOfImageWidth
}

public class HighPassSkinSmoothingRadius {
    public var unit: HighPassSkinSmoothingRadiusUnit
    public var value: Float
    
    public init(pixels: Float) {
        self.value = pixels
        self.unit = .pixel
    }
    
    public init(fraction: Float) {
        self.value = fraction
        self.unit = .fractionOfImageWidth
    }
}
