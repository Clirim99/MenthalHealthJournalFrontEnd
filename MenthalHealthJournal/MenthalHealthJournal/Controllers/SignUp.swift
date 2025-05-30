//
//  SignUp.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 28.5.25.
//

import SwiftUI

struct SignUp: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    
    
    var body: some View {
        VStack{
            Text("Sign Up")
                .fontWeight(.heavy)
            TextField("First name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(5)
            TextField("Last name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(5)
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(5)
            TextField("Email", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(5)
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(5)
            TextField("Confrim password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(5)
            Button("Sign up"){
                print("signed up")
            }
            .frame(maxWidth: UIScreen.main.bounds.width / 3)
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
    SignUp()
}
