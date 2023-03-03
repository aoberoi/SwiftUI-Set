//
//  PileView.swift
//  Set
//
//  Created by Ankur Oberoi on 1/22/22.
//

import SwiftUI

struct PileView<Item: Identifiable, ItemView: View>: View {
    
    // TODO: Find a means to make the pile "messy"
    
    // Items are piled with the first index at the top and the last index at the bottom
    let items: [Item]
    
    let content: (Item) -> ItemView
    
    @State private var offsets: [Item.ID : CGSize] = [:]
                   
    var body: some View {
        ZStack {
            ForEach(items.reversed()) { item in
                content(item)
            }
        }
    }
}

//struct PileView_Previews: PreviewProvider {
//    static var previews: some View {
//        PileView()
//    }
//}
