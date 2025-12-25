//
//  VerifyPhoneRequest.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

struct VerifyPhoneRequest: Codable {
    let phoneNumber: String
    let code: String
}


