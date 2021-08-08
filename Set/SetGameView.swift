//
//  ContentView.swift
//  Set
//
//  Created by Ankur Oberoi on 8/6/21.
//

import SwiftUI

struct SetGameView: View {
    var game: SetGame
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button("Deal 3 More Cards") {
                    
                }
                Spacer()
                Button("New Game") {
                    
                }
            }
            .padding()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGame()
        return SetGameView(game: game)
    }
}
