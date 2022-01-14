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
        // TODO: remove log once this is working
        let next = nextValue()
        print("PlayCardSizePreferenceKey reduce called. value: \(String(describing: value)), next: \(String(describing: next))")
        value = next
    }
}
