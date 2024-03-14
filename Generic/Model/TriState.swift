//
//  TriState.swift
//  Set
//
//  Created by Ankur Oberoi on 3/14/24.
//

enum TriState: CaseIterable {
    case first, second, third
    
    static func stateCounts(in values: [TriState]) -> StateCount {
        var counts = StateCount()
        for value in values {
            if value == .first { counts.first += 1 }
            if value == .second { counts.second += 1 }
            if value == .third { counts.third += 1 }
        }
        return counts
    }
    
    static func hasTwoOfAnyState(in counts: StateCount) -> Bool {
        return counts.first == 2 || counts.second == 2 || counts.third == 2
    }
    
    struct StateCount {
        var first = 0
        var second  = 0
        var third = 0
    }
}
