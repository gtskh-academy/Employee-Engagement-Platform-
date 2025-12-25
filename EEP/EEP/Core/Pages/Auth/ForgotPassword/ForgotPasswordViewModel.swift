import Foundation
import SwiftUI

class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var emailError: String?
    @Published var isLoading: Bool = false
    @Published var showSuccessMessage: Bool = false
    
    func validateEmail() -> Bool {
        if email.isEmpty {
            emailError = "Email is required"
            return false
        }
        
        if !ValidationUtils.isValidEmail(email) {
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.showSuccessMessage = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.showSuccessMessage = false
            }
        }
    }
    
    func clearErrors() {
        emailError = nil
    }
}

