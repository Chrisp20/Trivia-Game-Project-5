//
//  TriviaAPI.swift
//  Trivia
//
//  Created by Christopher Petit on 3/10/25.
//

import Foundation

class TriviaAPI {
    static func fetchTriviaQuestions(amount: Int, category: Int, difficulty: String, type: String, completion: @escaping ([TriviaQuestion]) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=\(amount)&category=\(category)&difficulty=\(difficulty)&type=\(type)"
        
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let triviaResponse = try decoder.decode(TriviaResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(triviaResponse.results)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}
