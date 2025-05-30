//
//  FeelingsDscController.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 29.5.25.
//

import SwiftUI

struct FeelingsDscController: View {
    @State private var text: String = "Describe your day"
    @State private var progress: Double = 0.0

    
    var body: some View {
        VStack{
            Image("menthalHealthLogo")
                .resizable()
                .cornerRadius(60)
                .frame(width: 120,height: 120)
                .padding(.top,180)
            
            
            Spacer()
            
            Text("Happiness: \(Int(progress * 100))%")

                   // User input via slider
            Slider(value: $progress, in: 0...1)
                       .padding()
            
            TextEditor(text: $text)
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height / 3)
                .background(Color.white.opacity(0.2))
                .cornerRadius(45) // 👈 Rounded corners
                .foregroundColor(.black)
            Button("Send"){
                
            }
            .padding()
            .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 50)
            .background(Color.gray.opacity(0.3))
            .buttonStyle(.bordered)
            .cornerRadius(10)
            .foregroundColor(.white)
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand to fill the screen
        .background(
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .ignoresSafeArea() // Optional: extend under the safe area
    }
    
}

#Preview {
    FeelingsDscController()
}
