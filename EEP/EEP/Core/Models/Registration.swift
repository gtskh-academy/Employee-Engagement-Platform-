//
//  Registration.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct RegistrationRequest: Codable {
    let eventId: Int
}

struct RegistrationResponse: Codable {
    let id: Int
    let eventId: Int
    let eventTitle: String
    let userId: Int
    let userEmail: String
    let userName: String
    let department: String?
    let statusId: Int
    let statusName: String
    let registeredAt: String
    let cancelledAt: String?
    let position: Int?
}

