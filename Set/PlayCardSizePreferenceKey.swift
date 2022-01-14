//
//  PlayCardSizePreferenceKey.swift
//  Set
//
//  Created by Ankur Oberoi on 1/13/22.
//

import SwiftUI

struct PlayCardSizePreferenceKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>?
    
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}
