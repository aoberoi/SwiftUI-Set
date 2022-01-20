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
    
    // TODO: see if @Published helps remove any need for calling objectWillChange.send()
//    @Published private var visuallyUndealtCards: [Card] = []
    
//    var deck: [Card] { visuallyUndealtCards + gameModel.deck }
//    var deckIsEmpty: Bool { visuallyUndealtCards.isEmpty && gameModel.deckIsEmpty }
//    var drawnCards: [Card] { gameModel.drawnCards.filter({ !visuallyUndealtCards.contains($0) }) }
    
    var deck: [Card] { gameModel.deck }
    var visibleCards: [Card] { gameModel.visibleCards }
    var discardPile: [Card] { gameModel.discardPile }
    
    // TODO: the indicies could be wrong since visuallyUndealtCards were removed from the drawnCards
    var matchIsSelected: Bool { gameModel.matchIsSelected }
    var numberOfSelectedCards: Int { gameModel.selectedCards.count }
    var totalMatchedSets: Int { gameModel.discardPile.count / 3 }
    var isOver: Bool { gameModel.deck.isEmpty && gameModel.availableMatchingSelection == nil }
    
    // MARK: Intents
    
    func start(/* onEachCard: (Int, () -> Void) -> Void */) {
        gameModel.start()
//        visuallyUndealtCards.append(contentsOf: gameModel.drawnCards)
//        var index = 0
//        while !visuallyUndealtCards.isEmpty {
//            onEachCard(index, {
//                visuallyUndealtCards.removeFirst()
//            })
//            index += 1
//        }
    }
    
    func reset() {
        gameModel = Set()
    }
    
    func draw() {
        guard !isOver else { return }
        gameModel.drawThreeMore()
    }
    
    func discardPotentialMatch() {
        guard !isOver else { return }
        gameModel.discardPotentialMatch()
    }
    
    func choose(card: Card) {
        guard !isOver else { return }
        gameModel.choose(card: card)
    }
    
    func isSelected(card: Card) -> Bool {
        gameModel.isSelected(card: card)
    }
    
    
//    struct DealActions: Sequence, IteratorProtocol {
//        mutating func next() -> (() -> Void)? {
//            return nil
//        }
//    }
}
