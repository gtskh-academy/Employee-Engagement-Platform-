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
    
    private let userDefaultsKey = "isUserLoggedIn"
    private let userEmailKey = "userEmail"
    
    init() {
        checkAuthenticationState()
    }
    
    func checkAuthenticationState() {
        isAuthenticated = UserDefaults.standard.bool(forKey: userDefaultsKey)
        if isAuthenticated {
            // Load user data if needed
            _ = UserDefaults.standard.string(forKey: userEmailKey)
            // Load user from storage or API
        }
    }
    
    func login(email: String, password: String) -> AuthResult {
        // Dummy validation - replace with actual API call
        if email.isEmpty || password.isEmpty {
            return .failure(.emptyFields)
        }
        
        if !isValidEmail(email) {
            return .failure(.invalidEmail)
        }
        
        // Dummy authentication - replace with actual API call
        // For now, accept any non-empty email/password
        if password.count < 6 {
            return .failure(.wrongCredentials)
        }
        
        // Successful login
        UserDefaults.standard.set(true, forKey: userDefaultsKey)
        UserDefaults.standard.set(email, forKey: userEmailKey)
        isAuthenticated = true
        
        return .success
    }
    
    func logout() {
        UserDefaults.standard.set(false, forKey: userDefaultsKey)
        UserDefaults.standard.removeObject(forKey: userEmailKey)
        isAuthenticated = false
        currentUser = nil
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
