//
//  ContentView.swift
//  Set
//
//  Created by Ankur Oberoi on 8/6/21.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGame
    
    var body: some View {
        VStack {
            playArea
            Spacer()
            controls
        }
    }
    
    var controls: some View {
        // TODO: this looks really weird when the device is horozontal
        HStack {
            deck
                .onTapGesture {
                    game.draw()
                }
            Button("New Game") {
                game.reset()
            }
            matchedCards
            
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    var matchedCards: some View {
        if game.hasNoMatchedCards {
            Color.clear
                .aspectRatio(2/1, contentMode: .fit)
        } else {
            ZStack {
                ForEach(game.matchedCards) { card in
                    CardView(card: card,
                             cardEdgeColor: DrawingConstants.CardEdgeColors.any,
                             hasThickEdge: false)
                }
            }
            .aspectRatio(2/1, contentMode: .fit)
        }
    }
    
    @ViewBuilder
    var deck: some View {
        // TODO: dry up the aspect ratio modifier code, move constant
        if game.deckIsEmpty {
            Rectangle()
                .aspectRatio(2/1, contentMode: .fit)

        } else {
            ZStack {
                ForEach(game.deck) { card in
                    CardView(
                        card: card,
                        cardEdgeColor: DrawingConstants.CardEdgeColors.any,
                        hasThickEdge: false,
                        isFaceUp: false
                    )
                }
            }
            .aspectRatio(2/1, contentMode: .fit)

        }
    }
    
    var playArea: some View {
        AspectVGrid(items: game.drawnCards, aspectRatio: 2/1, minItemWidth: DrawingConstants.minimumCardWidth) { card in
            CardView(card: card, cardEdgeColor: edgeColor(for: card), hasThickEdge: game.isSelected(card: card))
                .padding(DrawingConstants.cardPadding)
                .onTapGesture {
                    game.choose(card: card)
                }
        }
    }
    
    private func edgeColor(for card: SetGame.Card) -> Color {
        if game.isSelected(card: card) {
            if game.matchIsSelected {
                return DrawingConstants.CardEdgeColors.matchedSet
            } else if game.numberOfSelectedCards == 3 {
                return DrawingConstants.CardEdgeColors.unmatchedSet
            } else {
                return DrawingConstants.CardEdgeColors.selected
            }
        } else {
            return DrawingConstants.CardEdgeColors.any
        }
    }
    
    struct DrawingConstants {
        static let cardPadding: CGFloat = 8.0
        static let minimumCardWidth: CGFloat = 110.0
        
        struct CardEdgeColors {
            static let any: Color = .orange
            static let selected: Color = .yellow
            static let matchedSet: Color = .red
            static let unmatchedSet: Color = .gray
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        return SetGameView(game: game)
    }
}
