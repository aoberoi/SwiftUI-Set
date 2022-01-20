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
    @Namespace private var dealingNamespace
    @Namespace private var discardNamespace
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                playArea
                endGame
            }
            controls
        }
        .background(Color(UIColor.systemGray5))
        .onAppear {
            dealInitialCards()
        }
    }
    
    var controls: some View {
        HStack {
            deck.onTapGesture {
                var delay: Double = 0
                if game.matchIsSelected {
                    // TODO: factor out this constant
                    delay += 0.15
                    withAnimation {
                        game.discardPotentialMatch()
                    }
                }
                withAnimation(.easeInOut.delay(delay)) {
                    game.draw()
                }
            }
            .frame(maxWidth: .infinity)
            Button("New Game") {
                withAnimation {
                    game.reset()
                }
                // TODO: factor out this constant
                withAnimation(.easeInOut.delay(1.0)) {
                    dealInitialCards()
                }
            }
            .frame(maxWidth: .infinity)
            discardPile
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color("FeltGreen"))
        .foregroundColor(.white)
    }
    
    var playArea: some View {
        GeometryReader { geometry in
            AspectVGrid(items: game.visibleCards, aspectRatio: DrawingConstants.cardAspectRatio, minItemWidth: DrawingConstants.minimumCardWidth) { card in
                CardView(card: card, cardBorderColor: borderColor(for: card), hasThickBorder: game.isSelected(card: card))
                    .anchorPreference(key: PlayCardSizePreferenceKey.self, value: .bounds, transform: { geometry[$0].size })
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .onTapGesture {
                        withAnimation {
                            game.choose(card: card)
                        }
                    }
                    .padding(DrawingConstants.cardPadding)
            }
            .onPreferenceChange(PlayCardSizePreferenceKey.self) { playCardSize = $0 }
        }
    }
    
    @ViewBuilder
    var endGame: some View {
        if game.isOver {
            VStack {
                Text("Game Over")
                    .font(.title)
                    .padding()
                Text("**Total matched sets:** \(game.totalMatchedSets)")
                    .padding()
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8.0))
        }
    }
    
    @ViewBuilder
    var deck: some View {
        // TODO: this shares quite a bit with the matchedCards, and potentially can be abstracted into a separate view
        ZStack {
            ForEach(game.deck) { card in
                CardView(
                    card: card,
                    cardBorderColor: DrawingConstants.CardBorderColors.any,
                    hasThickBorder: false,
                    isFaceUp: false
                )
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .zIndex(zIndex(for: card))
            }
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
        .frame(maxWidth: playCardSize?.width, maxHeight: playCardSize?.height)
    }
    
    @ViewBuilder
    var discardPile: some View {
        ZStack {
            ForEach(game.discardPile) { card in
                CardView(card: card,
                         cardBorderColor: DrawingConstants.CardBorderColors.any,
                         hasThickBorder: false)
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
            }
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
        .frame(maxWidth: playCardSize?.width, maxHeight: playCardSize?.height)
    }
    
    private func dealInitialCards() {
//        game.start { index, dealACard in
//            withAnimation(dealingAnimation(for: index)) {
//                dealACard()
//            }
//        }
        // TODO: move this constant out
        withAnimation(.easeInOut(duration: 0.7)) {
            game.start()
        }
    }
    
    private func dealingAnimation(for index: Int) -> Animation {
        let delay = AnimationConstants.dealDelayPerCard * Double(index)
        return Animation.easeInOut(duration: AnimationConstants.dealACardDuration).delay(delay)
    }
    
    private func zIndex(for card: SetGame.Card) -> Double {
        let indexInDeck = game.deck.firstIndex(where: { $0 == card }) ?? 0
        return -Double(indexInDeck)
    }
    
    private func borderColor(for card: SetGame.Card) -> Color {
        if game.isSelected(card: card) {
            if game.matchIsSelected {
                return DrawingConstants.CardBorderColors.matchedSelection
            } else if game.numberOfSelectedCards == 3 {
                return DrawingConstants.CardBorderColors.unmatchedSelection
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
            static let matchedSelection: Color = .red
            static let unmatchedSelection: Color = .gray
        }
    }
    
    struct AnimationConstants {
        static let dealACardDuration: Double = 0.25
        static let dealDelayPerCard: Double = 0.25
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
