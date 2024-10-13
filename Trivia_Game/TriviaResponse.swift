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
    var id: String { question } // Use the question string as a unique identifier
    
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}
