import Foundation

class UserSession: ObservableObject {
    static let shared = UserSession()

    @Published var currentUser: User?

    var userId: String {
        currentUser?.id ?? ""
    }

    var isLoggedIn: Bool {
        currentUser != nil
    }

    func login(user: User) {
        currentUser = user
    }

    func logout() {
        currentUser = nil
    }
}
