//
//  CardStackView.swift
//  Set
//
//  Created by Ankur Oberoi on 1/22/22.
//

import SwiftUI

struct CardStackView: View {
    let cards: [SetGame.Card]
    let isFaceUp: Bool
    let cardBorderColor: Color
    let namespace: Namespace.ID
    let reverseOrder: Bool = false
    
    var body: some View {
        ZStack {
            ForEach(cards) { card in
                CardView(
                    card: card,
                    cardBorderColor: cardBorderColor,
                    hasThickBorder: false,
                    isFaceUp: isFaceUp
                )
                    .matchedGeometryEffect(id: card.id, in: namespace)
                    .zIndex(zIndex(for: card))
            }
//            ZStack {
//                GeometryReader { geometry in
//                    RoundedRectangle(cornerRadius: 0.1 * min(geometry.size.height, geometry.size.width))
//                        .strokeBorder(style: StrokeStyle(lineWidth: 0.04 * min(geometry.size.height, geometry.size.width), dash: [0.1 * min(geometry.size.height, geometry.size.width), 0.1 * min(geometry.size.height, geometry.size.width)]))
//                        .foregroundColor(Color(UIColor.systemBackground))
//                }
//                Text("Deck is empty")
//                    .scaledToFill()
//                    .minimumScaleFactor(0.5)
//                    .lineLimit(2)
//                    .padding()
//            }
//            .zIndex(-1000)
            
        }
    }
    
    private func zIndex(for card: SetGame.Card) -> Double {
        let indexInDeck = cards.firstIndex(where: { $0 == card }) ?? 0
        return Double(indexInDeck) * (reverseOrder ? -1 : 1)
    }
}

//struct CardStackView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardStackView()
//    }
//}
