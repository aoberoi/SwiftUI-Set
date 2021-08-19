//
//  Set.swift
//  Set
//
//  Created by Ankur Oberoi on 8/6/21.
//

import Foundation

struct Set {
    
    private(set) var deck: [Card] = {
        var cards: [Card] = []
        for cardinality in TriState.allCases {
            for color in TriState.allCases {
                for symbol in TriState.allCases {
                    for shading in TriState.allCases {
                        cards.append(Card(cardinaity: cardinality, color: color, symbol: symbol, shading: shading))
                    }
                }
            }
        }
        return cards
    }()
    
    struct Card {
        let cardinaity: TriState
        let color: TriState
        let symbol: TriState
        let shading: TriState
    }
}
