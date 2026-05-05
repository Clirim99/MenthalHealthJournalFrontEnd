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

// MARK: - Journal Entries

func createEntry(content: String, sentimentScore: Int, userId: String, completion: @escaping (Result<Entry, Error>) -> Void) {
    guard let url = URL(string: ApiEndpoints.localHostIP + "entries") else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = CreateEntryRequest(content: content, sentimentScore: sentimentScore, userId: userId)

    do {
        request.httpBody = try JSONEncoder().encode(body)
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

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -3)))
            return
        }

        if httpResponse.statusCode == 201 {
            do {
                let entry = try JSONDecoder().decode(Entry.self, from: data)
                completion(.success(entry))
            } catch {
                completion(.failure(error))
            }
        } else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                completion(.failure(NSError(domain: errorResponse.error, code: httpResponse.statusCode)))
            } else {
                completion(.failure(NSError(domain: "Server error", code: httpResponse.statusCode)))
            }
        }
    }.resume()
}

func getEntriesByUser(userId: String, completion: @escaping (Result<[Entry], Error>) -> Void) {
    guard let url = URL(string: ApiEndpoints.localHostIP + "users/\(userId)/entries") else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "Invalid response", code: -2)))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -3)))
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            do {
                let entries = try JSONDecoder().decode([Entry].self, from: data)
                completion(.success(entries))
            } catch {
                completion(.failure(error))
            }
        } else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                completion(.failure(NSError(domain: errorResponse.error, code: httpResponse.statusCode)))
            } else {
                completion(.failure(NSError(domain: "Server error", code: httpResponse.statusCode)))
            }
        }
    }.resume()
}

func getEntry(id: String, completion: @escaping (Result<Entry, Error>) -> Void) {
    guard let url = URL(string: ApiEndpoints.localHostIP + "entries/\(id)") else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "Invalid response", code: -2)))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -3)))
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            do {
                let entry = try JSONDecoder().decode(Entry.self, from: data)
                completion(.success(entry))
            } catch {
                completion(.failure(error))
            }
        } else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                completion(.failure(NSError(domain: errorResponse.error, code: httpResponse.statusCode)))
            } else {
                completion(.failure(NSError(domain: "entry not found", code: httpResponse.statusCode)))
            }
        }
    }.resume()
}

func updateEntry(id: String, content: String?, sentimentScore: Int?, completion: @escaping (Result<Entry, Error>) -> Void) {
    guard let url = URL(string: ApiEndpoints.localHostIP + "entries/\(id)") else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = UpdateEntryRequest(content: content, sentimentScore: sentimentScore)

    do {
        request.httpBody = try JSONEncoder().encode(body)
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

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -3)))
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            do {
                let entry = try JSONDecoder().decode(Entry.self, from: data)
                completion(.success(entry))
            } catch {
                completion(.failure(error))
            }
        } else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                completion(.failure(NSError(domain: errorResponse.error, code: httpResponse.statusCode)))
            } else {
                completion(.failure(NSError(domain: "Server error", code: httpResponse.statusCode)))
            }
        }
    }.resume()
}

func deleteEntry(id: String, completion: @escaping (Result<DeleteResponse, Error>) -> Void) {
    guard let url = URL(string: ApiEndpoints.localHostIP + "entries/\(id)") else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "Invalid response", code: -2)))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -3)))
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            do {
                let result = try JSONDecoder().decode(DeleteResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        } else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                completion(.failure(NSError(domain: errorResponse.error, code: httpResponse.statusCode)))
            } else {
                completion(.failure(NSError(domain: "entry not found", code: httpResponse.statusCode)))
            }
        }
    }.resume()
}

// MARK: - Chat / RAG

func sendChatMessage(message: String, userId: String, sessionId: String?, completion: @escaping (Result<ChatResponse, Error>) -> Void) {
    guard let url = URL(string: ApiEndpoints.localHostIP + "chat") else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.timeoutInterval = 30

    let body = ChatRequest(message: message, userId: userId, sessionId: sessionId)

    do {
        request.httpBody = try JSONEncoder().encode(body)
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

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -3)))
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            do {
                let chatResponse = try JSONDecoder().decode(ChatResponse.self, from: data)
                completion(.success(chatResponse))
            } catch {
                completion(.failure(error))
            }
        } else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                completion(.failure(NSError(domain: errorResponse.error, code: httpResponse.statusCode)))
            } else {
                completion(.failure(NSError(domain: "Server error", code: httpResponse.statusCode)))
            }
        }
    }.resume()
}

func createChatSession(userId: String, contextType: String?, entryId: String?, completion: @escaping (Result<ChatSession, Error>) -> Void) {
    guard let url = URL(string: ApiEndpoints.localHostIP + "chat/sessions") else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = CreateChatSessionRequest(userId: userId, contextType: contextType, entryId: entryId)

    do {
        request.httpBody = try JSONEncoder().encode(body)
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

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -3)))
            return
        }

        if httpResponse.statusCode == 201 {
            do {
                let session = try JSONDecoder().decode(ChatSession.self, from: data)
                completion(.success(session))
            } catch {
                completion(.failure(error))
            }
        } else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                completion(.failure(NSError(domain: errorResponse.error, code: httpResponse.statusCode)))
            } else {
                completion(.failure(NSError(domain: "Server error", code: httpResponse.statusCode)))
            }
        }
    }.resume()
}

func getChatSession(id: String, completion: @escaping (Result<ChatSession, Error>) -> Void) {
    guard let url = URL(string: ApiEndpoints.localHostIP + "chat/sessions/\(id)") else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "Invalid response", code: -2)))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -3)))
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            do {
                let session = try JSONDecoder().decode(ChatSession.self, from: data)
                completion(.success(session))
            } catch {
                completion(.failure(error))
            }
        } else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                completion(.failure(NSError(domain: errorResponse.error, code: httpResponse.statusCode)))
            } else {
                completion(.failure(NSError(domain: "session not found", code: httpResponse.statusCode)))
            }
        }
    }.resume()
}

func getChatSessionsByUser(userId: String, completion: @escaping (Result<[ChatSession], Error>) -> Void) {
    guard let url = URL(string: ApiEndpoints.localHostIP + "users/\(userId)/chat/sessions") else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "Invalid response", code: -2)))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -3)))
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            do {
                let sessions = try JSONDecoder().decode([ChatSession].self, from: data)
                completion(.success(sessions))
            } catch {
                completion(.failure(error))
            }
        } else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                completion(.failure(NSError(domain: errorResponse.error, code: httpResponse.statusCode)))
            } else {
                completion(.failure(NSError(domain: "Server error", code: httpResponse.statusCode)))
            }
        }
    }.resume()
}

func getChatHistory(sessionId: String, completion: @escaping (Result<[ChatMessage], Error>) -> Void) {
    guard let url = URL(string: ApiEndpoints.localHostIP + "chat/sessions/\(sessionId)/messages") else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "Invalid response", code: -2)))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -3)))
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            do {
                let messages = try JSONDecoder().decode([ChatMessage].self, from: data)
                completion(.success(messages))
            } catch {
                completion(.failure(error))
            }
        } else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                completion(.failure(NSError(domain: errorResponse.error, code: httpResponse.statusCode)))
            } else {
                completion(.failure(NSError(domain: "Server error", code: httpResponse.statusCode)))
            }
        }
    }.resume()
}

func deleteChatSession(id: String, completion: @escaping (Result<DeleteResponse, Error>) -> Void) {
    guard let url = URL(string: ApiEndpoints.localHostIP + "chat/sessions/\(id)") else {
        completion(.failure(NSError(domain: "Invalid URL", code: -1)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NSError(domain: "Invalid response", code: -2)))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -3)))
            return
        }

        if (200...299).contains(httpResponse.statusCode) {
            do {
                let result = try JSONDecoder().decode(DeleteResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        } else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                completion(.failure(NSError(domain: errorResponse.error, code: httpResponse.statusCode)))
            } else {
                completion(.failure(NSError(domain: "session not found", code: httpResponse.statusCode)))
            }
        }
    }.resume()
}
