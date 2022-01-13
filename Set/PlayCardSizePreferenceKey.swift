//
//  PlayCardSizePreferenceKey.swift
//  Set
//
//  Created by Ankur Oberoi on 1/13/22.
//

import SwiftUI

struct PlayCardSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        // TODO: remove log once this is working
        let next = nextValue()
        print("PlayCardSizePreferenceKey reduce called. value: \(value), next: \(next)")
        value = next
    }
}
