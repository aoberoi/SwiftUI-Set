//
//  SetGame.swift
//  Set
//
//  Created by Ankur Oberoi on 8/6/21.
//

import Foundation

class SetGame : ObservableObject {
    typealias Card = Set.Card
    
    @Published private var gameModel = Set()
    
    var deck: [Card] { gameModel.deck }
    var deckIsEmpty: Bool { gameModel.deckIsEmpty }
    
    var drawnCards: [Card] { gameModel.drawnCards }
    
    var matchedCards: [Card] { gameModel.matchedCards }
    var hasNoMatchedCards: Bool { gameModel.hasNoMatchedCards }
    
    var matchIsSelected: Bool { gameModel.matchIsSelected }
    var numberOfSelectedCards: Int { gameModel.selectedCardIndicies.count }
    
    // MARK: Intents
    
    func draw() {
        gameModel.draw()
    }
    
    func reset() {
        gameModel = Set()
    }
    
    func choose(card: Card) {
        gameModel.choose(card: card)
    }
    
    func isSelected(card: Card) -> Bool {
        gameModel.isSelected(card: card)
    }
}
