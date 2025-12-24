//
//  User.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let role: String?
    let phoneNumber: String?
    let department: String?
    let isPhoneVerified: Bool?
    
    // For backward compatibility with RegisterResponse
    var userId: Int {
        return id
    }
    
    init(from response: RegisterResponse, phoneNumber: String? = nil, department: String? = nil) {
        self.id = response.userId
        self.email = response.email
        self.firstName = response.firstName
        self.lastName = response.lastName
        self.role = response.role
        self.phoneNumber = phoneNumber
        self.department = department
        self.isPhoneVerified = nil
    }
}

