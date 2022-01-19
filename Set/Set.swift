//
//  Set.swift
//  Set
//
//  Created by Ankur Oberoi on 8/6/21.
//

import Foundation

struct Set {
    
    var deck: [Card] = Set.generateDeck()
    var visibleCards: [Card] = []
    var discardPile: [Card] = []
    
    var selectedCards: Swift.Set<Card> = []

    public var matchIsSelected: Bool {
        guard selectedCards.count == 3 else {
            return false
        }
        
        // Checking for a match by eliminating mismatches that have a TriState with two of the same value and one different value
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
    
    public mutating func start() {
        drawCards(amount: 12)
    }
    
    public mutating func discardPotentialMatch() {
        guard matchIsSelected else { return }
        
        // move selected cards to the matched cards
        visibleCards.removeAll { selectedCards.contains($0) }
        discardPile.append(contentsOf: selectedCards)
        // deselect
        selectedCards = []
    }
    
    public mutating func drawThreeMore() {
        drawCards(amount: 3)
    }
    
    public mutating func drawCards(amount: Int) {
        for _ in 0..<amount {
            if !deck.isEmpty {
                visibleCards.append(deck.removeFirst())
            }
        }
    }
    
    public mutating func choose(card: Card) {
        guard visibleCards.contains(card) else { return }
        
        if selectedCards.count < 3 {
            if selectedCards.contains(card) {
                selectedCards.remove(card)
            } else {
                selectedCards.insert(card)
            }
        } else if matchIsSelected {
            discardPotentialMatch()
            // adjust selection
            if visibleCards.contains(card) {
                selectedCards = [card]
            } else {
                selectedCards = []
            }
        } else {
            selectedCards = [card]
        }
    }
    
    public func isSelected(card: Card) -> Bool {
        selectedCards.contains(card)
    }
    
    static private func generateDeck() -> [Card] {
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
    }
    
    struct Card: Identifiable, Hashable {
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
