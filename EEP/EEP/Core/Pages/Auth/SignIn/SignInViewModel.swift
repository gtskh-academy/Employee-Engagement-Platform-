//
//  SignInViewModel.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation
import SwiftUI

class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    
    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var generalError: String?
    
    @Published var isLoading: Bool = false
    @Published var navigateToForgotPassword: Bool = false
    @Published var navigateToSignUp: Bool = false
    @Published var navigateToHome: Bool = false
    
    var authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }
    
    func validateEmail() -> Bool {
        if email.isEmpty {
            emailError = "Email is required"
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: email) {
            emailError = "Invalid email format"
            return false
        }
        
        emailError = nil
        return true
    }
    
    func validatePassword() -> Bool {
        if password.isEmpty {
            passwordError = "Password is required"
            return false
        }
        passwordError = nil
        return true
    }
    
    func validateAll() -> Bool {
        let isValid = validateEmail() && validatePassword()
        if !isValid {
            generalError = nil
        }
        return isValid
    }
    
    func signIn() {
        guard validateAll() else {
            return
        }
        
        isLoading = true
        generalError = nil
        
        let request = LoginRequest(email: email, password: password)
        
        Task {
            do {
                let response = try await AuthService.shared.login(request)
                
                await MainActor.run {
                    // Save token and user info
                    TokenManager.shared.saveAuthResponse(response)
                    
                    // Update AuthViewModel state
                    self.authViewModel.isAuthenticated = true
                    self.authViewModel.currentUser = TokenManager.shared.currentUser
                    
                    if self.rememberMe {
                        // Save remember me preference
                        UserDefaults.standard.set(true, forKey: "rememberMe")
                    }
                    
                    self.isLoading = false
                    // ContentView will automatically switch to MainTabView when isAuthenticated changes
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .serverError(let message):
                            if message.lowercased().contains("invalid") || message.lowercased().contains("password") || message.lowercased().contains("email") {
                                self.generalError = "Invalid email or password"
                            } else {
                                self.generalError = message
                            }
                        case .invalidResponse:
                            self.generalError = "Invalid response from server"
                        }
                    } else {
                        self.generalError = "Failed to sign in: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    func navigateToForgotPasswordScreen() {
        navigateToForgotPassword = true
    }
    
    func navigateToSignUpScreen() {
        navigateToSignUp = true
    }
    
    func clearErrors() {
        emailError = nil
        passwordError = nil
        generalError = nil
    }
}

