//
//  RegisterRequest.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let department: String
}