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
            deck.onTapGesture {
                game.draw()
            }
            Button("New Game") {
                game.reset()
            }
            matchedCards
        }
        .padding()
        .background(Color("FeltGreen"))
        .foregroundColor(Color.white)
    }
    
    var playArea: some View {
        AspectVGrid(items: game.drawnCards, aspectRatio: DrawingConstants.cardAspectRatio, minItemWidth: DrawingConstants.minimumCardWidth) { card in
            CardView(card: card, cardEdgeColor: edgeColor(for: card), hasThickEdge: game.isSelected(card: card))
                .padding(DrawingConstants.cardPadding)
                .onTapGesture {
                    game.choose(card: card)
                }
        }
    }
    
    
    @ViewBuilder
    var deck: some View {
        // TODO: this shares quite a bit with the matchedCards, and potentially can be abstracted into a separate view
        Group {
            if game.deckIsEmpty {
                Color.clear
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
            }
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
    }
    
    @ViewBuilder
    var matchedCards: some View {
        Group {
            if game.hasNoMatchedCards {
                Color.clear
            } else {
                ZStack {
                    ForEach(game.matchedCards) { card in
                        CardView(card: card,
                                 cardEdgeColor: DrawingConstants.CardEdgeColors.any,
                                 hasThickEdge: false)
                    }
                }
            }
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
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
        static let cardAspectRatio: CGFloat = 2/1
        
        struct CardEdgeColors {
            static let any: Color = .accentColor
            static let selected: Color = .yellow
            static let matchedSet: Color = .red
            static let unmatchedSet: Color = .gray
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        return Group {
            SetGameView(game: game)
            SetGameView(game: game)
                .previewInterfaceOrientation(InterfaceOrientation.landscapeLeft)
        }
    }
}
