//
//  ControlsView.swift
//  Set
//
//  Created by Ankur Oberoi on 3/14/24.
//

import SwiftUI

// TODO: FIRST the preview crashes

struct ControlsView: View {
    @Environment(SetGame.self) private var game
    
    let drawCardsDuration: Double
    let resetCardsDuration: Double
    let discardCardsDuration: Double
    
    let cardAspectRatio: CGFloat
    
    let cardBorderColor: Color
    
    var body: some View {
        // NOTE: A custom layout could be used to better express that each of the 3 children of
        // the HStack should take up equal width, and it should take up all the width offered.
        HStack {
            deck.onTapGesture(perform: drawMoreCards)
                .frame(maxWidth: .infinity)
            Button("New Game", action: newGame)
                .frame(maxWidth: .infinity)
            discardPile
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color("FeltGreen"))
        .foregroundColor(.white)
    }
    
    private var deck: some View {
        ZStack {
            CardPlaceholder(label: "Deck Empty")
            CardPile(cards: game.deck, isFaceUp: false, borderColor: cardBorderColor)
        }
        .aspectRatio(cardAspectRatio, contentMode: .fit)
    }
    
    private var discardPile: some View {
        ZStack {
            CardPlaceholder(label: "Discard")
            CardPile(cards: game.discardPile, isFaceUp: true, borderColor: cardBorderColor)
        }
        .aspectRatio(cardAspectRatio, contentMode: .fit)
    }
    
    // MARK: Actions
    
    private func drawMoreCards() {
        let willDiscard = game.matchIsSelected
        withAnimation(.easeInOut(duration: discardCardsDuration)) {
            game.discardPotentialMatch()
        }
        withAnimation(
            .easeInOut(duration: drawCardsDuration).delay(willDiscard ? discardCardsDuration : 0)
        ) {
            game.draw()
        }
    }
    
    private func newGame() {
        withAnimation(.easeInOut(duration: resetCardsDuration)) {
            game.reset()
        }
        withAnimation(.easeInOut(duration: drawCardsDuration).delay(resetCardsDuration)) {
            game.start()
        }
    }
}

#Preview {
    ControlsView(
        drawCardsDuration: 0.1,
        resetCardsDuration: 0.1,
        discardCardsDuration: 0.1,
        cardAspectRatio: 2/1,
        cardBorderColor: .accentColor
    )
}
