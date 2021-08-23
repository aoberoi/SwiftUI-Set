//
//  AspectVGrid.swift
//  Memorize
//
//  Created by CS193p Instructor on 4/14/21.
//  Copyright Stanford University 2021
//

import SwiftUI

struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    var items: [Item]
    var aspectRatio: CGFloat
    var content: (Item) -> ItemView
    var minItemWidth: CGFloat
    
    init(items: [Item], aspectRatio: CGFloat, minItemWidth: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        // TODO: can we remove this custom initializer? what's the deal with @escaping in that case?
        self.items = items
        self.aspectRatio = aspectRatio
        self.minItemWidth = minItemWidth
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                let width: CGFloat = max(widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio), minItemWidth)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                    // The following modifier ensures that all "state" within the LazyVGrid is invalidated each time the items
                    // change. This resolves an issue where the LazyVGrid was not recomputing its size when the computed grid
                    // item width changes above. This led to instances where when the width increased, the grid did not try to
                    // display all of the items (it didn't seem to invalidate the height and understand that there was more room).
                    // We never really wanted the laziness of the LazyVGrid, only the adaptive column layout.
                    // This might limit the future ability to perform animations on items.
                    // https://swiftui-lab.com/swiftui-id/
                    .id(items.map { $0.id })
            }
        }
    }
    
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if  CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(size.width / CGFloat(columnCount))
    }

}
