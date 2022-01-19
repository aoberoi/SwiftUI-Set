//
//  PlayCardSizePreferenceKey.swift
//  Set
//
//  Created by Ankur Oberoi on 1/13/22.
//

import SwiftUI

struct PlayCardSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize?
    
    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        if let next = nextValue(), let someValue = value {
            // Keep the value with the maximum area
            if next.area > someValue.area {
                value = next
            }
        }
    }
}
