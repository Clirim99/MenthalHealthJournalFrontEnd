import SwiftUI

enum LoginField: Hashable {
    case email, password
}

struct Login: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isLoading = false

    @State private var showToast = false
    @State private var toastMessage = ""

    @FocusState private var focusedField: LoginField?

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundGradient.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) { // Changed to 0 to control spacing via padding like HomePage
                        Spacer().frame(height: 40)

                        // Matches HomePage Logic: Large size (320) and 30 corner radius
                        Image("menthalHealthLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 320)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .padding(.bottom, 32)

                        Text("Welcome Back")
                            .font(.system(size: 34, weight: .bold)) // Matches Title Style
                            .foregroundColor(AppTheme.textPrimary)
                            .padding(.bottom, 24)

                        VStack(spacing: 14) {
                            // Email Field with White Placeholder
                            TextField("", text: $email, prompt: Text("Email").foregroundColor(.white.opacity(0.7)))
                                .padding(14)
                                .background(AppTheme.inputBg)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppTheme.border, lineWidth: 1)
                                )
                                .foregroundColor(AppTheme.textPrimary) // This keeps the typed text the theme color
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .focused($focusedField, equals: .email)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .password }

                            // Password Field with White Placeholder
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
                                .submitLabel(.done)
                                .onSubmit { focusedField = nil }
                            
                            // ... rest of your code (Forgot Password, Login Button, etc.)
                        }
                        .padding(.bottom, 24)

                        Button {
                            if email.isEmpty || password.isEmpty {
                                toastMessage = "All fields are required!"
                                showToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    showToast = false
                                }
                            } else {
                                doLogin()
                            }
                        } label: {
                            HStack {
                                if isLoading {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Log In")
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
                        .padding(.bottom, 16)

                        NavigationLink(destination: SignUp()) {
                            Text("Don't have an account? **Sign up**")
                                .font(.subheadline)
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .alert("Login Failed", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .showToast(text: toastMessage, isShowing: $showToast)
            .navigationDestination(isPresented: $isLoggedIn) {
                MainControllerView()
                .navigationBarBackButtonHidden(true)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func doLogin() {
        isLoading = true
        loginUser(email: email, password: password) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let user):
                    UserSession.shared.login(user: user)
                    self.isLoggedIn = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }
}

#Preview {
    Login()
}
