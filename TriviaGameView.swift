//
//  TriviaGameView.swift
//  Trivia
//
//  Created by Christopher Petit on 3/10/25.
//

import SwiftUI

struct TriviaGameView: View {
    var numberOfQuestions: Int
    var category: Int
    var difficulty: String
    var type: String
    var timeLimit: Int

    @State private var questions: [TriviaQuestion] = []
    @State private var selectedAnswers: [UUID: String] = [:]
    @State private var score = 0
    @State private var showScore = false
    @State private var isLoading = true
    @State private var timeRemaining: Int  // Timer countdown
    @State private var timerActive = false  // Controls the timer
    @State private var showAlert = false  // Shows alert when time is up
    
    init(numberOfQuestions: Int, category: Int, difficulty: String, type: String, timeLimit: Int) {
            self.numberOfQuestions = numberOfQuestions
            self.category = category
            self.difficulty = difficulty
            self.type = type
            self.timeLimit = timeLimit
            self._timeRemaining = State(initialValue: timeLimit) // Initialize timer
        }
    
    var body: some View {
        VStack {
            
            // Show Timer
            Text("Time Remaining: \(timeRemaining) sec")
                .font(.headline)
                .foregroundColor(timeRemaining <= 10 ? .red : .blue)
                .padding()
            
            if questions.isEmpty {
                ProgressView("Loading Questions...")
                    .onAppear { fetchTriviaQuestions()
                        startTimer()
                    }
            } else {
                ScrollView {
                    ForEach(questions) { question in
                        QuestionCard(
                            question: question,
                            selectedAnswers: $selectedAnswers
                        )
                        .padding(.horizontal)
                    }
                }
                
                Button(action: submitAnswers) {
                    
                    Text("Submit Answers")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .navigationTitle("Trivia Game")
        .alert(isPresented: $showScore) {
            Alert(
                title: Text("Quiz Completed!"),
                message: Text("Your Score: \(score)/\(questions.count)"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    /// Fetches trivia questions from API
    func fetchTriviaQuestions() {
        var urlString = "https://opentdb.com/api.php?amount=\(numberOfQuestions)&category=\(category)&difficulty=\(difficulty)"
        if type != "any" {
            urlString += "&type=\(type)"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.questions = decodedResponse.results
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
    }
    
    /// Submits answers and calculates score
    func submitAnswers() {
        score = questions.filter { question in
            selectedAnswers[question.id] == question.correct_answer
        }.count
        
        timerActive = false
        showScore = true
    }
    
    func startTimer() {
            timerActive = true
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if timeRemaining > 0 && timerActive {
                    timeRemaining -= 1
                } else {
                    timer.invalidate()
                    timerActive = false
                    showAlert = true  // Show time's up alert
                }
            }
        }
}

