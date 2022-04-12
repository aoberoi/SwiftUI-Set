//
//  PileView.swift
//  Set
//
//  Created by Ankur Oberoi on 1/22/22.
//

import SwiftUI

struct PileView<Item: Identifiable, ItemView: View /*,
                VerticalOffsetRange: RangeExpression, HorizontalOffsetRange: RangeExpression */>: View
               /* where VerticalOffsetRange.Bound == CGFloat, HorizontalOffsetRange.Bound == CGFloat */
{
    
    // TODO: This view fundamentally doesn't work because the following constraint cannot be held true
    // This view only works when items are added or removed from the front of this Array, which
    // represents the top of the pile
    let items: [Item]
                   
    // NOTE: Ideally, these would be properties with default values. However, there seems to be an
    // issue with using generic types this way. See: https://stackoverflow.com/q/71834496/305340
    // var verticalOffsetRange: VerticalOffsetRange = CGFloat(0.0)...CGFloat(2.0)
    // var horizontalOffsetRange: HorizontalOffsetRange = CGFloat(-1.5)...CGFloat(1.5)
    
    let content: (Item) -> ItemView
    
    @State private var offsets: [Item.ID : CGSize] = [:]
                   
    var body: some View {
        ZStack {
            ForEach(items) { item in
                content(item)
                    .offset(offset(for: item))
                    .zIndex(zIndex(for: item))
            }
        }
        .onAppear {
            computeOffsets()
        }
    }
    
    private func computeOffsets() {
        if items.count > 0 {
            var currentOffset = CGSize.zero
            for item in items.reversed() {
                offsets[item.id] = currentOffset
                currentOffset.width += CGFloat.random(in: -1.5...1.5)
                currentOffset.height -= CGFloat.random(in: 0.0...1.0)
            }
            print(offsets)
        }
    }
    
    private func offset(for item: Item) -> CGSize {
        return (offsets[item.id] ?? CGSize.zero)
    }
    
    private func zIndex(for item: Item) -> Double {
        let index = items.firstIndex(where: { $0.id == item.id }) ?? 0
        return -Double(index)
    }
}

//struct PileView_Previews: PreviewProvider {
//    static var previews: some View {
//        PileView()
//    }
//}
