//
//  ContentView.swift
//  Set
//
//  Created by Ankur Oberoi on 8/6/21.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGame
    
    @State private var playCardSize: CGSize?
    
    var body: some View {
        VStack(spacing: 0) {
            playArea
            controls
        }
        .background(Color(UIColor.systemGray5))
    }
    
    var controls: some View {
        HStack {
            deck.onTapGesture {
                game.draw()
            }
            .frame(maxWidth: .infinity)
            Button("New Game") {
                game.reset()
            }
            .frame(maxWidth: .infinity)
            matchedCards
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color("FeltGreen"))
        .foregroundColor(.white)
    }
    
    var playArea: some View {
        GeometryReader { geometry in
            AspectVGrid(items: game.drawnCards, aspectRatio: DrawingConstants.cardAspectRatio, minItemWidth: DrawingConstants.minimumCardWidth) { card in
                CardView(card: card, cardBorderColor: borderColor(for: card), hasThickBorder: game.isSelected(card: card))
                    .anchorPreference(key: PlayCardSizePreferenceKey.self, value: .bounds, transform: { $0 })
//                  .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.1), radius: 2.0, y: 2.0)
                    .padding(DrawingConstants.cardPadding)
                    .onTapGesture {
                        game.choose(card: card)
                    }
            }
            .onPreferenceChange(PlayCardSizePreferenceKey.self) { anchor in
                updatePlayCardSize(in: geometry, with: anchor)
            }
        }
    }
    
    func updatePlayCardSize(in geometry:GeometryProxy, with anchor:Anchor<CGRect>?) {
        if let anchor = anchor {
            self.playCardSize = geometry[anchor].size
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
                            cardBorderColor: DrawingConstants.CardBorderColors.any,
                            hasThickBorder: false,
                            isFaceUp: false
                        )
                    }
                }
            }
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
        .frame(maxWidth: playCardSize?.width, maxHeight: playCardSize?.height)
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
                                 cardBorderColor: DrawingConstants.CardBorderColors.any,
                                 hasThickBorder: false)
                    }
                }
            }
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
        .frame(maxWidth: playCardSize?.width, maxHeight: playCardSize?.height)
    }
    
    private func borderColor(for card: SetGame.Card) -> Color {
        if game.isSelected(card: card) {
            if game.matchIsSelected {
                return DrawingConstants.CardBorderColors.matchedSet
            } else if game.numberOfSelectedCards == 3 {
                return DrawingConstants.CardBorderColors.unmatchedSet
            } else {
                return DrawingConstants.CardBorderColors.selected
            }
        } else {
            return DrawingConstants.CardBorderColors.any
        }
    }
    
    struct DrawingConstants {
        static let cardPadding: CGFloat = 8.0
        static let minimumCardWidth: CGFloat = 110.0
        static let cardAspectRatio: CGFloat = 2/1
        
        struct CardBorderColors {
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
