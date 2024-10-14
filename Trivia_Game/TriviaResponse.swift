//
//  TriviaResponse.swift
//  Trivia_Game
//
//  Created by Lou-Michael Salvant on 10/13/24.
//

import Foundation

struct TriviaResponse: Codable {
    let response_code: Int
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Codable, Identifiable {
    var id: String { question }
    
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
    var shuffledAnswers: [String]
    var selectedAnswer: String? // Track the user's selected answer
    
    // Add a custom initializer for mock data or manual creation
    init(category: String, type: String, difficulty: String, question: String, correct_answer: String, incorrect_answers: [String]) {
        self.category = category
        self.type = type
        self.difficulty = difficulty
        self.question = question
        self.correct_answer = correct_answer
        self.incorrect_answers = incorrect_answers
        self.shuffledAnswers = (incorrect_answers + [correct_answer]).shuffled() // Shuffle answers during initialization
    }
    
    // Add the existing decoding initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decode(String.self, forKey: .category)
        type = try container.decode(String.self, forKey: .type)
        difficulty = try container.decode(String.self, forKey: .difficulty)
        question = try container.decode(String.self, forKey: .question)
        correct_answer = try container.decode(String.self, forKey: .correct_answer)
        incorrect_answers = try container.decode([String].self, forKey: .incorrect_answers)
        
        // Shuffle the correct and incorrect answers once
        shuffledAnswers = (incorrect_answers + [correct_answer]).shuffled()
    }
}
