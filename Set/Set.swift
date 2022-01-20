//
//  Set.swift
//  Set
//
//  Created by Ankur Oberoi on 8/6/21.
//

import Foundation
import Algorithms

struct Set {
    
    var deck: [Card] = Set.generateDeck()
    var visibleCards: [Card] = []
    var discardPile: [Card] = []
    
    var selectedCards: Swift.Set<Card> = []
    
    var availableMatchingSelection: Swift.Set<Card>? {
        Set.findMatch(in: visibleCards)
    }
    
    public mutating func start() {
        drawCards(amount: 12)
    }
    
    public var matchIsSelected: Bool {
        Set.isMatch(cards: Array(selectedCards))
    }
    
    public mutating func discardPotentialMatch() {
        guard matchIsSelected else { return }
        
        // move selected cards to the matched cards
        visibleCards.removeAll { selectedCards.contains($0) }
        discardPile.append(contentsOf: selectedCards)
        // deselect
        selectedCards = []
        
        printHint()
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
        
        printHint()
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
    
    private func printHint() {
        // Find a set and print out the indexes
        if let cards = availableMatchingSelection {
            let indicies = cards.map({ visibleCards.firstIndex(of: $0)! })
            print("HINT: \(String(describing: indicies))")
        } else {
            print("HINT: Draw")
        }
    }
    
    static private func generateDeck() -> [Card] {
        var cards: [Card] = []
        for cardinality in TriState.allCases {
            for color in TriState.allCases {
                for symbol in TriState.allCases {
                    for shading in TriState.allCases {
                        cards.append(Card(cardinality: cardinality, color: color, symbol: symbol, shading: shading))
                    }
                }
            }
        }
        return cards.shuffled()
    }
    
    static private func findMatch(in cards: [Card]) -> Swift.Set<Card>? {
        for potentialMatch in cards.combinations(ofCount: 3) {
            if Set.isMatch(cards: potentialMatch) {
                return Swift.Set(potentialMatch)
            }
        }
        return nil
    }
    
    static private func isMatch<Cards: Collection>(cards: Cards) -> Bool where Cards.Element == Card {
        guard cards.count == 3 else { return false }
        
        // Checking for a match by eliminating mismatches that have a TriState with two of the same value and one different value
        // Cardinality
        let cardinalities = cards.map { $0.cardinality }
        let cardinalityCounts = TriState.stateCounts(in: cardinalities)
        if (TriState.hasTwoOfAnyState(in: cardinalityCounts)) {
            return false
        }
        // Color
        let colors = cards.map { $0.color }
        let colorCounts = TriState.stateCounts(in: colors)
        if (TriState.hasTwoOfAnyState(in: colorCounts)) {
            return false
        }
        // Symbol
        let symbols = cards.map { $0.symbol }
        let symbolCounts = TriState.stateCounts(in: symbols)
        if (TriState.hasTwoOfAnyState(in: symbolCounts)) {
            return false
        }
        // Shading
        let shadings = cards.map { $0.shading }
        let shadingCounts = TriState.stateCounts(in: shadings)
        if (TriState.hasTwoOfAnyState(in: shadingCounts)) {
            return false
        }
        
        return true
    }
    
    struct Card: Identifiable, Hashable {
        // TODO: This is an arbitrary way to identify cards, but it works. Ideally, the ID type would be a Tuple but
        // since Tuple's are not Hashable that doesn't work.
        var id: [TriState] {
            [cardinality, color, symbol, shading]
        }

        let cardinality: TriState
        let color: TriState
        let symbol: TriState
        let shading: TriState
    }
}
