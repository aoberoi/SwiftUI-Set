//
//  PlayCardSizePreferenceKey.swift
//  Set
//
//  Created by Ankur Oberoi on 1/13/22.
//

import SwiftUI

struct PlayCardSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize?
    
    // Reduce to a single value by:
    // - always traversing the siblings by calling nextValue()
    // - assign value to the largest CGSize
    //
    // Therefore, the value of PlayCardSizePreferenceKey is always the maximum size of all views
    // which set a value for this PreferenceKey.
    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        if let currentSize = value {
            if let nextSize = nextValue() {
                // Assign value to the greater of the current value and the next sibling
                let largerByArea = currentSize.area > nextSize.area ? currentSize : nextSize
                value = largerByArea
            }
            // Otherwise, value does not need to be updated
        } else {
            // If value is the defaultValue, then freely overwrite it with the value of the next sibling
            value = nextValue()
        }
    }
}
