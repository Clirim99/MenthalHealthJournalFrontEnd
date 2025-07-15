//
//  User.swift
//  MenthalHealthJournal
//
//  Created by TokioMac on 9.7.25.
//

import Foundation

struct User: Codable {
    let id: String
    let first_name: String?
    let last_name: String?
    let username: String
    let email: String
   // let created_at: String?
    init(){
        self.id = ""
        self.first_name = ""
        self.last_name = ""
        self.username = ""
        self.email = ""
    }
    
}


