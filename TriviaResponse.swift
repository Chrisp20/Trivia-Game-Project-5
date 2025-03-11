//
//  TriviaResponse.swift
//  Trivia
//
//  Created by Christopher Petit on 3/10/25.
//

import Foundation

struct TriviaResponse: Codable {
    let response_code: Int
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Codable, Identifiable {
    let id = UUID()  // Unique identifier for SwiftUI List
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
    enum CodingKeys: String, CodingKey {
            case category, type, difficulty, question, correct_answer, incorrect_answers
        }
    
    // Combine correct and incorrect answers
    var allAnswers: [String] {
        (incorrect_answers + [correct_answer]).shuffled()
    }
}
