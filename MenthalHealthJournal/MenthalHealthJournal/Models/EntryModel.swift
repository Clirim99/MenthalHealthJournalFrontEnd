import Foundation

struct Entry: Codable, Identifiable {
    let id: String
    let userId: String
    let content: String
    let sentimentScore: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case content
        case sentimentScore = "sentiment_score"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct CreateEntryRequest: Codable {
    let content: String
    let sentimentScore: Int
    let userId: String

    enum CodingKeys: String, CodingKey {
        case content
        case sentimentScore = "sentiment_score"
        case userId = "user_id"
    }
}

struct UpdateEntryRequest: Codable {
    let content: String?
    let sentimentScore: Int?

    enum CodingKeys: String, CodingKey {
        case content
        case sentimentScore = "sentiment_score"
    }
}

struct ErrorResponse: Codable {
    let error: String
}

struct DeleteResponse: Codable {
    let message: String
}
