//
//  ContentView.swift
//  Trivia_Game
//
//  Created by Lou-Michael Salvant on 10/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TriviaViewModel()

    var body: some View {
        NavigationStack { // Use NavigationStack instead of NavigationView
            OptionsView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}

