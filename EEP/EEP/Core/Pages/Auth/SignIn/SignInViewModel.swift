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
    
    private let authViewModel: AuthViewModel
    
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
        
        // Use AuthViewModel for authentication
        let result = authViewModel.login(email: email, password: password)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
            
            switch result {
            case .success:
                if self.rememberMe {
                    // Save remember me preference
                    UserDefaults.standard.set(true, forKey: "rememberMe")
                }
                self.navigateToHome = true
            case .failure(let error):
                switch error {
                case .emptyFields:
                    self.generalError = "Please fill in all fields"
                case .invalidEmail:
                    self.emailError = "Invalid email format"
                case .wrongCredentials:
                    self.generalError = "Invalid email or password"
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

