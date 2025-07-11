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
    
    @State private var showToast = false
    @State private var toastMessage = ""
    
    @FocusState private var focusedField: LoginField?
    
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack {
                    
                    Image("menthalHealthLogo")
                        .resizable()
                        .cornerRadius(60)
                        .frame(width: 120,height: 120)
                        .padding(.top,-60)
                        .padding(.bottom,30)
                    
                    
                    // Spacer()
                    
                    
                    TextField("Email", text: $email)
                        .padding(12) // inner padding like Rounded style
                        .background(Color.white.opacity(0.15)) // field background
                        .cornerRadius(8) // rounded edges
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1) // optional light shadow
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                    
                    SecureField("Password", text: $password)
                        .padding(12) // inner padding like Rounded style
                        .background(Color.white.opacity(0.15)) // field background
                        .cornerRadius(8) // rounded edges
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1) // optional light shadow
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .none
                        }
                    
                    
                    HStack {
                        Button(action: {
                            if email.isEmpty || password.isEmpty {
                                toastMessage = "All fields are required!"
                                showToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    showToast = false
                                }
                            } else {
                                doLogin()
                            }
                        }) {
                            Text("Login")
                                .frame(maxWidth: .infinity, maxHeight: 40)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                                .foregroundColor(.white)
                        }
                        
                        NavigationLink(destination: SignUp()) {
                            Text("Sign up")
                                .frame(maxWidth: .infinity, maxHeight: 40)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                )
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .ignoresSafeArea()
                .alert("Login Failed", isPresented: $showError) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(errorMessage)
                }
                
                // ✅ New way: navigate to FeelingsDscController when login is successful
                .showToast(text: toastMessage, isShowing: $showToast)
                
                .navigationDestination(isPresented: $isLoggedIn) {
                    FeelingsDscController()
                }
            }
        }
    }
        func doLogin() {
            loginUser(email: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        print("✅ Logged in: \(user.first_name ?? ""), Email: \(user.email)")
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
