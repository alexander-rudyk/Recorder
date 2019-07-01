//
//  Float+Extension.swift
//  Genesis_Test
//
//  Created by Alexander Rudyk on 6/28/19.
//  Copyright © 2019 iDev. All rights reserved.
//

import Foundation

extension Float {
    public func rounded(toPlaces places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
    
    public func stringFormat(toPlaces places: Int) -> String {
        let double = rounded(toPlaces: places)
        let value = NSNumber(value: double)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.minimumFractionDigits = 2
        
        return numberFormatter.string(from: value) ?? "\(value)"
    }
}
