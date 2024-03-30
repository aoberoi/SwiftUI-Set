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
        VerticalSplitWithHeightLimitOnLower(
            upper: ZStack {
                playArea
                endGame
            },
            lower:
                ControlsView(
                    cardFlyingAnimation: AnimationConstants.cardFlyingAnimation,
                    cardFlyingDuration: AnimationConstants.cardFlyingDuration,
                    cardAspectRatio: DrawingConstants.cardAspectRatio,
                    // TODO: A function in the environment to find the border color for a card?
                    cardBorderColor: DrawingConstants.CardBorderColors.any
                ),
            lowerMaxProportionOfHeight: DrawingConstants.maxProportionOfControlsHeight
        )
        .cardMovementNamespace(cardMovement)
        .onAppear {
            withAnimation(AnimationConstants.cardFlyingAnimation) {
                game.start()
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
        .background(.neutralBackground)
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
            .onTapGesture {
                withAnimation(AnimationConstants.cardFlyingAnimation) {
                    game.choose(card: card)
                }
            }
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
        static let maxProportionOfControlsHeight: Double = 1/4
        
        struct CardBorderColors {
            static let any: Color = .accentColor
            static let selected: Color = .yellow
            static let matchedSelection: Color = .orange
            static let mismatchedSelection: Color = .gray
        }
    }
    
    struct AnimationConstants {
        // NOTE: Defining both of these constants is not optimal. They are separated in order
        // to implement staged/chained animations in an ad-hoc manner (see ControlView). These
        // chained animations could be cleaner, and allow for more dynamic situations (such as a
        // group of cards flying in a staggered way) using custom animations. Also worth
        // investigating phaseAnimator or keyframeAnimator.
        static let cardFlyingDuration: Double = 1.0
        static let cardFlyingAnimation: Animation = .easeInOut(duration: cardFlyingDuration)
    }
}

#Preview {
    SetGameView()
        .environment(SetGame())
}
