//
//  CardPlaceholder.swift
//  Set
//
//  Created by Ankur Oberoi on 3/14/24.
//

import SwiftUI

struct CardPlaceholder: View {
    let label: String?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let smallestDimension = min(geometry.size.height, geometry.size.width)
                let dashLength = smallestDimension * DrawingConstants.dashLengthRatio
                Text(label ?? "").opacity(label == nil ? 0 : 1)
                    .textCase(.uppercase)
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                RoundedRectangle(
                    cornerRadius: smallestDimension * DrawingConstants.cornerRadiusProportion
                )
                    .strokeBorder(style: StrokeStyle(
                        lineWidth: DrawingConstants.lineWidthRatio * smallestDimension,
                        dash: [dashLength, dashLength]
                    ))
            }
            .opacity(DrawingConstants.opacity)
            .foregroundColor(Color(UIColor.systemBackground))
        }
    }
    
    struct DrawingConstants {
        static let lineWidthRatio: CGFloat = 0.07
        static let dashLengthRatio: CGFloat = 0.1
        static let opacity: Double = 0.5
        
        // The proportion of the length of the shortest dimension of the card to the corner radius
        // of the dashed line. This is identical to
        // CardBackground.DrawingConstants.cornerRadiusProportion.
        static let cornerRadiusProportion: CGFloat = 10 / 100
    }
}

#Preview {
    CardPlaceholder(
        label: "Test"
    )
}
