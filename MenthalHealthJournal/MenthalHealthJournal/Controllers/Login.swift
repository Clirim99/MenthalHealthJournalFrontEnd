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
                Button("Log in") {
                    print("Button tapped!")
                }
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.3))
                .buttonStyle(.bordered)
                .cornerRadius(10)
                .foregroundColor(.white)
                
                Button("Sign up") {
                    print("Button tapped!")
                }
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.3))
                .buttonStyle(.bordered)
                .cornerRadius(10)
                .foregroundColor(.white)
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
