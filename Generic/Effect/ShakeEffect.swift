//
//  ShakeEffect.swift
//  Set
//
//  Created by Ankur Oberoi on 3/14/24.
//

import SwiftUI

struct ShakeEffect : GeometryEffect {
    var direction: Axis = .horizontal
    var distance: CGFloat = 5.0
    var pct: CGFloat

    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        // scale the period of the sine wave to pct
        let angle = pct * 2 * .pi
        // scale the amplitude of the sine wave to distance
        let offset = sin(angle) * distance
        
        switch direction {
        case .horizontal:
            return ProjectionTransform(CGAffineTransform(translationX: offset, y: 0))
        case .vertical:
            return ProjectionTransform(CGAffineTransform(translationX: 0, y: offset))
        }
    }
}

extension View {
    func shakeEffect(direction: Axis = .horizontal, distance: CGFloat = 5.0, pct: CGFloat = 0) -> some View {
        modifier(ShakeEffect(direction: direction, distance: distance, pct: pct))
    }
}

