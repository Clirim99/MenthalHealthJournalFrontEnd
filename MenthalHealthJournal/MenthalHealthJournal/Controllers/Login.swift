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
                    VStack(spacing: 24) {
                        Spacer().frame(height: 40)

                        Image("menthalHealthLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 24))

                        Text("Welcome Back")
                            .font(.title.weight(.bold))
                            .foregroundColor(AppTheme.textPrimary)

                        VStack(spacing: 14) {
                            TextField("Email", text: $email)
                                .padding(14)
                                .background(AppTheme.inputBg)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppTheme.border, lineWidth: 1)
                                )
                                .foregroundColor(AppTheme.textPrimary)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .focused($focusedField, equals: .email)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .password }

                            SecureField("Password", text: $password)
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
                        }

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
