//
//  CardView.swift
//  Set
//
//  Created by Ankur Oberoi on 8/8/21.
//

import SwiftUI

struct CardView: View {
    let card: SetGame.Card
    let cardBorderColor: Color
    let hasThickBorder: Bool
    let isFaceUp: Bool
    
    init(card: SetGame.Card, cardBorderColor: Color, hasThickBorder: Bool, isFaceUp: Bool = true) {
        self.card = card
        self.cardBorderColor = cardBorderColor
        self.hasThickBorder = hasThickBorder
        self.isFaceUp = isFaceUp
    }
  
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                paper(for: geometry.size)
                border(for: geometry.size)
                symbols(for: geometry.size)
                    .opacity(isFaceUp ? 1 : 0)
                cardBack(for: geometry.size)
                    .opacity(isFaceUp ? 0 : 1)
            }
        }
    }
    
    private func paper(for size: CGSize) -> some View {
        RoundedRectangle(cornerRadius: paperCornerRadius(for: size))
            .fill()
            .foregroundColor(Color(UIColor.systemBackground))
    }
    
    private func border(for size: CGSize) -> some View {
        RoundedRectangle(cornerRadius: borderCornerRadius(for: size))
            .strokeBorder(cardBorderColor, lineWidth: borderLineWidth(for: size))
            .padding(borderPadding(for: size))
    }
    
    @ViewBuilder
    private func symbols(for size: CGSize) -> some View {
        if size.isNotWiderThanTall {
            // Vertically stacked card symbols
            VStack(spacing: symbolSpacing(for: size)) {
                ForEach(0..<numberOfSymbols, id: \.self) {_ in
                    symbol(for: size)
                }
            }.padding(symbolSpacing(for: size) * 2)
                
        } else {
            // Horizontally stacked card symbols
            HStack(spacing: symbolSpacing(for: size)) {
                ForEach(0..<numberOfSymbols, id: \.self) {_ in
                    symbol(for: size)
                }
            }.padding(symbolSpacing(for: size) * 2)
                
        }
    }
    
    @ViewBuilder
    private func symbol(for size: CGSize) -> some View {
        let symbolSize = symbolSize(for: size)
        Group {
            switch card.shading {
            case .first:
                solidSymbol
            case .second:
                stripedSymbol
            case .third:
                openSymbol(for: size)
            }
        }
        .frame(maxWidth: symbolSize.width, maxHeight: symbolSize.height)
        .foregroundColor(symbolColor)
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
    
    private func cardBack(for size: CGSize) -> some View {
        Rectangle()
            .foregroundColor(.accentColor)
            .padding(symbolSpacing(for: size))
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
        switch card.cardinality {
        case .first:
            return 1
        case .second:
            return 2
        case .third:
            return 3
        }
    }
    
    private func paperCornerRadius(for size: CGSize) -> CGFloat {
        let shortestDimension = min(size.height, size.width)
        return DrawingConstants.paperCornerRadiusRatio * shortestDimension
    }
    
    private func borderCornerRadius(for size:CGSize) -> CGFloat {
        paperCornerRadius(for: size) * DrawingConstants.borderDistanceFromCornerRatio
    }
    
    private func borderPadding(for size: CGSize) -> CGFloat {
        (paperCornerRadius(for: size) * (1 - DrawingConstants.borderDistanceFromCornerRatio)) - (0.5 * borderLineWidth(for: size))
    }
    
    private func borderLineWidth(for size: CGSize) -> CGFloat {
        let shortestDimension = min(size.height, size.width)
        var lineWidth = max(DrawingConstants.borderLineWidthRatio * shortestDimension, 1.0)
        lineWidth = lineWidth * (hasThickBorder ? DrawingConstants.thickBorderLineWidthMultiplier : 1.0)
        return lineWidth
    }
    
    private func symbolSpacing(for size: CGSize) -> CGFloat {
        paperCornerRadius(for: size)
    }
    
    private func symbolSize(for cardSize: CGSize) -> CGSize {
        let symbolPadding = symbolSpacing(for: cardSize)
        if cardSize.isNotWiderThanTall {
            // Divide height into 3 parts with spacing
            let height = (cardSize.height - (symbolPadding * 6)) / 3
            let width = (cardSize.width - (symbolPadding * 4))
            return CGSize(width: width, height: height)
        } else {
            // Divide width into 3 parts with spacing
            let width = (cardSize.width - (symbolPadding * 6)) / 3
            let height = (cardSize.height - (symbolPadding * 4))
            return CGSize(width: width, height: height)
        }
    }
    
    private func openSymbolLineWidth(for size: CGSize) -> CGFloat {
        let shortestDimension = min(size.height, size.width)
        return max(DrawingConstants.openSymbolLineWidthRatio * shortestDimension, 2.0)
    }
    
    private struct DrawingConstants {
        static let paperCornerRadiusRatio: CGFloat = 0.1
        
        static let borderDistanceFromCornerRatio: CGFloat = 0.5
        static let borderLineWidthRatio: CGFloat = 0.02
        static let thickBorderLineWidthMultiplier: CGFloat = 1.7

        static let stripedOpacity: Double = 0.5
        static let openSymbolLineWidthRatio: CGFloat  = 0.05
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = SetGame.Card(
            cardinality: .third,
            color: .second,
            symbol: .third,
            shading: .third
        )
        return Group {
            CardView(card: card, cardBorderColor: .orange, hasThickBorder: false)
                .frame(width: 300, height: 600, alignment: .center)
                .padding(10.0)
                .background(.gray)
                .previewDisplayName("Tall")
                .previewLayout(.sizeThatFits)
            CardView(card: card, cardBorderColor: .orange, hasThickBorder: false)
                .frame(width: 300, height: 300, alignment: .center)
                .padding(10.0)
                .background(.gray)
                .previewDisplayName("Square")
                .previewLayout(.sizeThatFits)
            CardView(card: card, cardBorderColor: .orange, hasThickBorder: false)
                .frame(width: 600, height: 300, alignment: .center)
                .padding(10.0)
                .background(.gray)
                .previewDisplayName("Wide")
                .previewLayout(.sizeThatFits)
            CardView(card: card, cardBorderColor: .orange, hasThickBorder: false)
                .frame(width: 25, height: 70, alignment: .center)
                .padding(10.0)
                .background(.gray)
                .previewDisplayName("Tall and small")
                .previewLayout(.sizeThatFits)
            CardView(card: card, cardBorderColor: .orange, hasThickBorder: false)
                .frame(width: 70, height: 25, alignment: .center)
                .padding(10.0)
                .background(.gray)
                .previewDisplayName("Wide and small")
                .previewLayout(.sizeThatFits)
        }
    }
}
