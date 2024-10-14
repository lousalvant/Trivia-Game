//
//  TriviaGameView.swift
//  Trivia_Game
//
//  Created by Lou-Michael Salvant on 10/13/24.
//

import SwiftUI

struct TriviaGameView: View {
    @ObservedObject var viewModel: TriviaViewModel
    @State private var showScore = false // State to control whether the score is shown
    
    var body: some View {
        VStack {
            if viewModel.questions.isEmpty {
                Text("Loading questions...")
            } else {
                List(viewModel.questions.indices, id: \.self) { index in
                    let question = viewModel.questions[index]
                    
                    VStack(alignment: .leading) {
                        Text(question.question)
                            .font(.headline)
                        
                        // Use shuffledAnswers directly without reshuffling
                        ForEach(question.shuffledAnswers, id: \.self) { answer in
                            HStack {
                                Text(answer)
                                    .padding()
                                    .background(question.selectedAnswer == answer ? Color.blue.opacity(0.2) : Color.clear)
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        viewModel.questions[index].selectedAnswer = answer
                                    }
                            }
                        }
                    }
                }
                
                Button(action: {
                    // Show score when the user submits
                    showScore = true
                }) {
                    Text("Submit Answers")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
                .alert("Your Score", isPresented: $showScore) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("You scored \(viewModel.calculateScore()) out of \(viewModel.questions.count)!")
                }
            }
        }
        .navigationTitle("Trivia Game")
    }
}
