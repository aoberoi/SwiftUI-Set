//
//  CardPile.swift
//  Set
//
//  Created by Ankur Oberoi on 3/14/24.
//

import SwiftUI

struct CardPile: View {
    let cards: [SetGame.Card]
    let isFaceUp: Bool
    let borderColor: Color
    
    @Environment(\.cardMovement) var cardMovement
    
    var body: some View {
        let pile = isFaceUp ? cards : cards.reversed()
        ZStack {
            ForEach(pile) { card in
                CardView(
                    card: card,
                    borderColor: borderColor,
                    hasThickBorder: false,
                    isFaceUp: isFaceUp
                )
                // NOTE: The following zIndex modifier is used as a workaround to an issue where
                // views transitioning out of a ZStack will not preserve their stacking order
                // unless that view (and likely all the views) are assigned a zIndex explicitly.
                .zIndex(Double(pile.firstIndex(of: card) ?? 0))
                .matchedGeometryEffect(id: card.id, in: cardMovement)
            }
        }
    }
}

#Preview {
    let sampleDeck = [
        SetGame.Card(cardinality: .first, color: .first, symbol: .first, shading: .first),
        SetGame.Card(cardinality: .first, color: .first, symbol: .first, shading: .second),
        SetGame.Card(cardinality: .first, color: .first, symbol: .first, shading: .third),
        SetGame.Card(cardinality: .first, color: .first, symbol: .second, shading: .first),
    ]
    return CardPile(
        cards: sampleDeck,
        isFaceUp: false,
        borderColor: .accentColor
    )
}
