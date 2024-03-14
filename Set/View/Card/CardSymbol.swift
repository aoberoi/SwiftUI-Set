//
//  CardSymbol.swift
//  Set
//
//  Created by Ankur Oberoi on 3/14/24.
//

import SwiftUI

struct CardSymbol<ShapeType : InsettableShape>: View {
    let shape: ShapeType
    let color: TriState
    let shading: TriState
    
    var body: some View {
        GeometryReader { geometry in
            shadedShape(in: geometry.size)
                .foregroundStyle(shadingColor)
        }
        
    }

    @ViewBuilder
    private func shadedShape(in size: CGSize) -> some View {
        switch shading {
        // Solid
        case .first: shape
        // Striped
        // TODO: use a ShapeStyle to actually produce a striped fill, instead of a lower opacity
        case .second: shape.opacity(stripedOpacity)
        // Open
        // strokeBorder() is only available on InsettableShape
        case .third: shape.strokeBorder(lineWidth: openSymbolLineWidth(in: size))
        }
    }
    
    private var shadingColor: Color {
        return switch color {
        case .first: .red
        case .second: .green
        case .third: .purple
        }
    }
    
    // TODO: Is there a better way to store static properties on a generic type?
    // Maybe this doesn't need to be a generic type if we can use some just in the initializer?
    
    private let stripedOpacity: Double = 0.5
    
    // NOTE: There is a bug when stroking a Capsule at certain lineWidths, where four notches may
    // appear. Feedback filed: https://feedbackassistant.apple.com/feedback/13329220
    private let openSymbolLineWidthRatio: CGFloat  = 0.15
    
    private func openSymbolLineWidth(in size: CGSize) -> CGFloat {
        let shortestDimensionLength = min(size.height, size.width)
        return max(openSymbolLineWidthRatio * shortestDimensionLength, 2.0)
    }
}

#Preview {
    CardSymbol(
        shape: Capsule(),
        color: .first,
        shading: .third
    )
}
