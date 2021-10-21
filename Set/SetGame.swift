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
    
    var drawnCards: [Card] { gameModel.drawnCards }
    var deckIsEmpty: Bool { gameModel.deckIsEmpty }
    
    var matchIsSelected: Bool { gameModel.matchIsSelected }
    var numberOfSelectedCards: Int { gameModel.selectedCardIndicies.count }
    
    // MARK: Intents
    
    func drawThreeCards() {
        gameModel.drawCards(amount: 3)
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
