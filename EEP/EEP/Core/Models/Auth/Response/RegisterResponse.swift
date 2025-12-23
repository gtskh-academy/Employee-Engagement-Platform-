//
//  RegisterResponse.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct RegisterResponse: Codable {
    let token: String
    let userId: Int
    let email: String
    let firstName: String
    let lastName: String
    let role: String
    let expiresAt: String
    
    enum CodingKeys: String, CodingKey {
        case token
        case userId
        case email
        case firstName
        case lastName
        case role
        case expiresAt
    }
}

