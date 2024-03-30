//
//  CardView.swift
//  Set
//
//  Created by Ankur Oberoi on 3/14/24.
//

import SwiftUI

/// The view of a card
///
/// For layout, this view takes up all the space offered both horizontally and vertically. In the overall app, AspectVGrid controls the
/// aspect ratio of each card, and keeps them all consistent. NOTE: AspectVGrid might be refactored to be implemented with
/// the new Grid view. This could impact how aspect ratios are enforced.
struct CardView: View {
    
    let card: SetGame.Card
    let borderColor: Color
    let hasThickBorder: Bool
    var isFaceUp = true
  
    var body: some View {
        GeometryReader { geometry in
            let shortestDimensionLength = min(geometry.size.height, geometry.size.width)
            ZStack {
                CardBackground(shortestDimensionLength: shortestDimensionLength, borderColor: borderColor)
                
                if isFaceUp {
                    let symbolsAreaPadding = shortestDimensionLength * DrawingConstants.symbolsPaddingProportion
                    CardSymbols(card, spacing: symbolsAreaPadding / 2)
                        .padding(symbolsAreaPadding)
                } else {
                    let cardBackAreaPadding = shortestDimensionLength * DrawingConstants.cardBackImagePaddingProportion
                    cardBackImage
                        .padding(cardBackAreaPadding)
                }
            }
        }
    }
    
    private var cardBackImage: some View {
        Rectangle()
            .foregroundColor(.accentColor)
    }
    
    struct DrawingConstants {
        // The proportion of the length of the shortest dimension of the card to the distance
        // between the edge of the card and the card back image.
        static let cardBackImagePaddingProportion: CGFloat = 10 / 100

        // The proportion of the length of the shortest dimension of the card to the distance
        // between the edge of the card and the symbols on the card front.
        static let symbolsPaddingProportion: CGFloat = 20 / 100

        static let stripedOpacity: Double = 0.5
        static let openSymbolLineWidthRatio: CGFloat  = 0.05
    }
}

// TODO: Do we need a preview?
//#Preview {
//    CardView()
//}
