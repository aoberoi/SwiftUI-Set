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
    var deckIsEmpty: Bool { deck.isEmpty }
    
    var selectedCardIndicies: Swift.Set<Int> = []
    
    var matchIsSelected: Bool {
        guard selectedCardIndicies.count == 3 else {
            return false
        }
        
        // TODO: algoritm for checking when 3 cards are a match
        return true
    }
    
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
    
    public mutating func choose(card: Card) {
        if let cardIndex = drawnCards.firstIndex(where: { $0.id == card.id }) {
            if selectedCardIndicies.count < 3 {
                if selectedCardIndicies.contains(cardIndex) {
                    selectedCardIndicies.remove(cardIndex)
                } else {
                    selectedCardIndicies.insert(cardIndex)
                }
            } else if matchIsSelected {
                // replace selected cards with 3 new ones from the deck (or as many as possible)
                for selectedIndex in selectedCardIndicies {
                    if !deck.isEmpty {
                        drawnCards.replaceSubrange(selectedIndex..<selectedIndex+1, with: [deck.removeFirst()])
                    } else {
                        drawnCards.remove(at: selectedIndex)
                    }
                }
                // adjust selection
                if selectedCardIndicies.contains(cardIndex) {
                    selectedCardIndicies = []
                } else {
                    selectedCardIndicies = [cardIndex]
                }
            } else {
                selectedCardIndicies = [cardIndex]
            }
        }
    }
    
    public func isSelected(card: Card) -> Bool {
        guard let cardIndex = drawnCards.firstIndex(where: { $0.id == card.id }) else {
            return false
        }
        
        return selectedCardIndicies.contains(cardIndex)
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
