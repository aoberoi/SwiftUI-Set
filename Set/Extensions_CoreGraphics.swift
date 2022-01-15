//
//  Extensions_CoreGraphics.swift
//  Set
//
//  Created by Ankur Oberoi on 1/15/22.
//

import CoreGraphics

extension CGSize {
    var isNotWiderThanTall: Bool {
        height - width >= 0
    }
}
