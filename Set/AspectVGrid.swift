//
//  AspectVGrid.swift
//  Memorize
//
//  Created by CS193p Instructor on 4/14/21.
//  Copyright Stanford University 2021
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    let aspectRatio: CGFloat
    let minItemWidth: CGFloat
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
                // TODO: this causes a strange jump in the change of the height of the frame when the number of columns changes
                //.frame(minHeight: geometry.size.height)
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = itemSpacing
        return gridItem
    }
    
    // looking for the biggest item width such that all the items can fit in the size provided. that item width
    // then becomes the minimum width for the GridItem
    private func widthThatFits(in size: CGSize) -> CGFloat {
        let itemCount = items.count
        
        // Looking for the right column count such that all the items can fit into the available height.
        // In the worst case, we'll get to all the items in a single row.
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
            // and this is how many rows that would require (rounding up when it doesn't divide evenly)
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        
        return floor((size.width - (CGFloat(columnCount + 1) * itemSpacing)) / CGFloat(columnCount))
    }
    
}
