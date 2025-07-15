import UIKit
import Foundation

func registerUser(firstName:String, lastName:String, username:String, email:String, password:String, completion: @escaping (Result<User, Error>) -> Void) {
    guard let url = URL(string: ApiEndpoints.localHostIP + "register")  else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        return
    }

    
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    // Encode only the fields needed for registration
    let requestBody = [
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "password": password
    ]

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
    } catch {
        completion(.failure(error))
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "Invalid response", code: -2)))
            return
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let message = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
            completion(.failure(NSError(domain: message, code: httpResponse.statusCode)))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -3)))
            return
        }

        do {
            let registeredUser = try JSONDecoder().decode(User.self, from: data)
            completion(.success(registeredUser))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
    let urlString = ApiEndpoints.localHostIP + "login"
    guard let url = URL(string: urlString) else {
        print("Invalid URL.")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let loginPayload = LoginRequest(email: email.lowercased(), password: password)

    do {
        request.httpBody = try JSONEncoder().encode(loginPayload)
    } catch {
        completion(.failure(error))
        return
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data returned", code: -1, userInfo: nil)))
            return
        }

        do {
            let decoded = try JSONDecoder().decode(LoginResponse.self, from: data)
            completion(.success(decoded.user))
        } catch {
            completion(.failure(error))
        }
    }

    task.resume()
}
