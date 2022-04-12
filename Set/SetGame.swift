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
    var visibleCards: [Card] { gameModel.visibleCards }
    var discardPile: [Card] { gameModel.discardPile }
    
    var matchIsSelected: Bool { gameModel.matchIsSelected }
    var totalMatchedCards: Int { gameModel.discardPile.count }
    var isOver: Bool { gameModel.isOver }
    
    func selectionState(for card: Card) -> CardSelectionState {
        guard gameModel.isSelected(card: card) else { return .unselected }
        guard gameModel.selectionIsComplete else { return .partOfIncomplete }
        
        if gameModel.matchIsSelected {
            return .partOfMatch
        }
        return .partOfMismatch
    }
    
    enum CardSelectionState {
        case unselected, partOfIncomplete, partOfMatch, partOfMismatch
        
        var inSelection: Bool {
            self != .unselected
        }
    }
    
    
    // MARK: Intents
    
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
    
}
