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
            // TODO: eliminate the redundant call
            CardView(card: card, cardEdgeColor: styleForCard(card: card).0, hasThickEdge: styleForCard(card: card).1)
            // TODO: use .contentShape() to make hit testing on taps recognize the whitespace within a card OR give the card backgrounds (for light and dark)
                .padding(DrawingConstants.cardPadding)
                .onTapGesture {
                    game.choose(card: card)
                }
        }
    }
    
    private func styleForCard(card: SetGame.Card) -> (Color, Bool) {
        if game.isSelected(card: card) {
            if game.matchIsSelected {
                return (DrawingConstants.CardEdgeColors.matchedSet, true)
            } else if game.numberOfSelectedCards == 3 {
                return (DrawingConstants.CardEdgeColors.unmatchedSet, true)
            } else {
                return (DrawingConstants.CardEdgeColors.selected, true)
            }
        } else {
            return (DrawingConstants.CardEdgeColors.any, false)
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
