//
//  CardMovement.swift
//  Set
//
//  Created by Ankur Oberoi on 3/18/24.
//

import SwiftUI

struct CardMovementKey: EnvironmentKey {
    static let defaultValue: Namespace.ID = Namespace().wrappedValue
}

extension EnvironmentValues {
    var cardMovement: Namespace.ID {
        // NOTE: The following runtime warning is expected:
        // Reading a Namespace property outside View.body. This will result in identifiers that never match any other identifier.
        // Unfortunately, there's no good way to put a Namespace in the SwiftUI Environment without
        // triggering this warning.
        get { self[CardMovementKey.self] }
        set { self[CardMovementKey.self] = newValue }
    }
}

extension View {
    func cardMovementNamespace(_ value: Namespace.ID) -> some View {
        environment(\.cardMovement, value)
    }
}
