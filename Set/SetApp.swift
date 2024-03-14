//
//  SetApp.swift
//  Set
//
//  Created by Ankur Oberoi on 3/9/24.
//

import SwiftUI

@main
struct SetApp: App {
    @State private var game = SetGame()
    
    var body: some Scene {
        WindowGroup {
            SetGameView()
                .environment(game)
        }
    }
}
