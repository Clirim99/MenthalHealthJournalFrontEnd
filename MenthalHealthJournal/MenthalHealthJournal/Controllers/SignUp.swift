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
    @State private var isLoading = false

    @State private var showToast = false
    @State private var toastMessage = ""

    @FocusState private var focusedField: SignUpField?

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundGradient.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        Spacer().frame(height: 20)

                        Text("Create Account")
                            .font(.title.weight(.bold))
                            .foregroundColor(AppTheme.textPrimary)

                        Text("Start your journaling journey")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)

                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                styledField("First name", text: $firstName, field: .firstName, next: .lastName)
                                styledField("Last name", text: $lastName, field: .lastName, next: .username)
                            }

                            styledField("Username", text: $username, field: .username, next: .email)

                            styledField("Email", text: $email, field: .email, next: .password)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)

                            // Password with White Placeholder
                            SecureField("", text: $password, prompt: Text("Password").foregroundColor(.white.opacity(0.7)))
                                .padding(14)
                                .background(AppTheme.inputBg)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppTheme.border, lineWidth: 1)
                                )
                                .foregroundColor(AppTheme.textPrimary)
                                .focused($focusedField, equals: .password)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .confirmPassword }

                            // Confirm Password with White Placeholder
                            SecureField("", text: $confirmPassword, prompt: Text("Confirm password").foregroundColor(.white.opacity(0.7)))
                                .padding(14)
                                .background(AppTheme.inputBg)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppTheme.border, lineWidth: 1)
                                )
                                .foregroundColor(AppTheme.textPrimary)
                                .focused($focusedField, equals: .confirmPassword)
                                .submitLabel(.done)
                                .onSubmit { focusedField = nil }
                        }

                        Button {
                            validateAndRegister()
                        } label: {
                            HStack {
                                if isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Sign Up")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(AppTheme.accent)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                        }
                        .disabled(isLoading)
                        .padding(.top, 8)

                        NavigationLink(destination: Login()) {
                            Text("Already have an account? **Log in**")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.textSecondary)
                        }

                        Spacer().frame(height: 30)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .showToast(text: toastMessage, isShowing: $showToast)
            .navigationDestination(isPresented: $gotToLogin) {
                Login()
            }
        }
    }

    // Helper updated with prompt to make placeholder white
    private func styledField(_ placeholder: String, text: Binding<String>, field: SignUpField, next: SignUpField) -> some View {
        TextField("", text: text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.7)))
            .padding(14)
            .background(AppTheme.inputBg)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.border, lineWidth: 1)
            )
            .foregroundColor(AppTheme.textPrimary)
            .focused($focusedField, equals: field)
            .submitLabel(.next)
            .onSubmit { focusedField = next }
    }

    private func validateAndRegister() {
        if firstName.isEmpty || lastName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showToastMessage("All fields are required!")
        } else if confirmPassword != password {
            showToastMessage("Passwords don't match!")
        } else if !email.contains("@") || !email.contains(".") {
            showToastMessage("Please enter a valid email!")
        } else if password.count < 8 {
            showToastMessage("Password must be at least 8 characters")
        } else if !isValidPassword(password) {
            showToastMessage("Password needs a number and special character (*, %, ^)")
        } else {
            registerNewUser()
        }
    }

    private func showToastMessage(_ text: String) {
        toastMessage = text
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            showToast = false
        }
    }

    func registerNewUser() {
        isLoading = true
        registerUser(
            firstName: firstName,
            lastName: lastName,
            username: username,
            email: email,
            password: password
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    gotToLogin = true
                case .failure(let error):
                    showToastMessage(error.localizedDescription)
                }
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
