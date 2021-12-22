//
//  NSUIColor+Hex.swift
//  TimeVisualizer
//
//  Created by administrator on 22/12/2021.
//

import Foundation
import UIKit
import Charts

extension NSUIColor{
    // convenience = a secondary init that musr call
    convenience init(red: Int, green: Int, blue: Int){
        // assert first check the condition if it is false will crash app
        assert(red >= 0 && red <= 255, "invalid red")
        assert(green >= 0 && green <= 255, "invalid green")
        assert(blue >= 0 && blue <= 255, "invalid blue")
        
        self.init(red:CGFloat(red) / 255.0, green:CGFloat(green) / 255.0, blue:CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int){
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}
