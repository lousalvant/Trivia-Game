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
    @State private var timeRemaining: Int = 0 // Timer for the game
    @State private var timerRunning = false // Track if the timer is running
    @Environment(\.dismiss) private var dismiss // Environment dismiss to go back

    var body: some View {
        VStack {
            if viewModel.questions.isEmpty {
                Text("Loading questions...")
            } else {
                // Display timer at the top
                Text("Time Remaining: \(timeRemaining) seconds")
                    .font(.title)
                    .padding()
                    .onAppear {
                        startTimer()
                    }

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
                    stopTimer()
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
                    Button("OK", role: .cancel) {
                        // Allow user to review the answers after seeing the score
                    }
                } message: {
                    Text("You scored \(viewModel.calculateScore()) out of \(viewModel.questions.count)!")
                }
            }
        }
        .navigationTitle("Trivia Game")
        .onDisappear {
            if isGameCompleted {
                // Only reset the game when navigating back to the OptionsView
                viewModel.resetGame()
            }
            stopTimer() // Stop the timer if the view is dismissed
        }
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

    // Timer setup
    private func startTimer() {
        timeRemaining = viewModel.timeLimit // Set the time limit
        timerRunning = true

        // Start the timer
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 && timerRunning {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                if timeRemaining == 0 {
                    // Auto-submit when timer runs out
                    isGameCompleted = true
                    showScore = true
                }
            }
        }
    }

    private func stopTimer() {
        timerRunning = false
    }
}
