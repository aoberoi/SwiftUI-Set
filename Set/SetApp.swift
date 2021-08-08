//
//  SetApp.swift
//  Set
//
//  Created by Ankur Oberoi on 8/6/21.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = SetGame()
    
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
