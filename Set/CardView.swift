//
//  CardView.swift
//  Set
//
//  Created by Ankur Oberoi on 8/8/21.
//

import SwiftUI

struct CardView: View {
    let card: SetGame.Card
  
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: DrawingConstants.edgeCornerRadius)
                    .strokeBorder(
                        DrawingConstants.cardColor,
                        style: StrokeStyle(lineWidth: DrawingConstants.edgeLineWidth)
                    )
                if geometry.size.isNotWiderThanTall {
                    VStack(spacing: DrawingConstants.symbolSpacing) {
                        ForEach(0..<numberOfSymbols) {_ in
                            symbol.frame(maxHeight: symbolLength(for: geometry.size.height))
                        }
                    }.padding(symbolPadding(for: geometry.size))
                } else {
                    HStack(spacing: DrawingConstants.symbolSpacing) {
                        ForEach(0..<numberOfSymbols) {_ in
                            symbol.frame(maxWidth: symbolLength(for: geometry.size.width))
                        }
                    }.padding(symbolPadding(for: geometry.size))
                }
            }
        }
    }
    
    @ViewBuilder
    private var symbol: some View {
        Group {
            switch card.shading {
            case .first:
                solidSymbol
            case .second:
                stripedSymbol
            case .third:
                openSymbol
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
    private var openSymbol: some View {
        switch card.symbol {
        case .first:
            Diamond().strokeBorder(lineWidth: DrawingConstants.openLineWidth)
        case .second:
            Rectangle().strokeBorder(lineWidth: DrawingConstants.openLineWidth)
        case .third:
            Capsule().strokeBorder(lineWidth: DrawingConstants.openLineWidth)
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
    
    private func symbolPadding(for size:CGSize) -> CGFloat {
        let longestDimension = max(size.height, size.width)
        return DrawingConstants.symbolPaddingRatio * longestDimension
    }
    
    private func symbolLength(for longestDimensionLength: CGFloat) -> CGFloat {
        let padding = 2 * DrawingConstants.symbolPaddingRatio * longestDimensionLength
        let maximumSpacing = 2 * DrawingConstants.symbolSpacing
        return (longestDimensionLength - padding - maximumSpacing) / 3
    }
    
    private struct DrawingConstants {
        // TODO: lineWidths might look unacceptable at small card sizes. if that's the case, then we will change these constants to funcs which compute a better looking value
        
        static let cardColor: Color = .orange
        
        static let edgeCornerRadius: CGFloat = 10.0
        static let edgeLineWidth: CGFloat = 3

        static let symbolPaddingRatio: CGFloat = 0.08
        
        static let stripedOpacity: Double = 0.5

        static let openLineWidth: CGFloat  = 5
        
        static let symbolSpacing: CGFloat = 10
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = SetGame.Card(
            cardinaity: .third,
            color: .second,
            symbol: .first,
            shading: .first
        )
        return Group {
            CardView(card: card)
                .previewDisplayName("Tall")
                .previewLayout(.sizeThatFits)
            CardView(card: card)
                .frame(width: 400, height: 400, alignment: .center)
                .previewDisplayName("Square")
                .previewLayout(.sizeThatFits)
            CardView(card: card)
                .frame(width: 600, height: 300, alignment: .center)
                .previewDisplayName("Wide")
                .previewLayout(.sizeThatFits)
            CardView(card: card)
                .frame(width: 45, height: 90, alignment: .center)
                .previewDisplayName("Tall and small")
                .previewLayout(.sizeThatFits)
        }
    }
}

extension CGSize {
    var isNotWiderThanTall: Bool {
        height - width >= 0
    }
}
