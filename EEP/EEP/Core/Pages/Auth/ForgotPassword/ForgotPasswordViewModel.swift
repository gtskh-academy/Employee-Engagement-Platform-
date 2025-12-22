//
//  ForgotPasswordViewModel.swift
//  EEP
//
//  Created by Giga Cxadiashvili on 23.12.25.
//

import Foundation
import SwiftUI

class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    
    @Published var emailError: String?
    @Published var isLoading: Bool = false
    @Published var showSuccessMessage: Bool = false
    
    @Published var navigateToSignIn: Bool = false
    
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
    
    func sendResetLink() {
        guard validateEmail() else {
            return
        }
        
        isLoading = true
        
        // Dummy reset link sending - non functional as per requirements
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.showSuccessMessage = true
            
            // Clear success message after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.showSuccessMessage = false
            }
        }
    }
    
    func navigateBackToSignIn() {
        navigateToSignIn = true
    }
    
    func clearErrors() {
        emailError = nil
    }
}

