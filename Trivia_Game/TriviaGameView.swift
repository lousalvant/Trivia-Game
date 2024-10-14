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
    @State private var isGameCompleted = false // Track if the user has submitted their answers
    
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
                        
                        // Combine incorrect and correct answers, then shuffle
                        let answers = question.shuffledAnswers

                        ForEach(answers, id: \.self) { answer in
                            HStack {
                                Text(answer)
                                    .padding()
                                    .background(answerBackgroundColor(for: answer, question: question))
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        if !isGameCompleted {
                                            viewModel.questions[index].selectedAnswer = answer
                                        }
                                    }
                            }
                        }
                    }
                }
                
                Button(action: {
                    // When user submits, mark game as completed and show score
                    isGameCompleted = true
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
    
    // Helper function to determine background color for each answer
    private func answerBackgroundColor(for answer: String, question: TriviaQuestion) -> Color {
        if isGameCompleted {
            if answer == question.correct_answer {
                return Color.green.opacity(0.6) // Correct answer is highlighted in green
            } else if answer == question.selectedAnswer {
                return Color.red.opacity(0.6) // Incorrect selected answer is highlighted in red
            }
        }
        
        return question.selectedAnswer == answer ? Color.blue.opacity(0.2) : Color.clear
    }
}
