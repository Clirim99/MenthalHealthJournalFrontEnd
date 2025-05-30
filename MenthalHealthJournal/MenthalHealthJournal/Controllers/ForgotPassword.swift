//
//  ForgotPassword.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 29.5.25.
//

import SwiftUI

struct ForgotPassword: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack{
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(5)
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(5)
            TextField("Confirm password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(5)
            Button("Change password"){
                
            }
            .padding()
            .frame(maxWidth: UIScreen.main.bounds.width / 1.5, maxHeight: 50)
            .background(Color.gray.opacity(0.3))
            .buttonStyle(.bordered)
            .cornerRadius(10)
            .foregroundColor(.white)
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
    ForgotPassword()
}
