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
    
    var authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }
    
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
                    TokenManager.shared.saveAuthResponse(response)
                    self.authViewModel.isAuthenticated = true
                    self.authViewModel.currentUser = TokenManager.shared.currentUser
                    self.isLoading = false
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
    
    func clearErrors() {
        emailError = nil
        passwordError = nil
        generalError = nil
    }
}

