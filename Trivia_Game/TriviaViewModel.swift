//
//  TriviaViewModel.swift
//  Trivia_Game
//
//  Created by Lou-Michael Salvant on 10/13/24.
//

import SwiftUI

class TriviaViewModel: ObservableObject {
    @Published var questions: [TriviaQuestion] = []
    @Published var timeLimit: Int = 30 // Default to 30 seconds, but this will be configurable via OptionsView
    
    // Calculate the user's score based on the correct answers
    func calculateScore() -> Int {
        return questions.filter { $0.selectedAnswer == $0.correct_answer }.count
    }
    
    // Reset the game state to start a new game
    func resetGame() {
        // Clear the questions array
        questions.removeAll()
        
        // Reset the selected answers to nil (in case you reuse the same question objects)
        for index in questions.indices {
            questions[index].selectedAnswer = nil
        }
        
        // Optionally reset the time limit or keep the existing one
        timeLimit = 30 // Default or configurable, depending on user preferences
    }

    // Static mock data for previews
    static var mock: TriviaViewModel {
        let mockViewModel = TriviaViewModel()
        mockViewModel.questions = [
            TriviaQuestion(
                category: "General Knowledge",
                type: "multiple",
                difficulty: "easy",
                question: "What is the closest planet to the Sun?",
                correct_answer: "Mercury",
                incorrect_answers: ["Venus", "Earth", "Mars"]
            ),
            TriviaQuestion(
                category: "Science",
                type: "multiple",
                difficulty: "medium",
                question: "What is the atomic number of Oxygen?",
                correct_answer: "8",
                incorrect_answers: ["4", "6", "10"]
            )
        ]
        mockViewModel.timeLimit = 60 // For preview purposes, set a mock time limit
        return mockViewModel
    }
    
    // Fetch trivia from the Open Trivia DB API
    func fetchTrivia(amount: Int, category: Int, difficulty: String, type: String) async {
        let urlString = "https://opentdb.com/api.php?amount=\(amount)&category=\(category)&difficulty=\(difficulty)&type=\(type)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON Response: \(jsonString)")
            }
            
            let decodedData = try JSONDecoder().decode(TriviaResponse.self, from: data)
            
            if decodedData.response_code == 0 {
                DispatchQueue.main.async {
                    self.questions = decodedData.results
                    // Reset selected answers after fetching new questions
                    for index in self.questions.indices {
                        self.questions[index].selectedAnswer = nil
                    }
                }
            } else {
                print("Error: Trivia API returned response code \(decodedData.response_code)")
                handleResponseCode(decodedData.response_code)
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    // Handle the response code from the API
    private func handleResponseCode(_ code: Int) {
        switch code {
        case 1:
            print("No Results: The API doesn't have enough questions for your query.")
        case 2:
            print("Invalid Parameter: Check if your query parameters are valid.")
        case 3:
            print("Token Not Found: Ensure the session token is valid.")
        case 4:
            print("Token Empty: You've exhausted all possible questions for this query. Consider resetting the token.")
        case 5:
            print("Rate Limit: You're making requests too quickly. Please wait before retrying.")
        default:
            print("Unknown error occurred.")
        }
    }
    
    // Function to update the time limit from the options screen
    func updateTimeLimit(to newTimeLimit: Int) {
        timeLimit = newTimeLimit
    }
}
