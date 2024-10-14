//
//  OptionsView.swift
//  Trivia_Game
//
//  Created by Lou-Michael Salvant on 10/13/24.
//

import SwiftUI

struct OptionsView: View {
    @ObservedObject var viewModel: TriviaViewModel
    @State private var numberOfQuestions = 5
    @State private var selectedCategory = 9 // Default ID for General Knowledge
    @State private var selectedDifficulty = "easy"
    @State private var questionType = "multiple"
    @State private var selectedTimeLimit = 30 // Default to 30 seconds
    @State private var isTriviaReady = false // State to track navigation readiness

    let categories = [
        (id: 9, name: "General Knowledge"),
        (id: 17, name: "Science"),
        (id: 19, name: "Math"),
        (id: 23, name: "History")
    ]

    let difficulties = ["easy", "medium", "hard"]
    let types = ["multiple", "boolean"]
    let timeLimits = [30, 60, 120] // Time duration options in seconds

    var body: some View {
        VStack {
            Form {
                // Number of questions picker
                Section(header: Text("Number of Questions")) {
                    Picker("Questions", selection: $numberOfQuestions) {
                        ForEach([5, 10, 15], id: \.self) { num in
                            Text("\(num)")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                // Category picker
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.id) { category in
                            Text(category.name).tag(category.id)
                        }
                    }
                }

                // Difficulty picker
                Section(header: Text("Difficulty")) {
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        ForEach(difficulties, id: \.self) { difficulty in
                            Text(difficulty)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }

                // Question type picker
                Section(header: Text("Type")) {
                    Picker("Type", selection: $questionType) {
                        ForEach(types, id: \.self) { type in
                            Text(type == "multiple" ? "Multiple Choice" : "True/False")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                // Time limit picker
                Section(header: Text("Time Limit")) {
                    Picker("Time Limit (seconds)", selection: $selectedTimeLimit) {
                        ForEach(timeLimits, id: \.self) { limit in
                            Text("\(limit) seconds")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }

            // Start Trivia Game button
            Button(action: {
                Task {
                    await viewModel.fetchTrivia(amount: numberOfQuestions, category: selectedCategory, difficulty: selectedDifficulty, type: questionType)
                    viewModel.timeLimit = selectedTimeLimit // Pass selected time to viewModel
                    if !viewModel.questions.isEmpty {
                        isTriviaReady = true
                    }
                }
            }) {
                Text("Start Trivia Game")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .navigationTitle("Trivia Options")
        .navigationDestination(isPresented: $isTriviaReady) {
            TriviaGameView(viewModel: viewModel)
        }
    }
}
