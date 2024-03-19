//
//  MaxProportionLowerBar.swift
//  Set
//
//  Created by Ankur Oberoi on 3/19/24.
//

import SwiftUI

/// A container of two views, vertically stacked, where the lower view is constrained to by a maximum proportion of the vertical
/// space for its height. The lower view can choose to take up less than the maximum proportion, and when it does the rest of the
/// unused height is offered to the upper view. The combined view will take all the space it is offered.
struct VerticalSplitWithHeightLimitOnLower<Upper: View, Lower: View>: View {
    let upper: Upper
    let lower: Lower
    
    let lowerMaxProportionOfHeight: Double
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // The frame modifier with minHeight limits the space offered to the lower view.
                upper.frame(minHeight: geometry.size.height * (1 - lowerMaxProportionOfHeight))
                // The lower view is offered the lowerMaxProportionOfHeight of the space first, so
                // that the remaining space can be offered to the upper view.
                lower.layoutPriority(1)
            }
        }
    }
}

// TODO: use a sample lowerBar view that tries to take up less than the
// total space offered to it.
#Preview {
    VerticalSplitWithHeightLimitOnLower(
        upper: Rectangle().fill(.red),
        lower: Rectangle().fill(.blue),
        lowerMaxProportionOfHeight: 1/3
    )
}
