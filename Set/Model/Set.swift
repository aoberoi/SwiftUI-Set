//
//  Set.swift
//  Set
//
//  Created by Ankur Oberoi on 8/6/21.
//

import Foundation
import Algorithms

struct Set: CustomStringConvertible {
    var description: String {
        """
        Deck: \(Set.describeCards(deck))
        Visible Cards: \(Set.describeCards(visibleCards))
        Discard Pile: \(Set.describeCards(discardPile))
        """
    }
    
    private static func describeCards(_ cards: [Card]) -> String {
        if cards.isEmpty {
            return "[]"
        }
        
        return """
        [
          \(cards.map({ String(describing: $0) }).joined(separator: ", \n  "))
        ]
        """
    }
    
    // Next card to be drawn is at the start
    var deck: [Card] = Set.generateDeck()
    
    // Most recently drawn card is at the end
    var visibleCards: [Card] = []
    
    // Most recently discarded card is at the end
    var discardPile: [Card] = []
    
    // NOTE: this is kind of weird, because there's a copy of the card in this property. it may
    // make more sense to just store the IDs or the indicies of the selection based on the
    // visibleCards array (selected cards should always be a subset of the visible cards). let's
    // revisit this after we check how the view code uses this property. there could even be a
    // computed property that returns the selected cards based on a stored property which only has
    // the indicies. or maybe the selection could be a whole different model or view model?
    private var selectedCards: Swift.Set<Card> = []
    
    public var selectionIsComplete: Bool {
        selectedCards.count == 3
    }
    
    public var matchIsSelected: Bool {
        Set.isMatch(cards: selectedCards)
    }
    
    public func isSelected(card: Card) -> Bool {
        selectedCards.contains(card)
    }
    
    // NOTE: this property is somewhat expensive to compute. the read in discardPotentialMatch
    // could be replaced with only a check for deck.isEmpty. if that is true for other places
    // this property is read, then it may be worth separating the expensive part from the cheap part
    public var isOver: Bool {
        deck.isEmpty && availableMatchingSelection == nil
    }
    
    private var availableMatchingSelection: Swift.Set<Card>? {
        Set.findMatch(in: visibleCards)
    }
    
    public mutating func start() {
        guard visibleCards.isEmpty else { return }
        drawCards(amount: 12)
    }
    
    public mutating func discardPotentialMatch() {
        guard !isOver else { return }
        guard matchIsSelected else { return }
        
        // move selected cards to the matched cards
        visibleCards.removeAll { selectedCards.contains($0) }
        discardPile.append(contentsOf: selectedCards)
        // deselect
        selectedCards = []
        
        printHint()
    }
    
    public mutating func drawThreeMore() {
        guard !isOver else { return }
        drawCards(amount: 3)
    }
    
    public mutating func choose(card: Card) {
        guard !isOver else { return }
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
    
    private mutating func drawCards(amount: Int) {
        for _ in 0..<amount {
            if !deck.isEmpty {
                visibleCards.append(deck.removeFirst())
            }
        }
        
        printHint()
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
    
    struct Card: Identifiable, Hashable, CustomStringConvertible {
        
        // TODO: Remove the following description code because it references information that should
        // only be known in the View layer
        private static func symbolDescription(_ symbol: TriState) -> String {
            switch symbol {
            case .first:
                return "Diamond"
            case .second:
                return "Rectangle"
            case .third:
                return "Circle"
            }
        }
        
        private static func colorDescription(_ symbol: TriState) -> String {
            switch symbol {
            case .first:
                return "Red"
            case .second:
                return "Green"
            case .third:
                return "Purple"
            }
        }
        
        private static func cardinalityDescription(_ symbol: TriState) -> String {
            switch symbol {
            case .first:
                return "1"
            case .second:
                return "2"
            case .third:
                return "3"
            }
        }
        
        private static func shadingDescription(_ symbol: TriState) -> String {
            switch symbol {
            case .first:
                return "Solid"
            case .second:
                return "Striped"
            case .third:
                return "Open"
            }
        }
        
        var description: String {
            """
            (symbol: \(Card.symbolDescription(symbol)), \
            color: \(Card.colorDescription(color)), \
            cardinality: \(Card.cardinalityDescription(cardinality)), \
            shading: \(Card.shadingDescription(shading)))
            """
        }
        
        // This is an arbitrary way to identify cards, but it works. Ideally, the ID type would be a
        // Tuple but since Tuple's are not Hashable that doesn't work.
        var id: [TriState] {
            [cardinality, color, symbol, shading]
        }

        let cardinality: TriState
        let color: TriState
        let symbol: TriState
        let shading: TriState
    }
}
