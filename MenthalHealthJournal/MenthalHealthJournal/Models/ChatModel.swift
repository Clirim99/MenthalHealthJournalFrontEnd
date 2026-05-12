import Foundation

struct ChatSession: Codable, Identifiable {
    let id: String
    let userId: String
    let contextType: String
    let entryId: String?
    let sessionName: String?
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case contextType = "context_type"
        case entryId = "entry_id"
        case sessionName = "session_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ChatMessage: Codable, Identifiable {
    let id: String
    let sessionId: String
    let role: String
    let content: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case sessionId = "session_id"
        case role
        case content
        case createdAt = "created_at"
    }
}

struct ChatRequest: Codable {
    let message: String
    let userId: String
    let sessionId: String?

    enum CodingKeys: String, CodingKey {
        case message
        case userId = "user_id"
        case sessionId = "session_id"
    }
}

struct ChatResponse: Codable {
    let response: String
    let sessionId: String

    enum CodingKeys: String, CodingKey {
        case response
        case sessionId = "session_id"
    }
}

struct CreateChatSessionRequest: Codable {
    let userId: String
    let contextType: String?
    let entryId: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case contextType = "context_type"
        case entryId = "entry_id"
    }
}
