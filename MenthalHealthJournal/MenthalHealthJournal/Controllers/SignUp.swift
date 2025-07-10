//
//  SignUp.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 28.5.25.
//

import SwiftUI

enum SignUpField: Hashable {
    case firstName, lastName, username, email, password, confirmPassword
}

struct SignUp: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var gotToLogin: Bool = false

    
    @State private var showToast = false
    @State private var toastMessage = ""
    
    @FocusState private var focusedField: SignUpField?
    
    var body: some View {
        NavigationStack {
            
            VStack{
                
                Text("Sign Up")
                    .fontWeight(.heavy)
                // First name
                TextField("First name", text: $firstName)
                    .padding(12)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .focused($focusedField, equals: .firstName)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .lastName
                    }

                // Last name
                TextField("Last name", text: $lastName)
                    .padding(12)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .focused($focusedField, equals: .lastName)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .username
                    }

                // Username
                TextField("Username", text: $username)
                    .padding(12)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .email
                    }

                // Email
                TextField("Email", text: $email)
                    .padding(12)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }

                // Password
                SecureField("Password", text: $password)
                    .padding(12)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .confirmPassword
                    }

                // Confirm Password
                SecureField("Confirm password", text: $confirmPassword)
                    .padding(12)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .focused($focusedField, equals: .confirmPassword)
                    .submitLabel(.done)
                    .onSubmit {
                        focusedField = nil
                    }
                    .padding(.bottom, 30)  // <-- Add this padding


                Button("Sign up") {
                    print("signed up")
                    if firstName.isEmpty || lastName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                        toastMessage = "All fields are required!"
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            showToast = false
                        }
                    }   else if confirmPassword != password {
                        toastMessage = "Password and confirm password must match!"
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            showToast = false
                        }
                    }   else if !email.contains("@") || !email.contains(".") {
                        toastMessage = "Please enter a valid email address!"
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            showToast = false
                        }
                    }   else if password.count < 8 {
                        toastMessage = "Password must be at least 8 characters long"
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            showToast = false
                        }
                    }   else if !isValidPassword(password) {
                        toastMessage = "Password must contain at least one number and one special character (*, %, ^)"
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            showToast = false
                        }
                    }   else {
                        registerNewUser()
                    }
                }
                
                .frame(maxWidth: UIScreen.main.bounds.width / 3)
                .background(Color.gray.opacity(0.3))
                .buttonStyle(.bordered)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
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
            .showToast(text: toastMessage, isShowing: $showToast)
            .navigationDestination(isPresented: $gotToLogin) {
                Login()
            }
        }
    }
    
    func registerNewUser(){
        registerUser(
            firstName: self.firstName,
            lastName: self.lastName,
            username: self.username,
            email: self.email,
            password: self.password
        ) { result in
            switch result {
            case .success(let user):
                print("✅ Registered:", user)
                gotToLogin = true
            case .failure(let error):
                print("❌ Registration failed:", error.localizedDescription)
            }
        }
    }
    func isValidPassword(_ password: String) -> Bool {
        let pattern = "^(?=.*[0-9])(?=.*[*%^]).+$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: password)
    }
}


#Preview {
    SignUp()
}
