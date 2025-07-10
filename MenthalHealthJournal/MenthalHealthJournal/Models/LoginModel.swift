//
//  Login.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 10.7.25.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}


struct LoginResponse: Codable {
    let message: String
    let user: User
}

