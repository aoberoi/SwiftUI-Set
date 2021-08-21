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
    
    // MARK: Intents
    
    func drawThreeCards() {
        gameModel.drawCards(amount: 3)
    }
    
    func reset() {
        gameModel = Set()
    }
}
