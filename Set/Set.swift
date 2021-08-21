//
//  Set.swift
//  Set
//
//  Created by Ankur Oberoi on 8/6/21.
//

import Foundation

struct Set {
    
    private var deck: [Card] = {
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
        return cards.shuffled()
    }()
    
    var drawnCards: [Card] = []
    
    init() {
        drawCards(amount: 12)
    }
    
    public mutating func drawCards(amount: Int) {
        for _ in 0..<amount {
            if !deck.isEmpty {
                drawnCards.append(deck.removeFirst())
            }
        }
    }
    
    struct Card: Identifiable {
        // TODO: This is an arbitrary way to identify cards, but it works. Ideally, the ID type would be a Tuple but
        // since Tuple's are not Hashable that doesn't work.
        var id: [TriState] {
            [cardinaity, color, symbol, shading]
        }

        let cardinaity: TriState
        let color: TriState
        let symbol: TriState
        let shading: TriState
    }
}
