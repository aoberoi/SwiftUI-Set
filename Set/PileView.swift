//
//  PileView.swift
//  Set
//
//  Created by Ankur Oberoi on 1/22/22.
//

import SwiftUI

struct PileView<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    let reverseOrder: Bool
    let content: (Item) -> ItemView
    
    var body: some View {
        // TODO: add some offset so that the items look piled up on top of each other (possibly with randomization and/or shadow
        ZStack {
            ForEach(items) { item in
                content(item)
            }
        }
    }
    
    private func zIndex(for item: Item) -> Double {
        let index = items.firstIndex(where: { $0.id == item.id }) ?? 0
        return Double(index) * (reverseOrder ? -1 : 1)
    }
}

//struct PileView_Previews: PreviewProvider {
//    static var previews: some View {
//        PileView()
//    }
//}
