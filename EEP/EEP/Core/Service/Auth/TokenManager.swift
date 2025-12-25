//
//  TokenManager.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "authToken"
    private let userKey = "currentUser"
    private let expiresAtKey = "tokenExpiresAt"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            if let token = newValue {
                UserDefaults.standard.set(token, forKey: tokenKey)
                print("🔑 Saved Token to Storage: \(token)")
            } else {
                UserDefaults.standard.removeObject(forKey: tokenKey)
                print("🔑 Token Cleared from Storage")
            }
        }
    }
    
    var currentUser: User? {
        get {
            guard let data = UserDefaults.standard.data(forKey: userKey),
                  let user = try? JSONDecoder().decode(User.self, from: data) else {
                return nil
            }
            return user
        }
        set {
            if let user = newValue, let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: userKey)
            } else {
                UserDefaults.standard.removeObject(forKey: userKey)
            }
        }
    }
    
    var expiresAt: Date? {
        get {
            guard let dateString = UserDefaults.standard.string(forKey: expiresAtKey) else {
                return nil
            }
            let formatter = ISO8601DateFormatter()
            return formatter.date(from: dateString)
        }
        set {
            if let date = newValue {
                let formatter = ISO8601DateFormatter()
                UserDefaults.standard.set(formatter.string(from: date), forKey: expiresAtKey)
            } else {
                UserDefaults.standard.removeObject(forKey: expiresAtKey)
            }
        }
    }
    
    var isTokenValid: Bool {
        guard let token = token, !token.isEmpty else {
            return false
        }
        
        if let expiresAt = expiresAt {
            return expiresAt > Date()
        }
        
        // If no expiration date, assume token is valid if it exists
        return true
    }
    
    func saveAuthResponse(_ response: RegisterResponse, phoneNumber: String? = nil, department: String? = nil) {
        token = response.token
        let user = User(from: response, phoneNumber: phoneNumber, department: department)
        currentUser = user
        
        let formatter = ISO8601DateFormatter()
        if let expiresAt = formatter.date(from: response.expiresAt) {
            self.expiresAt = expiresAt
        }
    }
    
    func clear() {
        token = nil
        currentUser = nil
        expiresAt = nil
    }
}

