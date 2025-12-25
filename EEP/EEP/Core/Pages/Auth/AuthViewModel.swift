//
//  AuthViewModel.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?
    
    init() {
        checkAuthenticationState()
    }
    
    func checkAuthenticationState() {
        isAuthenticated = TokenManager.shared.isTokenValid
        currentUser = TokenManager.shared.currentUser
        if let token = TokenManager.shared.token {
            print("🔑 Current Token (from checkAuthenticationState): \(token)")
        } else {
            print("🔑 No token found - user not authenticated")
        }
    }
    
    // for backward compatibility but may be removed
    func login(email: String, password: String) -> AuthResult {
        // keeping for backward compatibility
        if email.isEmpty || password.isEmpty {
            return .failure(.emptyFields)
        }
        
        if !isValidEmail(email) {
            return .failure(.invalidEmail)
        }
        
        return .failure(.wrongCredentials)
    }
    
    func logout() {
        TokenManager.shared.clear()
        isAuthenticated = false
        currentUser = nil
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
