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
            AspectVGrid(
                items: game.visibleCards,
                aspectRatio: DrawingConstants.cardAspectRatio,
                minItemWidth: DrawingConstants.minimumCardWidth,
                itemSpacing: DrawingConstants.cardPadding
            ) { cardView(for: $0, in: geometry) }
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
                Text("**Total matched cards:** \(game.totalMatchedCards)")
                    .padding()
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8.0))
        }
    }
    
    var deck: some View {
        ZStack {
            placeholderView(label: "Deck Empty")
            PileView(items: game.deck, reverseOrder: true) { card in
                CardView(
                    card: card,
                    cardBorderColor: DrawingConstants.CardBorderColors.any,
                    hasThickBorder: false,
                    isFaceUp: false
                )
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
            }
        }
        .frame(maxWidth: playCardSize?.width, maxHeight: playCardSize?.height)
    }
    
    var discardPile: some View {
        ZStack {
            placeholderView(label: "Discard")
            PileView(items: game.discardPile, reverseOrder: false) { card in
                CardView(
                    card: card,
                    cardBorderColor: DrawingConstants.CardBorderColors.any,
                    hasThickBorder: false
                )
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
            }
        }
        .frame(maxWidth: playCardSize?.width, maxHeight: playCardSize?.height)
    }
    
    private func cardView(for card: SetGame.Card, in geometry: GeometryProxy) -> some View {
        let selectionState = game.selectionState(for: card)
        return CardView(card: card, cardBorderColor: borderColor(in: selectionState), hasThickBorder: selectionState.inSelection)
            .anchorPreference(key: PlayCardSizePreferenceKey.self, value: .bounds, transform: { geometry[$0].size })
            .matchedGeometryEffect(id: card.id, in: discardNamespace)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .animation(.none, value: selectionState)
            .shakeEffect(direction: .horizontal, pct: selectionState == .partOfMismatch ? 1 : 0)
            .shakeEffect(direction: .vertical, pct: selectionState == .partOfMatch ? 1 : 0)
            // Using an implicit animation to separate the shakeEffect from the explicit animation that occurs
            // when a card is chosen. Making it conditional (where it can sometimes be .none) allows the
            // animation to become "one-way". The shake occurs when the selectionState becomes part of a match
            // or a mismatch, but not when the selectionState goes back to being any of the other cases.
            // The implicit animation above "resets" the wrapped view so that it doesn't cascade this implicit
            // animation to the wrapped views.
            .animation(
                selectionState == .partOfMatch || selectionState == .partOfMismatch ?
                    .linear(duration: 0.2).repeatCount(2, autoreverses: false) : .none,
                value: selectionState
            )
            .onTapGesture {
                withAnimation {
                    game.choose(card: card)
                }
            }
    }
    
    private func placeholderView(label: String? = nil) -> some View {
        GeometryReader { geometry in
            ZStack {
                let smallestDimension = min(geometry.size.height, geometry.size.width)
                let dashLength = smallestDimension * DrawingConstants.placeholderDashLengthRatio
                Text(label ?? "").opacity(label == nil ? 0 : 1)
                    .textCase(.uppercase)
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                RoundedRectangle(
                    cornerRadius: CardView.DrawingConstants.paperCornerRadiusRatio * smallestDimension
                )
                    .strokeBorder(style: StrokeStyle(
                        lineWidth: DrawingConstants.placeholderLineWidthRatio * smallestDimension,
                        dash: [dashLength, dashLength]
                    ))
            }
            .opacity(DrawingConstants.placeholderOpacity)
            .foregroundColor(Color(UIColor.systemBackground))
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
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
    
    private func borderColor(in selectionState: SetGame.CardSelectionState) -> Color {
        switch selectionState {
        case .unselected:
            return DrawingConstants.CardBorderColors.any
        case .partOfIncomplete:
            return DrawingConstants.CardBorderColors.selected
        case .partOfMismatch:
            return DrawingConstants.CardBorderColors.mismatchedSelection
        case .partOfMatch:
            return DrawingConstants.CardBorderColors.matchedSelection
        }
    }
    
    struct DrawingConstants {
        static let cardPadding: CGFloat = 8.0
        static let minimumCardWidth: CGFloat = 100.0
        static let cardAspectRatio: CGFloat = 2/1
        
        static let placeholderLineWidthRatio: CGFloat = 0.07
        static let placeholderDashLengthRatio: CGFloat = 0.1
        static let placeholderOpacity: Double = 0.5
        
        struct CardBorderColors {
            static let any: Color = .accentColor
            static let selected: Color = .yellow
            static let matchedSelection: Color = .orange
            static let mismatchedSelection: Color = .gray
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
