//
//  ContentView.swift
//  Set
//
//  Created by Ankur Oberoi on 8/6/21.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetGame
    
    // Every card is identifable and each card is only ever in the view heirarchy once. Therefore
    // we only need one namespace to track card movement.
    @Namespace private var cardMovement
    
    // MARK: - Views
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    playArea
                    endGame
                }
                    .frame(minHeight: geometry.size.height / 4 * 3)
                controls
                // It seems like there's no way to define a flexible frame with maxHeight and
                // hugging constraints that allow the frame to be smaller than the maxHeight.
                // Or, is it something about the controls view that makes this not work? Maybe if
                // the .infinity widths were lowered in priority somehow, the controls view would
                // just take the idealHeight instead of growing to be any bigger.
                // The following two attempts did not work:
                //    .frame(minHeight: 0, idealHeight: 0, maxHeight: geometry.size.height / 4, alignment: .bottom)
                //    .frame(idealHeight: geometry.size.height / 4, alignment: .bottom)
                    .layoutPriority(1)
            }
            .background(Color(UIColor.systemGray5))
            .onAppear(perform: dealInitialCards)
        }
    }
    
    private var playArea: some View {
        AspectVGrid(
            items: game.visibleCards,
            aspectRatio: DrawingConstants.cardAspectRatio,
            minItemWidth: DrawingConstants.minimumCardWidth,
            itemSpacing: DrawingConstants.cardPadding
        ) { card in
            cardView(for: card)
        }
    }
    
    private func cardView(for card: SetGame.Card) -> some View {
        let selectionState = game.selectionState(for: card)
        return CardView(
                card: card,
                cardBorderColor: borderColor(for: selectionState),
                hasThickBorder: selectionState.inSelection
        )
            .matchedGeometryEffect(id: card.id, in: cardMovement)
            .animation(.none, value: selectionState)
            .shakeEffect(direction: .horizontal, pct: selectionState == .partOfMismatch ? 1 : 0)
            .shakeEffect(direction: .vertical, pct: selectionState == .partOfMatch ? 1 : 0)
            // Using an implicit animation to separate the shakeEffect from the explicit animation
            // that occurs when a card is chosen. Making it conditional (where it can sometimes be
            // .none) allows the animation to become "one-way". The shake occurs when the
            // selectionState becomes part of a match or a mismatch, but not when the selectionState
            // goes back to being any of the other cases. The implicit animation above "resets" the
            // wrapped view so that it doesn't cascade this implicit animation to the wrapped views.
            .animation(
                selectionState == .partOfMatch || selectionState == .partOfMismatch ?
                    .linear(duration: 0.2).repeatCount(2, autoreverses: false) : .none,
                value: selectionState
            )
            .onTapGesture(perform: choose(card))
    }
    
    @ViewBuilder
    private var endGame: some View {
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
    
    var controls: some View {
        HStack {
            deck.onTapGesture(perform: drawMoreCards)
                .frame(maxWidth: .infinity)
            Button("New Game", action: newGame)
                .frame(maxWidth: .infinity)
            discardPile
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color("FeltGreen"))
        .foregroundColor(.white)
    }
    
    var deck: some View {
        ZStack {
            placeholderView(label: "Deck Empty")
            PileView(items: game.deck) { card in
                CardView(
                    card: card,
                    cardBorderColor: DrawingConstants.CardBorderColors.any,
                    hasThickBorder: false,
                    isFaceUp: false
                )
                    .matchedGeometryEffect(id: card.id, in: cardMovement)
            }
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
    }
    
    var discardPile: some View {
        ZStack {
            placeholderView(label: "Discard")
            PileView(items: game.discardPile.reversed()) { card in
                CardView(
                    card: card,
                    cardBorderColor: DrawingConstants.CardBorderColors.any,
                    hasThickBorder: false
                )
                    .matchedGeometryEffect(id: card.id, in: cardMovement)
            }
        }
        .aspectRatio(DrawingConstants.cardAspectRatio, contentMode: .fit)
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
    }
    
    // MARK: - Actions
    
    private func dealInitialCards() {
        withAnimation(groupOfCards()) {
            game.start()
        }
    }
    
    private func newGame() {
        print("BEFORE RESET:")
        game.printGame()
        withAnimation(groupOfCards()) {
            game.reset()
        }
        print("AFTER RESET, BEFORE START:")
        game.printGame()
        withAnimation(groupOfCards(afterGroups: 1)) {
            game.start()
        }
        print("AFTER START:")
        game.printGame()
    }
    
    private func drawMoreCards() {
        let willDiscard = game.matchIsSelected
        withAnimation(groupOfCards()) {
            game.discardPotentialMatch()
        }
        withAnimation(
            groupOfCards().delay(willDiscard ? AnimationConstants.concurrentMoveDelay : 0)
        ) {
            game.draw()
        }
    }
    
    private func choose(_ card: SetGame.Card) -> (() -> Void) {
        // TODO: do i need to capture a weak self? is there a possible memory cycle? how does this
        // interact with @escaping?
        return {
            withAnimation(groupOfCards()) {
                game.choose(card: card)
            }
        }
    }
    
    // MARK: - Helpers

    private func borderColor(for selectionState: SetGame.CardSelectionState) -> Color {
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
    
    private func groupOfCards(afterGroups: Int = 0) -> Animation {
        Animation
            .easeInOut(duration: AnimationConstants.moveGroupOfCardsDuration)
            .delay(Double(afterGroups) * AnimationConstants.moveGroupOfCardsDuration)
    }
    
    // TODO: use this method to build dealing animations that move individual cards at a time
    private func dealingAnimation(for index: Int) -> Animation {
        let delay = AnimationConstants.dealDelayPerCard * Double(index)
        return Animation.easeInOut(duration: AnimationConstants.dealACardDuration).delay(delay)
    }

    struct AnimationConstants {
        static let moveGroupOfCardsDuration: Double = 1.0
        static let concurrentMoveDelay: Double = 0.5
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
