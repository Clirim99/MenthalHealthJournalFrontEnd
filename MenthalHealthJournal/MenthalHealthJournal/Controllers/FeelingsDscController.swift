//
//  FeelingsDscController.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 29.5.25.
//

import SwiftUI

struct FeelingsDscController: View {
    @State private var feelingsText: String = "Describe your day"
    @State private var progress: Double = 0.5
    @State private var showHistory: Bool = false
    @State private var emojisImageName = "expresionLess"
    @FocusState private var isFocused: Bool
    @State private var hasStartedTyping = false

    var body: some View {
            // Full screen tappable background to dismiss keyboard
           

            // Main content
            VStack {
                HStack {
                    Button("menu") {
                        print("menu tapped!")
                        withAnimation {
                            showHistory.toggle()
                        }
                    }
                    .frame(maxWidth: 80)
                    .background(Color.gray.opacity(0.3))
                    .buttonStyle(.bordered)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.top, 36)
                    .padding(.leading, 18)
                    
                    Spacer()
                }

                Image(emojisImageName)
                    .resizable()
                    .cornerRadius(60)
                    .frame(width: 120, height: 120)
                    .padding(.top, 60)

                Spacer()

                Slider(value: $progress, in: 0...1)
                    .padding()
                    .onChange(of: progress) { newValue in
                        handleProgressChange(newValue)
                    }

                TextEditor(text: $feelingsText)
                    .padding(12)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                    .colorMultiply(Color.white.opacity(0.7))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .foregroundColor(hasStartedTyping ? .black : .gray)
                    .focused($isFocused)
                    .onChange(of: isFocused) { focused in
                        if focused {
                            feelingsText = ""
                            hasStartedTyping = false
                        }
                    }
                    .onChange(of: feelingsText) { newText in
                        if !newText.isEmpty {
                            hasStartedTyping = true
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: isFocused)

                Button("Send") {
                    // Action here
                }
                .padding()
                .frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: 50)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.bottom, 16)


                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .ignoresSafeArea()
        
    }

    func handleProgressChange(_ value: Double) {
        switch value {
        case 0.0..<0.2:
            emojisImageName = "verysad"
        case 0.2..<0.4:
            emojisImageName = "sad"
        case 0.4..<0.6:
            emojisImageName = "expresionLess"
        case 0.6..<0.8:
            emojisImageName = "happy"
        case 0.8...1.0:
            emojisImageName = "veryhappy"
        default:
            emojisImageName = "expresionLess"
        }
    }
}

#Preview {
    FeelingsDscController()
}


