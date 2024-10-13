//
//  TriviaGameView.swift
//  Trivia_Game
//
//  Created by Lou-Michael Salvant on 10/13/24.
//

import SwiftUI

struct TriviaGameView: View {
    @ObservedObject var viewModel: TriviaViewModel // Accept the ViewModel
    
    var body: some View {
        VStack {
            if viewModel.questions.isEmpty {
                Text("Loading questions...")
            } else {
                List(viewModel.questions) { question in
                    VStack(alignment: .leading) {
                        Text(question.question)
                            .font(.headline)
                        ForEach(question.incorrect_answers, id: \.self) { answer in
                            Text(answer)
                        }
                        Text(question.correct_answer)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .navigationTitle("Trivia Game")
    }
}
