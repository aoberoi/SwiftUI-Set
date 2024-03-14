//
//  CardBackground.swift
//  Set
//
//  Created by Ankur Oberoi on 3/14/24.
//

import SwiftUI

/// The part of a CardView which encapsulates the layers that stay the same across the back and front, specifically the background
/// paper, and a thin rounded border line that is within the paper. The line's rounded corners are concentric with the paper's rounded
/// corners.
struct CardBackground: View {
    var shortestDimensionLength: CGFloat
    var borderColor: Color

    var body: some View {
        let cardCornerRadius = shortestDimensionLength * DrawingConstants.cornerRadiusProportion
        let borderCornerRadius = cardCornerRadius * DrawingConstants.borderPlacementProportion
        let borderLineWidth = max(DrawingConstants.borderLineWidthProportion * shortestDimensionLength, 1.0)
        let borderPadding = cardCornerRadius - borderCornerRadius

        ZStack {
            // Paper
            RoundedRectangle(cornerRadius: cardCornerRadius)
                // TODO: Is systemBackground the right environment property to receive the paper color?
                .fill(Color(uiColor: .systemBackground))
            // Border
            RoundedRectangle(cornerRadius: borderCornerRadius)
                .strokeBorder(borderColor, lineWidth: borderLineWidth)
                .padding(borderPadding)
        }
    }

    struct DrawingConstants {
        // The proportion of the length of the shortest dimension of the card to the corner radius
        // of the card
        static let cornerRadiusProportion: CGFloat = 10 / 100

        // The placement of the rounded border line, which is concentrically aligned with the corner
        // radius
        static let borderPlacementProportion: CGFloat = 50 / 100

        // The proportion of the length of the shortest dimension of the card to the line width of
        // the card
        static let borderLineWidthProportion: CGFloat = 2 / 100
    }
}

// TODO: Do we need a preview?
//#Preview {
//    CardBackground()
//}
