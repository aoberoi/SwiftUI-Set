//
//  Diamond.swift
//  Set
//
//  Created by Ankur Oberoi on 8/16/21.
//

import SwiftUI

struct Diamond: InsettableShape {
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY + insetAmount))
            path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - insetAmount))
            path.addLine(to: CGPoint(x: rect.minX + insetAmount, y: rect.midY))
            path.closeSubpath()
        }
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var diamond = self
        diamond.insetAmount += amount
        return diamond
    }
}
