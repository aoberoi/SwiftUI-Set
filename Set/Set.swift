//
//  Set.swift
//  Set
//
//  Created by Ankur Oberoi on 8/6/21.
//

import Foundation

struct Set {
    
    var deck: [Card] = {
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
    var matchedCards: [Card] = []
    var deckIsEmpty: Bool { deck.isEmpty }
    var hasNoMatchedCards: Bool { matchedCards.isEmpty }
    
    var selectedCardIndicies: Swift.Set<Int> = []
    
    public var matchIsSelected: Bool {
        guard selectedCardIndicies.count == 3 else {
            return false
        }
        
        // Checking for a match by eliminating mismatches that have a TriState with two of the same value and one different value
        let selectedCards = selectedCardIndicies.map { drawnCards[$0] }
        
        // Cardinality
        let cardinalities = selectedCards.map { $0.cardinaity }
        let cardinalityCounts = TriState.stateCounts(in: cardinalities)
        if (TriState.hasTwoOfAnyState(in: cardinalityCounts)) {
            return false
        }
        // Color
        let colors = selectedCards.map { $0.color }
        let colorCounts = TriState.stateCounts(in: colors)
        if (TriState.hasTwoOfAnyState(in: colorCounts)) {
            return false
        }
        // Symbol
        let symbols = selectedCards.map { $0.symbol }
        let symbolCounts = TriState.stateCounts(in: symbols)
        if (TriState.hasTwoOfAnyState(in: symbolCounts)) {
            return false
        }
        // Shading
        let shadings = selectedCards.map { $0.shading }
        let shadingCounts = TriState.stateCounts(in: shadings)
        if (TriState.hasTwoOfAnyState(in: shadingCounts)) {
            return false
        }
        
        return true
    }
    
    init() {
        drawCards(amount: 12)
    }
    
    public mutating func draw() {
        drawCards(amount: 3)
        // TODO: there is some repetition in the following and some code inside the choose(card:) method
        if matchIsSelected {
            for selectedIndex in selectedCardIndicies {
                matchedCards.append(drawnCards.remove(at: selectedIndex))
            }
            selectedCardIndicies = []
        }
    }
    
    private mutating func drawCards(amount: Int) {
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
                // move selected cards to the matched cards
                for selectedIndex in selectedCardIndicies {
                    matchedCards.append(drawnCards.remove(at: selectedIndex))
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
