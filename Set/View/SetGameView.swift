//
//  SetGameView.swift
//  Set
//
//  Created by Ankur Oberoi on 3/9/24.
//

import SwiftUI

struct SetGameView: View {
    @Environment(SetGame.self) private var game
    
    // Every card is identifiable and each card is only ever in the view hierarchy once. Therefore
    // we only need one namespace to track card movement.
    @Namespace private var cardMovement
    
    // MARK: - Views
    
    var body: some View {
        GeometryReader { geometry in
            // NOTE: The layout intention is to set a maxHeight on controls of 1/4 the available
            // height (while allowing it to take less based on its own contents). The ZStack sibling
            // would take the remaining height. However, the .frame(maxHeight:alignment:) modifier
            // does not work this way. The modifier limits the height proposed to controls, but then
            // takes up the remaining space up to that maxHeight anyway. This implementation
            // achieves the same result, but with a less clear expression.
            // TODO: wrap up the above behavior into a generic view
            VStack(spacing: 0) {
                ZStack {
                    playArea
                    endGame
                }
                    .frame(minHeight: geometry.size.height * (3 / 4))
                // TODO: can some of these be passed through the environment?
                ControlsView(
                    // TODO: maybe the drawCardsAnimation should be stored and passed in instead of
                    // just a duration. All of the other durations are the same, so the animations
                    // can all be the same. Also, maybe these can be read through the environment?
                    // Can the ControlsView supply its own defaultValue? If so, this would be useful
                    // in other cases (like the Namespace.ID issue).
                    drawCardsDuration: AnimationConstants.drawCardsDuration,
                    resetCardsDuration: AnimationConstants.resetCardsDuration,
                    discardCardsDuration: AnimationConstants.discardCardsDuration,
                    cardAspectRatio: DrawingConstants.cardAspectRatio,
                    cardBorderColor: DrawingConstants.CardBorderColors.any
                )
                    .layoutPriority(1)
            }
            .cardMovementNamespace(cardMovement)
            .onAppear {
                withAnimation(.easeInOut(duration: AnimationConstants.drawCardsDuration)) {
                    game.start()
                }
            }
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
        .background(DrawingConstants.playAreaBackgroundColor)
    }
    
    private func cardView(for card: SetGame.Card) -> some View {
        let selectionState = game.selectionState(for: card)
        return CardView(
                card: card,
                borderColor: borderColor(for: selectionState),
                hasThickBorder: selectionState.inSelection
        )
            .matchedGeometryEffect(id: card.id, in: cardMovement)
            .animation(.none, value: selectionState)
            // TODO: Should we use the new phaseAnimator or keyframeAnimator to accomplish this?
            // TODO: Should we use the new scoped implicit animation view modifiers?
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
        // TODO: is there a sheet view that makes more sense here?
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

    // MARK: - Actions
    
    private func choose(_ card: SetGame.Card) -> (() -> Void) {
        // TODO: SECOND do i need to capture a weak self? is there a possible memory cycle? how does this
        // interact with @escaping?
        return {
            withAnimation(.easeInOut(duration: AnimationConstants.discardCardsDuration)) {
                game.choose(card: card)
            }
        }
    }
    
    // MARK: - Helpers

    // TODO: Does this belong in the ViewModel?
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
        // The systemGray UIColors do adjust for light mode and dark mode.
        // TODO: does it make sense to put these in the asset catalog?
        static let playAreaBackgroundColor: Color = Color(UIColor.systemGray5)
        
        static let cardPadding: CGFloat = 8.0
        static let minimumCardWidth: CGFloat = 100.0
        static let cardAspectRatio: CGFloat = 2/1
        
        struct CardBorderColors {
            static let any: Color = .accentColor
            static let selected: Color = .yellow
            static let matchedSelection: Color = .orange
            static let mismatchedSelection: Color = .gray
        }
    }
    
    // TODO: BEFORE DRAWING CONSTANTS use this method to build dealing animations that move
    // individual cards at a time. Can this be done with a custom animation?? Maybe a phase animator
    // because it can iterate over a sequence?
//    private func dealingAnimation(for index: Int) -> Animation {
//        let delay = AnimationConstants.dealDelayPerCard * Double(index)
//        return Animation.easeInOut(duration: AnimationConstants.dealACardDuration).delay(delay)
//    }
//
    struct AnimationConstants {
        static let drawCardsDuration: Double = 1.0
        static let resetCardsDuration: Double = 1.0
        static let discardCardsDuration: Double = 1.0
    }
}

#Preview {
    SetGameView()
        .environment(SetGame())
}
