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
        HStack {
            Button("Deal 3 More Cards") {
                game.drawThreeCards()
            }
                .disabled(game.deckIsEmpty)
            Spacer()
            Button("New Game") {
                game.reset()
            }
        }
        .padding()
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
