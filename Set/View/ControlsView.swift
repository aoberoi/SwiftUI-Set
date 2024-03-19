//
//  ControlsView.swift
//  Set
//
//  Created by Ankur Oberoi on 3/14/24.
//

import SwiftUI

struct ControlsView: View {
    @Environment(SetGame.self) private var game
    
    let cardFlyingAnimation: Animation
    let cardFlyingDuration: Double
    
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
        .background(.feltGreen)
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
        withAnimation(cardFlyingAnimation) {
            game.discardPotentialMatch()
        }
        withAnimation(
            cardFlyingAnimation.delay(willDiscard ? cardFlyingDuration : 0)
        ) {
            game.draw()
        }
    }
    
    private func newGame() {
        withAnimation(cardFlyingAnimation) {
            game.reset()
        }
        withAnimation(cardFlyingAnimation.delay(cardFlyingDuration)) {
            game.start()
        }
    }
}

#Preview("Portrait", traits: .portrait) {
    VerticalSplitWithHeightLimitOnLower(
        upper: Rectangle(),
        lower: ControlsView(
            cardFlyingAnimation: .default,
            cardFlyingDuration: 0.0,
            cardAspectRatio: 2/1,
            cardBorderColor: .accentColor
        ),
        lowerMaxProportionOfHeight: 1/4
    )
    .environment(SetGame())
}

#Preview("Landscape", traits: .landscapeLeft) {
    VerticalSplitWithHeightLimitOnLower(
        upper: Rectangle(),
        lower: ControlsView(
            cardFlyingAnimation: .default,
            cardFlyingDuration: 0.0,
            cardAspectRatio: 2/1,
            cardBorderColor: .accentColor
        ),
        lowerMaxProportionOfHeight: 1/4
    )
    .environment(SetGame())
}


