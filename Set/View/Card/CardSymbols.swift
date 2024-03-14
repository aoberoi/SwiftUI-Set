//
//  CardSymbols.swift
//  Set
//
//  Created by Ankur Oberoi on 3/14/24.
//

import SwiftUI

struct CardSymbols: View {
    private let card: SetGame.Card
    private let spacing: CGFloat

    init(_ card: SetGame.Card, spacing: CGFloat) {
        self.card = card
        self.spacing = spacing
    }
    
    var body: some View {
        // NOTE: We may be able to eliminate the GeometryReader here if the appropriate
        // measurements (e.g. shortestDimension) are passed in from the CardView. However, the
        // GeometryReader is used here now because it better encapsulates the LayoutDirection
        // decision. This may change if the note below is resolved in some manner that eliminates
        // that approach. In that case, the symbols method would not use the measurements from
        // this GeometryReader, and instead use the measurements passed in from CardView.
        // DrawingConstants in CardSymbol may need to be adjusted.
        GeometryReader { geometry in
            // NOTE: This technique involves view identity changes when the layout dimensions
            // change from wider or taller. This mostly only happens when the device orientation
            // changes. However this may negatively affect animations or other stateful updates.
            // It might be useful to use a .transition(identity) (or similar) on the containers if
            // we find visible transition animations occurring. Another way to avoid this would be
            // to use the Layout protocol to create a container that switches internally, so that
            // the contained views' identity doesn't change.
            let layoutDirection = LayoutDirection.bestFit(for: geometry.size)
//            let shortestDimensionLength = min(geometry.size.height, geometry.size.width)
            
            let totalSpacing = spacing * 2
            let symbolSize = switch layoutDirection {
            case .horizontal: CGSize(width: (geometry.size.width - totalSpacing) / 3, height: geometry.size.height)
            case .vertical: CGSize(width: geometry.size.width, height: (geometry.size.height - totalSpacing) / 3)
            }
            
            // TODO: why do stroked inset shapes "escape" their frame, especially when a sharp
            // corner is on an edge (like with diamonds)?

            // TODO: the size should be the same no matter how many symbols are there
            // options:
            // 1) pass in a symbolSize to the symbols() func, and let that method add a frame to
            //    each symbol
            // 2) implement a custom Layout which also solves the problems described above
            // 3) use containerRelativeFrame to size each symbol? don't know if this works with
            //    arbitrary containers
            switch layoutDirection {
            case .horizontal:
                HStack(alignment: .center, spacing: spacing) {
//                    symbols(using: shortestDimensionLength)
                    symbols(with: symbolSize)
                }
                .frame(maxWidth: .infinity)
            case .vertical:
                VStack(alignment: .center, spacing: spacing) {
//                    symbols(using: shortestDimensionLength)
                    symbols(with: symbolSize)
                }
                .frame(maxHeight: .infinity)
            }
        }
    }
    
//    @ViewBuilder
    // TODO: this is a bad external parameter name
//    private func symbols(using shortestDimensionLength: CGFloat) -> some View {
////        let symbol = CardSymbol(
////            color: card.color,
////            shape: shape,
////            shading: card.shading,
////            shortestDimensionLength: shortestDimensionLength
////        )
//        let symbol = symbol(using: shortestDimensionLength)
//        ForEach(0..<numberOfSymbols, id: \.self) { _ in
//            symbol
//        }
//    }
    
    @ViewBuilder
    private func symbols(with size: CGSize) -> some View {
        let symbol = symbol
        ForEach(0..<numberOfSymbols, id: \.self) { _ in
            symbol
                .frame(width: size.width, height: size.height)
        }
    }
    
    private var numberOfSymbols: Int {
        switch card.cardinality {
            case .first: 1
            case .second: 2
            case .third: 3
        }
    }
    
    // TODO: explore alternative implementations where we can eliminate this use of an existential
//    private var shape: any InsettableShape {
//        return switch card.symbol {
//        case .first: Diamond()
//        case .second: Rectangle()
//        case .third: Capsule()
//        }
//    }

//    @ViewBuilder
//    private func symbol(using shortestDimensionLength: CGFloat) -> some View {
//        switch card.symbol {
//        case .first: CardSymbol(color: card.color, shape: Diamond(), shading: card.shading, shortestDimensionLength: shortestDimensionLength)
//        case .second: CardSymbol(color: card.color, shape: Rectangle(), shading: card.shading, shortestDimensionLength: shortestDimensionLength)
//        case .third: CardSymbol(color: card.color, shape: Capsule(), shading: card.shading, shortestDimensionLength: shortestDimensionLength)
//        }
//    }
    
    @ViewBuilder
    private var symbol: some View {
        switch card.symbol {
        case .first: CardSymbol(shape: Diamond(), color: card.color,  shading: card.shading)
        case .second: CardSymbol(shape: Rectangle(), color: card.color, shading: card.shading)
        case .third: CardSymbol(shape: Capsule(), color: card.color, shading: card.shading)
        }
    }
    
    enum LayoutDirection {
        case vertical, horizontal
        static func bestFit(for size: CGSize) -> Self {
            size.width > size.height ? .horizontal : .vertical
        }
    }
    
    struct DrawingConstants {
        // The proportion of the length of the longest dimension of the symbol area to the distance
        // between symbols
        static let spacingProportion: CGFloat = 15 / 100
    }
}

#Preview {
    let card = SetGame.Card(
        cardinality: .second,
        color: .first,
        symbol: .first,
        shading: .third
    )
    return CardSymbols(card, spacing: 50)
}
