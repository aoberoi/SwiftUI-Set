//
//  AspectVGrid.swift
//  Set
//
//  Created by Ankur Oberoi on 3/13/24.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    
    let aspectRatio: CGFloat
    
    let minItemWidth: CGFloat
    
    /// The space between columns and rows of items, and padding surrounding the items.
    let itemSpacing: CGFloat
    
    let content: (Item) -> ItemView
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                let width: CGFloat = max(widthThatFits(in: geometry.size), minItemWidth)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: itemSpacing) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                .padding(itemSpacing)
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        // An adaptively sized GridItem represents many items. In this usage, it represents the
        // width of items in many columns. Practically, the minimum width is actually the exact
        // width for items because it was calculated using widthThatFits().
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = itemSpacing
        return gridItem
    }
    
    // looking for the biggest item width such that all the items can fit in the size provided. that
    // item width then becomes the minimum width for the GridItem
    private func widthThatFits(in size: CGSize) -> CGFloat {
        let itemCount = items.count
        
        // Looking for the right column count such that all the items can fit into the available
        // height. In the worst case, we'll get to all the items in a single row.
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = (size.width - (CGFloat(columnCount + 1) * itemSpacing)) / CGFloat(columnCount)
            let itemHeight = itemWidth / aspectRatio
            // if all the items fit in the height with this number of columns, then we're done
            if (CGFloat(rowCount) * itemHeight) + (CGFloat(rowCount + 1) * itemSpacing) < size.height {
                break
            }
            // otherwise, let's try one more column
            columnCount += 1
            // and this is how many rows that would require (rounding up when it doesn't divide
            // evenly)
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        
        // TODO: remove the following variable and print(), only for debugging
        let retVal = floor((size.width - (CGFloat(columnCount + 1) * itemSpacing)) / CGFloat(columnCount))
        print("AspectVGrid: widthThatFits in size \(size) = \(retVal)")
        
        return retVal
    }
    
}

// TODO: Would a preview for this view be helpful?
//#Preview {
//    AspectVGrid()
//}
