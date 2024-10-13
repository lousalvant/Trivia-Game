//
//  TriviaViewModel.swift
//  Trivia_Game
//
//  Created by Lou-Michael Salvant on 10/13/24.
//

import SwiftUI

class TriviaViewModel: ObservableObject {
    @Published var questions: [TriviaQuestion] = []
    
    static var mock: TriviaViewModel {
            let mockViewModel = TriviaViewModel()
            mockViewModel.questions = [
                TriviaQuestion(category: "General Knowledge", type: "multiple", difficulty: "easy", question: "What is the closest planet to the Sun?", correct_answer: "Mercury", incorrect_answers: ["Venus", "Earth", "Mars"]),
                TriviaQuestion(category: "Science", type: "multiple", difficulty: "medium", question: "What is the atomic number of Oxygen?", correct_answer: "8", incorrect_answers: ["4", "6", "10"])
            ]
            return mockViewModel
        }
    
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
                }
            } else {
                print("Error: Trivia API returned response code \(decodedData.response_code)")
                handleResponseCode(decodedData.response_code)
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
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
}

#Preview {
    TriviaGameView(viewModel: TriviaViewModel.mock) // Using mock data for the preview
}

