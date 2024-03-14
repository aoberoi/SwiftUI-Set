//
//  Extensions_CoreGraphics.swift
//  Set
//
//  Created by Ankur Oberoi on 3/14/24.
//

import CoreGraphics

extension CGSize {
    var isNotWiderThanTall: Bool {
        height - width >= 0
    }
    
    var area: Double {
        height * width
    }
}
