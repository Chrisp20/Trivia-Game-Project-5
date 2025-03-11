//
//  OptionsView.swift
//  Trivia
//
//  Created by Christopher Petit on 3/10/25.
//

import SwiftUI

struct OptionsView: View {
    @State private var numberOfQuestions = ""
    @State private var selectedCategory = 9  // Default: General Knowledge
    @State private var difficultyValue: Double = 1.0  // Slider value (1 = Easy, 2 = Medium, 3 = Hard)
    @State private var selectedTime = 60
    @State private var selectedType = "any" // Default to "Any Type"
    @State private var isValidInput = true  // Track valid input
    
    // Converts the slider value into a difficulty string
    private var difficultyText: String {
        switch difficultyValue {
        case 1.0: return "Easy"
        case 2.0: return "Medium"
        case 3.0: return "Hard"
        default: return "Easy"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                           // Centered Trivia Game Title
                    Text("Trivia Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                           
                    Form {
                        TextField("Enter Question numbers (1-10)", text: $numberOfQuestions)
                                   .keyboardType(.numberPad)
                                   .onChange(of: numberOfQuestions) { validateInput() }
                                   .foregroundColor(isValidInput ? .primary : .black)

                        Picker("Select Category", selection: $selectedCategory) {
                                   Text("Animals").tag(0)
                                   Text("General Knowledge").tag(9)
                                   Text("Movies").tag(11)
                                   Text("Music").tag(12)
                                   Text("Television").tag(14)
                                   Text("Science & Nature").tag(17)
                                   Text("Books").tag(18)
                                   Text("Sports").tag(21)
                               }
                               .pickerStyle(MenuPickerStyle())

                        VStack {
                                Text("Difficulty: \(difficultyText)")
                                       .font(.headline)
                                Slider(value: $difficultyValue, in: 1...3, step: 1)
                                       .accentColor(.blue)
                               }
                               .padding(.vertical, 5)

                        Picker("Select Type", selection: $selectedType) {
                                   Text("Any Type").tag("any")
                                   Text("Multiple Choice").tag("multiple")
                                   Text("True/False").tag("boolean")
                               }
                               .pickerStyle(MenuPickerStyle())
                        
                        // Time Duration Picker
                        VStack(alignment: .leading) {
                            Picker("Select Time", selection: $selectedTime) {
                                    Text("30 seconds").tag(30)
                                    Text("60 seconds").tag(60)
                                    Text("120 seconds").tag(120)
                                    Text("300 seconds").tag(300)
                                    Text("1 hour").tag(3600)
                                }
                                .pickerStyle(MenuPickerStyle())
                                }

                        NavigationLink(destination: TriviaGameView(
                                   numberOfQuestions: Int(numberOfQuestions) ?? 10,
                                   category: selectedCategory,
                                   difficulty: difficultyText.lowercased(),
                                   type: selectedType, // Pass as a string, handle "any" in TriviaGameView
                                   timeLimit: selectedTime
                               )) {
                                   Section(){
                                       Text("Start Trivia")
                                           .font(.headline)
                                           .foregroundColor(.white)
                                           .frame(maxWidth: .infinity)
                                           .padding()
                                           .background(isValidInput ? Color.green : Color.gray)
                                           .cornerRadius(25)
                                   }
                               }
                               .disabled(!isValidInput)
                           }
                    .ignoresSafeArea(.keyboard)
                       }
            
                   }
               }
               
               /// Validates user input to ensure it's a number between 1 and 20.
               private func validateInput() {
                   if let value = Int(numberOfQuestions), value >= 1, value <= 20 {
                       isValidInput = true
                   } else {
                       isValidInput = false
                   }
               }
           }
#Preview {
    OptionsView()
}
