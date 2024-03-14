//
//  SetGame.swift
//  Set
//
//  Created by Ankur Oberoi on 3/13/24.
//

import Foundation
import Observation

@Observable
class SetGame {
    typealias Card = Set.Card
    
    var gameModel = Set()
    
    var deck: [Card] { gameModel.deck }
    var visibleCards: [Card] { gameModel.visibleCards }
    var discardPile: [Card] { gameModel.discardPile }
    
    // Card selection state
    var matchIsSelected: Bool { gameModel.matchIsSelected }
    
    func selectionState(for card: Card) -> CardSelectionState {
        guard gameModel.isSelected(card: card) else { return .unselected }
        guard gameModel.selectionIsComplete else { return .partOfIncomplete }
        return gameModel.matchIsSelected ? .partOfMatch : .partOfMismatch
    }
    
    enum CardSelectionState {
        case unselected, partOfIncomplete, partOfMatch, partOfMismatch
        
        var inSelection: Bool {
            self != .unselected
        }
    }
    
    // Game Over
    var isOver: Bool { gameModel.isOver }
    var totalMatchedCards: Int { gameModel.discardPile.count }
    
    // MARK: - Intents
    
    func start() {
        gameModel.start()
    }
    
    func reset() {
        gameModel = Set()
    }
    
    func draw() {
        gameModel.drawThreeMore()
    }
    
    func discardPotentialMatch() {
        gameModel.discardPotentialMatch()
    }
    
    func choose(card: Card) {
        gameModel.choose(card: card)
    }
    
    func printGame() {
        print(gameModel)
    }
}
