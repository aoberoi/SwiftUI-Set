//
//  CardView.swift
//  Set
//
//  Created by Ankur Oberoi on 8/8/21.
//

import SwiftUI

struct CardView: View {
    let card: SetGame.Card
    let cardEdgeColor: Color
    let hasThickEdge: Bool
  
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                border(for: geometry.size)
                symbols(for: geometry.size)
            }
            .contentShape(RoundedRectangle(cornerRadius: cardCornerRadius(for: geometry.size)))
        }
    }
    
    @ViewBuilder
    private func border(for size: CGSize) -> some View {
        RoundedRectangle(cornerRadius: cardCornerRadius(for: size))
            .strokeBorder(
                cardEdgeColor,
                style: StrokeStyle(lineWidth: edgeLineWidth(for: size))
            )
    }
    
    @ViewBuilder
    private func symbols(for size: CGSize) -> some View {
        if size.isNotWiderThanTall {
            // Vertically stacked card symbols
            VStack(spacing: DrawingConstants.symbolSpacingRatio * size.height) {
                ForEach(0..<numberOfSymbols) {_ in
                    symbol(for: size)
                        .frame(maxHeight: symbolLength(for: size.height))
                }
            }.padding(symbolPadding(for: size))
        } else {
            // Horizontally stacked card symbols
            HStack(spacing: DrawingConstants.symbolSpacingRatio * size.width) {
                ForEach(0..<numberOfSymbols) {_ in
                    symbol(for: size)
                        .frame(maxWidth: symbolLength(for: size.width))
                }
            }.padding(symbolPadding(for: size))
        }
    }
    
    @ViewBuilder
    private func symbol(for size: CGSize) -> some View {
        Group {
            switch card.shading {
            case .first:
                solidSymbol
            case .second:
                stripedSymbol
            case .third:
                openSymbol(for: size)
            }
        }.foregroundColor(symbolColor)
    }
    
    @ViewBuilder
    private var solidSymbol: some View {
        switch card.symbol {
        case .first:
            Diamond()
        case .second:
            Rectangle()
        case .third:
            Capsule()
        }
    }
    
    @ViewBuilder
    private var stripedSymbol: some View {
        solidSymbol
            .opacity(DrawingConstants.stripedOpacity)
    }
    
    @ViewBuilder
    private func openSymbol(for size: CGSize) -> some View {
        let lineWidth = openSymbolLineWidth(for: size)
        switch card.symbol {
        case .first:
            Diamond().strokeBorder(lineWidth: lineWidth)
        case .second:
            Rectangle().strokeBorder(lineWidth: lineWidth)
        case .third:
            Capsule().strokeBorder(lineWidth: lineWidth)
        }
    }
    
    private var symbolColor: Color {
        switch card.color {
        case .first:
            return .red
        case .second:
            return .green
        case .third:
            return .purple
        }
    }
    
    
    private var numberOfSymbols: Int {
        switch card.cardinaity {
        case .first:
            return 1
        case .second:
            return 2
        case .third:
            return 3
        }
    }
    
    private func cardCornerRadius(for size:CGSize) -> CGFloat {
        let shortestDimension = min(size.height, size.width)
        return DrawingConstants.cardCornerRadiusRatio * shortestDimension
    }
    
    private func edgeLineWidth(for size:CGSize) -> CGFloat {
        let shortestDimension = min(size.height, size.width)
        let ratio = hasThickEdge ? DrawingConstants.thickEdgeLineWidthRatio : DrawingConstants.thinEdgeLineWidthRatio
        return max(ratio * shortestDimension, 1.0)
    }
    
    private func symbolPadding(for size:CGSize) -> CGFloat {
        let longestDimension = max(size.height, size.width)
        return DrawingConstants.symbolPaddingRatio * longestDimension
    }
    
    private func openSymbolLineWidth(for size: CGSize) -> CGFloat {
        let shortestDimension = min(size.height, size.width)
        return max(DrawingConstants.openLineWidthRatio * shortestDimension, 2.0)
    }
    
    private func symbolLength(for longestDimensionLength: CGFloat) -> CGFloat {
        let padding = 2 * DrawingConstants.symbolPaddingRatio * longestDimensionLength
        let maximumSpacing = 2 * DrawingConstants.symbolSpacingRatio * longestDimensionLength
        return (longestDimensionLength - padding - maximumSpacing) / 3
    }
    
    private struct DrawingConstants {
        static let cardCornerRadiusRatio: CGFloat = 0.05
        
        static let thinEdgeLineWidthRatio: CGFloat = 0.02
        static let thickEdgeLineWidthRatio: CGFloat = 0.05

        static let symbolPaddingRatio: CGFloat = 0.08
        static let symbolSpacingRatio: CGFloat = 0.08
        
        static let stripedOpacity: Double = 0.5

        static let openLineWidthRatio: CGFloat  = 0.05
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = SetGame.Card(
            cardinaity: .third,
            color: .second,
            symbol: .first,
            shading: .third
        )
        return Group {
            CardView(card: card, cardEdgeColor: .orange, hasThickEdge: false)
                .previewDisplayName("Tall")
                .previewLayout(.sizeThatFits)
            CardView(card: card, cardEdgeColor: .orange, hasThickEdge: false)
                .frame(width: 400, height: 400, alignment: .center)
                .previewDisplayName("Square")
                .previewLayout(.sizeThatFits)
            CardView(card: card, cardEdgeColor: .orange, hasThickEdge: false)
                .frame(width: 600, height: 300, alignment: .center)
                .previewDisplayName("Wide")
                .previewLayout(.sizeThatFits)
            CardView(card: card, cardEdgeColor: .orange, hasThickEdge: false)
                .frame(width: 25, height: 70, alignment: .center)
                .previewDisplayName("Tall and small")
                .previewLayout(.sizeThatFits)
            CardView(card: card, cardEdgeColor: .orange, hasThickEdge: false)
                .frame(width: 70, height: 25, alignment: .center)
                .previewDisplayName("Wide and small")
                .previewLayout(.sizeThatFits)
        }
    }
}

extension CGSize {
    var isNotWiderThanTall: Bool {
        height - width >= 0
    }
}
