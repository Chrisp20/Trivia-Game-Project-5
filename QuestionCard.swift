//
//  QuestionCard.swift
//  Trivia
//
//  Created by Christopher Petit on 3/10/25.
//

import SwiftUI

struct QuestionCard: View {
    let question: TriviaQuestion
    @Binding var selectedAnswers: [UUID: String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(question.question)
                .font(.headline)
                .multilineTextAlignment(.leading)

            ForEach(question.allAnswers, id: \.self) { answer in
                Button(action: { selectedAnswers[question.id] = answer }) {
                    HStack {
                        Text(answer)
                            .font(.body)
                            .foregroundColor(.black)
                        Spacer()
                        
                        if selectedAnswers[question.id] == answer {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15)
            .stroke(Color.blue, lineWidth: 2))
        .padding(.vertical, 5)
    }
}
