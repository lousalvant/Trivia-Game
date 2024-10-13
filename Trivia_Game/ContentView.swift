//
//  ContentView.swift
//  Trivia_Game
//
//  Created by Lou-Michael Salvant on 10/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TriviaViewModel() // The ViewModel is here

    var body: some View {
        NavigationView {
            OptionsView(viewModel: viewModel) // Pass the ViewModel to the options screen
        }
    }
}

#Preview {
    ContentView()
}
