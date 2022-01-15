//
//  Extensions.swift
//  Set
//
//  Created by Ankur Oberoi on 1/15/22.
//

import Foundation

extension RangeReplaceableCollection where Self.Element : Equatable, Self : MutableCollection {
    mutating func separateElements<I: Sequence>(fromIndicies: I) -> Self.SubSequence where I.Element == Self.Index {
        var copy = self
        let pivot = copy.partition { element in
            for index in fromIndicies {
                if self[index] == element {
                    return true
                }
            }
            return false
        }
        self[...] = copy[..<pivot]
        return copy[pivot...]
    }
}
