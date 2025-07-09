//
//  Login.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 28.5.25.
//

import SwiftUI

struct Login: View {
    @State private var username: String = ""
    @State private var password: String = ""


    
    var body: some View {
        
        VStack{
        TextField("Username", text: $username)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(5)
        TextField("Password", text: $password)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(5)
            HStack{
                NavigationLink(destination: FeelingsDscController()) {
                    Text("Login")
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(Color.gray.opacity(0.3))
                        .buttonStyle(.bordered)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                NavigationLink(destination: SignUp()) {
                    Text("Sign up")
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .background(Color.gray.opacity(0.3))
                        .buttonStyle(.bordered)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }
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
    Login()
}
